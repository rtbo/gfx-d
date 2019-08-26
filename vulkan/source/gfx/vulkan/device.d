/// Vulkan device module
module gfx.vulkan.device;

package:

import core.time : Duration;

import gfx.bindings.vulkan;

import gfx.core.rc;
import gfx.graal;
import gfx.graal.cmd;
import gfx.graal.device;
import gfx.graal.image;
import gfx.graal.memory;
import gfx.graal.presentation;
import gfx.graal.queue;
import gfx.graal.pipeline;
import gfx.graal.sync;
import gfx.vulkan;
import gfx.vulkan.buffer;
import gfx.vulkan.cmd;
import gfx.vulkan.conv;
import gfx.vulkan.error;
import gfx.vulkan.image;
import gfx.vulkan.memory;
import gfx.vulkan.pipeline;
import gfx.vulkan.queue;
import gfx.vulkan.renderpass;
import gfx.vulkan.sync;
import gfx.vulkan.wsi;

import std.typecons : Flag;

class VulkanDevObj(VkType, string destroyFn) : Disposable
{
    this (VkType vkObj, VulkanDevice dev)
    {
        _vkObj = vkObj;
        _dev = dev;
        _dev.retain();
        _vk = _dev.vk;
    }

    override void dispose() {
        mixin("vk."~destroyFn~"(vkDev, vkObj, null);");
        _dev.release();
        _dev = null;
    }

    final @property VkType vkObj() {
        return _vkObj;
    }

    final @property VulkanDevice dev() {
        return _dev;
    }

    final @property VkDevice vkDev() {
        return _dev.vkObj;
    }

    final @property VkDeviceCmds vk() {
        return _vk;
    }

    private VkType _vkObj;
    private VulkanDevice _dev;
    private VkDeviceCmds _vk;
}

final class VulkanDevice : VulkanObj!(VkDevice), Device
{
    mixin(atomicRcCode);

    this (VkDevice vkObj, VulkanPhysicalDevice pd, Instance inst)
    {
        super(vkObj);
        _pd = pd;
        _inst = inst;
        _inst.retain();
        _vk = new VkDeviceCmds(vkObj, pd.vk);
    }

    override void dispose() {
        vk.DestroyDevice(vkObj, null);
        _pd = null;
        _inst.release();
        _inst = null;
    }

    override @property Instance instance() {
        return _inst;
    }

    override @property PhysicalDevice physicalDevice() {
        return _pd;
    }

    @property VulkanPhysicalDevice pd() {
        return _pd;
    }

    @property VkDeviceCmds vk() {
        return _vk;
    }

    override void waitIdle() {
        vulkanEnforce(
            vk.DeviceWaitIdle(vkObj),
            "Problem waiting for device"
        );
    }

    override Queue getQueue(uint queueFamilyIndex, uint queueIndex) {
        VkQueue vkQ;
        vk.GetDeviceQueue(vkObj, queueFamilyIndex, queueIndex, &vkQ);

        foreach (q; _queues) {
            if (q.vkObj is vkQ) {
                return q;
            }
        }

        auto q = new VulkanQueue(vkQ, this, queueIndex);
        _queues ~= q;
        return q;
    }

    override CommandPool createCommandPool(uint queueFamilyIndex) {
        VkCommandPoolCreateInfo cci;
        cci.sType = VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO;
        cci.queueFamilyIndex = queueFamilyIndex;
        cci.flags = VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT;

        VkCommandPool vkPool;
        vulkanEnforce(
            vk.CreateCommandPool(vkObj, &cci, null, &vkPool),
            "Could not create vulkan command pool"
        );

        return new VulkanCommandPool(vkPool, this);
    }

    override DeviceMemory allocateMemory(uint memTypeIndex, size_t size)
    {
        VkMemoryAllocateInfo mai;
        mai.sType = VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO;
        mai.allocationSize = size;
        mai.memoryTypeIndex = memTypeIndex;

        VkDeviceMemory vkMem;
        vulkanEnforce(vk.AllocateMemory(vkObj, &mai, null, &vkMem), "Could not allocate device memory");

        const props = pd.memoryProperties.types[memTypeIndex].props;

        return new VulkanDeviceMemory(vkMem, this, props, size, memTypeIndex);
    }

    override void flushMappedMemory(MappedMemorySet set)
    {
        import std.algorithm : map;
        import std.array : array;
        VkMappedMemoryRange[] mmrs = set.mms.map!((MappedMemorySet.MM mm) {
            VkMappedMemoryRange mmr;
            mmr.sType = VK_STRUCTURE_TYPE_MAPPED_MEMORY_RANGE;
            mmr.memory = (cast(VulkanDeviceMemory)mm.dm).vkObj;
            mmr.offset = mm.offset;
            mmr.size = mm.size;
            return mmr;
        }).array;

        vk.FlushMappedMemoryRanges(vkObj, cast(uint)mmrs.length, mmrs.ptr);
    }

    override void invalidateMappedMemory(MappedMemorySet set) {
        import std.algorithm : map;
        import std.array : array;
        VkMappedMemoryRange[] mmrs = set.mms.map!((MappedMemorySet.MM mm) {
            VkMappedMemoryRange mmr;
            mmr.sType = VK_STRUCTURE_TYPE_MAPPED_MEMORY_RANGE;
            mmr.memory = (cast(VulkanDeviceMemory)mm.dm).vkObj;
            mmr.offset = mm.offset;
            mmr.size = mm.size;
            return mmr;
        }).array;

        vk.InvalidateMappedMemoryRanges(vkObj, cast(uint)mmrs.length, mmrs.ptr);
    }

    override Buffer createBuffer(BufferUsage usage, size_t size)
    {
        VkBufferCreateInfo bci;
        bci.sType = VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
        bci.size = size;
        bci.usage = bufferUsageToVk(usage);

        VkBuffer vkBuf;
        vulkanEnforce(vk.CreateBuffer(vkObj, &bci, null, &vkBuf), "Could not create a Vulkan buffer");

        return new VulkanBuffer(vkBuf, this, usage, size);
    }

    override Image createImage(in ImageInfo info)
    {
        import gfx.core.util : transmute;

        VkImageCreateInfo ici;
        ici.sType = VK_STRUCTURE_TYPE_IMAGE_CREATE_INFO;
        if (info.type.isCube) ici.flags |= VK_IMAGE_CREATE_CUBE_COMPATIBLE_BIT;
        ici.imageType = info.type.toVk();
        ici.format = info.format.toVk();
        ici.extent = info.dims.transmute!VkExtent3D;
        ici.mipLevels = info.levels;
        ici.arrayLayers = info.layers;
        ici.samples = cast(typeof(ici.samples))info.samples;
        ici.tiling = info.tiling.toVk();
        ici.usage = imageUsageToVk(info.usage);
        ici.sharingMode = VK_SHARING_MODE_EXCLUSIVE;

        VkImage vkImg;
        vulkanEnforce(vk.CreateImage(vkObj, &ici, null, &vkImg), "Could not create a Vulkan image");

        return new VulkanImage(vkImg, this, info);
    }

    Sampler createSampler(in SamplerInfo info) {
        import gfx.core.typecons : ifNone, ifSome;
        import std.algorithm : each;

        VkSamplerCreateInfo sci;
        sci.sType = VK_STRUCTURE_TYPE_SAMPLER_CREATE_INFO;
        sci.minFilter = info.minFilter.toVk();
        sci.magFilter = info.magFilter.toVk();
        sci.mipmapMode = info.mipmapFilter.toVkMipmapMode();
        sci.addressModeU = info.wrapMode[0].toVk();
        sci.addressModeV = info.wrapMode[1].toVk();
        sci.addressModeW = info.wrapMode[2].toVk();
        sci.mipLodBias = info.lodBias;
        info.anisotropy.save.ifSome!((float max) {
            sci.anisotropyEnable = VK_TRUE;
            sci.maxAnisotropy = max;
        }).ifNone!({
            sci.anisotropyEnable = VK_FALSE;
            sci.maxAnisotropy = 1f;
        });
        info.compare.save.each!((CompareOp op) {
            sci.compareEnable = VK_TRUE;
            sci.compareOp = op.toVk();
        });
        sci.minLod = info.lodRange[0];
        sci.maxLod = info.lodRange[1];
        sci.borderColor = info.borderColor.toVk();
        sci.unnormalizedCoordinates = info.unnormalizeCoords ? VK_TRUE : VK_FALSE;

        VkSampler vkS;
        vulkanEnforce(
            vk.CreateSampler(vkObj, &sci, null, &vkS),
            "Could not create Vulkan sampler"
        );

        return new VulkanSampler(vkS, this);
    }

    override Semaphore createSemaphore()
    {
        VkSemaphoreCreateInfo sci;
        sci.sType = VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO;

        VkSemaphore vkSem;
        vulkanEnforce(vk.CreateSemaphore(vkObj, &sci, null, &vkSem), "Could not create a Vulkan semaphore");

        return new VulkanSemaphore(vkSem, this);
    }

    override Fence createFence(Flag!"signaled" signaled)
    {
        VkFenceCreateInfo fci;
        fci.sType = VK_STRUCTURE_TYPE_FENCE_CREATE_INFO;
        if (signaled) {
            fci.flags = VK_FENCE_CREATE_SIGNALED_BIT;
        }
        VkFence vkF;
        vulkanEnforce(vk.CreateFence(vkObj, &fci, null, &vkF), "Could not create a Vulkan fence");

        return new VulkanFence(vkF, this);
    }

    override void resetFences(Fence[] fences) {
        import std.algorithm : map;
        import std.array : array;

        auto vkFs = fences.map!(
            f => enforce(cast(VulkanFence)f, "Did not pass a Vulkan fence").vkObj
        ).array;

        vulkanEnforce(
            vk.ResetFences(vkObj, cast(uint)vkFs.length, &vkFs[0]),
            "Could not reset vulkan fences"
        );
    }

    override void waitForFences(Fence[] fences, Flag!"waitAll" waitAll, Duration timeout)
    {
        import std.algorithm : map;
        import std.array : array;

        auto vkFs = fences.map!(
            f => enforce(cast(VulkanFence)f, "Did not pass a Vulkan fence").vkObj
        ).array;

        const vkWaitAll = waitAll ? VK_TRUE : VK_FALSE;
        const nsecs = timeout.total!"nsecs";
        const vkTimeout = nsecs < 0 ? ulong.max : cast(ulong)nsecs;

        vulkanEnforce(
            vk.WaitForFences(vkObj, cast(uint)vkFs.length, &vkFs[0], vkWaitAll, vkTimeout),
            "could not wait for vulkan fences"
        );
    }


    override Swapchain createSwapchain(Surface graalSurface, PresentMode pm, uint numImages,
                                       Format format, uint[2] size, ImageUsage usage,
                                       CompositeAlpha alpha, Swapchain old=null)
    {
        auto surf = enforce(
            cast(VulkanSurface)graalSurface,
            "Did not pass a Vulkan surface"
        );

        auto oldSc = old ? enforce(
            cast(VulkanSwapchain)old, "Did not pass a vulkan swapchain"
        ) : null;

        VkSwapchainCreateInfoKHR sci;
        sci.sType = VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR;
        sci.surface = surf.vkObj;
        sci.minImageCount = numImages;
        sci.imageFormat = format.toVk;
        sci.imageExtent = VkExtent2D(size[0], size[1]);
        sci.imageArrayLayers = 1;
        sci.imageUsage = imageUsageToVk(usage);
        sci.imageColorSpace = VK_COLOR_SPACE_SRGB_NONLINEAR_KHR;
        sci.preTransform = VK_SURFACE_TRANSFORM_IDENTITY_BIT_KHR;
        sci.clipped = VK_TRUE;
        sci.presentMode = pm.toVk;
        sci.compositeAlpha = compositeAlphaToVk(alpha);
        sci.oldSwapchain = oldSc ? oldSc.vkObj : VK_NULL_ND_HANDLE;

        VkSwapchainKHR vkSc;
        vulkanEnforce(
            vk.CreateSwapchainKHR(vkObj, &sci, null, &vkSc),
            "Could not create a Vulkan Swap chain"
        );

        return new VulkanSwapchain(vkSc, this, graalSurface, size, format, usage);
    }

    override RenderPass createRenderPass(in AttachmentDescription[] attachments,
                                         in SubpassDescription[] subpasses,
                                         in SubpassDependency[] dependencies)
    {
        import std.algorithm : map;
        import std.array : array;

        auto vkAttachments = attachments.map!((ref const(AttachmentDescription) ad) {
            VkAttachmentDescription vkAd;
            if (ad.mayAlias) {
                vkAd.flags = VK_ATTACHMENT_DESCRIPTION_MAY_ALIAS_BIT;
            }
            vkAd.format = ad.format.toVk();
            vkAd.loadOp = ad.ops.load.toVk();
            vkAd.storeOp = ad.ops.store.toVk();
            vkAd.stencilLoadOp = ad.stencilOps.load.toVk();
            vkAd.stencilStoreOp = ad.stencilOps.store.toVk();
            vkAd.initialLayout = ad.layoutTrans.from.toVk();
            vkAd.finalLayout = ad.layoutTrans.to.toVk();
            return vkAd;
        }).array;

        static VkAttachmentReference mapRef (in AttachmentRef ar) {
            return VkAttachmentReference(ar.attachment, ar.layout.toVk());
        }
        static VkAttachmentReference[] mapRefs(in AttachmentRef[] ars) {
            return ars.map!mapRef.array;
        }
        auto vkSubpasses = subpasses.map!((ref const(SubpassDescription) sd) {
            auto vkInputs = mapRefs(sd.inputs);
            auto vkColors = mapRefs(sd.colors);
            auto vkDepthStencil = sd.depthStencil.save.map!(mapRef).array;
            VkSubpassDescription vkSd;
            vkSd.pipelineBindPoint = VK_PIPELINE_BIND_POINT_GRAPHICS;
            vkSd.inputAttachmentCount = cast(uint)vkInputs.length;
            vkSd.pInputAttachments = vkInputs.ptr;
            vkSd.colorAttachmentCount = cast(uint)vkColors.length;
            vkSd.pColorAttachments = vkColors.ptr;
            vkSd.pDepthStencilAttachment = vkDepthStencil.length ?
                    vkDepthStencil.ptr : null;
            vkSd.preserveAttachmentCount = cast(uint)sd.preserves.length;
            vkSd.pPreserveAttachments = sd.preserves.ptr;
            return vkSd;
        }).array;

        auto vkDeps = dependencies.map!((ref const(SubpassDependency) sd) {
            VkSubpassDependency vkSd;
            vkSd.srcSubpass = sd.subpass.from;
            vkSd.dstSubpass = sd.subpass.to;
            vkSd.srcStageMask = pipelineStageToVk(sd.stageMask.from);
            vkSd.dstStageMask = pipelineStageToVk(sd.stageMask.to);
            vkSd.srcAccessMask = accessToVk(sd.accessMask.from);
            vkSd.dstAccessMask = accessToVk(sd.accessMask.to);
            return vkSd;
        }).array;

        VkRenderPassCreateInfo rpci;
        rpci.sType = VK_STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO;
        rpci.attachmentCount = cast(uint)vkAttachments.length;
        rpci.pAttachments = vkAttachments.ptr;
        rpci.subpassCount = cast(uint)vkSubpasses.length;
        rpci.pSubpasses = vkSubpasses.ptr;
        rpci.dependencyCount = cast(uint)vkDeps.length;
        rpci.pDependencies = vkDeps.ptr;

        VkRenderPass vkRp;
        vulkanEnforce(
            vk.CreateRenderPass(vkObj, &rpci, null, &vkRp),
            "Could not create a Vulkan render pass"
        );

        return new VulkanRenderPass(vkRp, this);
    }


    override Framebuffer createFramebuffer(RenderPass rp, ImageView[] attachments,
                                           uint width, uint height, uint layers)
    {
        import std.algorithm : map;
        import std.array : array;

        auto vkRp = enforce(cast(VulkanRenderPass)rp, "Did not pass a Vulkan render pass").vkObj;
        auto vkAttachments = attachments.map!(
            iv => enforce(cast(VulkanImageView)iv, "Did not pass a Vulkan image view").vkObj
        ).array;

        VkFramebufferCreateInfo fci;
        fci.sType = VK_STRUCTURE_TYPE_FRAMEBUFFER_CREATE_INFO;
        fci.renderPass = vkRp;
        fci.attachmentCount = cast(uint)vkAttachments.length;
        fci.pAttachments = vkAttachments.ptr;
        fci.width = width;
        fci.height = height;
        fci.layers = layers;

        VkFramebuffer vkFb;
        vulkanEnforce(
            vk.CreateFramebuffer(vkObj, &fci, null, &vkFb),
            "Could not create a Vulkan Framebuffer"
        );

        return new VulkanFramebuffer(vkFb, this, attachments);
    }

    override ShaderModule createShaderModule(const(uint)[] code, string entryPoint)
    {
        VkShaderModuleCreateInfo smci;
        smci.sType = VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO;
        smci.codeSize = cast(uint)code.length * 4;
        smci.pCode = code.ptr;

        VkShaderModule vkSm;
        vulkanEnforce(
            vk.CreateShaderModule(vkObj, &smci, null, &vkSm),
            "Could not create Vulkan shader module"
        );

        return new VulkanShaderModule(vkSm, this, entryPoint);
    }

    override DescriptorSetLayout createDescriptorSetLayout(in PipelineLayoutBinding[] bindings)
    {
        import std.algorithm : map;
        import std.array : array;

        auto vkBindings = bindings.map!(b => VkDescriptorSetLayoutBinding(
            b.binding, b.descriptorType.toVk(), b.descriptorCount, shaderStageToVk(b.stages), null
        )).array;

        VkDescriptorSetLayoutCreateInfo ci;
        ci.sType = VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO;
        ci.bindingCount = cast(uint)vkBindings.length;
        ci.pBindings = vkBindings.ptr;

        VkDescriptorSetLayout vkL;
        vulkanEnforce(
            vk.CreateDescriptorSetLayout(vkObj, &ci, null, &vkL),
            "Could not create Vulkan descriptor set layout"
        );

        return new VulkanDescriptorSetLayout(vkL, this);
    }

    override PipelineLayout createPipelineLayout(DescriptorSetLayout[] layouts,
                                                 in PushConstantRange[] ranges)
    {
        import std.algorithm : map;
        import std.array : array;

        auto vkLayouts = layouts.map!(
            l => enforce(
                cast(VulkanDescriptorSetLayout)l,
                "VulkanDevice.createPipelineLayout: Did not supply a Vulkan DescriptorSetLayout"
            ).vkObj
        ).array;
        auto vkRanges = ranges.map!(
            r => VkPushConstantRange( shaderStageToVk(r.stages), r.offset, r.size )
        ).array;

        VkPipelineLayoutCreateInfo ci;
        ci.sType = VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO;
        ci.setLayoutCount = cast(uint)vkLayouts.length;
        ci.pSetLayouts = vkLayouts.ptr;
        ci.pushConstantRangeCount = cast(uint)vkRanges.length;
        ci.pPushConstantRanges = vkRanges.ptr;

        VkPipelineLayout vkPl;
        vulkanEnforce(
            vk.CreatePipelineLayout(vkObj, &ci, null, &vkPl),
            "Could not create Vulkan pipeline layout"
        );
        return new VulkanPipelineLayout(vkPl, this, layouts, ranges);
    }

    override DescriptorPool createDescriptorPool(in uint maxSets, in DescriptorPoolSize[] sizes)
    {
        import std.algorithm : map;
        import std.array : array;

        auto vkSizes = sizes.map!(
            s => VkDescriptorPoolSize(s.type.toVk(), s.count)
        ).array;

        VkDescriptorPoolCreateInfo ci;
        ci.sType = VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO;
        ci.maxSets = maxSets;
        ci.poolSizeCount = cast(uint)vkSizes.length;
        ci.pPoolSizes = vkSizes.ptr;

        VkDescriptorPool vkP;
        vulkanEnforce(
            vk.CreateDescriptorPool(vkObj, &ci, null, &vkP),
            "Could not create Vulkan Descriptor Pool"
        );

        return new VulkanDescriptorPool(vkP, this);
    }

    override void updateDescriptorSets(WriteDescriptorSet[] writeOps, CopyDescritporSet[] copyOps)
    {
        import gfx.core.util : unsafeCast;
        import std.algorithm : map;
        import std.array : array;

        auto vkWrites = writeOps.map!((WriteDescriptorSet wds) {
            VkWriteDescriptorSet vkWds;
            vkWds.sType = VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET;
            vkWds.dstSet = enforce(cast(VulkanDescriptorSet)wds.dstSet).vkObj;
            vkWds.dstBinding = wds.dstBinding;
            vkWds.dstArrayElement = wds.dstArrayElem;
            vkWds.descriptorCount = cast(uint)wds.write.count;
            vkWds.descriptorType = wds.write.type.toVk();

            final switch (wds.write.type) {
            case DescriptorType.sampler:
                auto sds = wds.write.samplers;
                auto vkArr = sds.map!((SamplerDescriptor sd) {
                    VkDescriptorImageInfo dii;
                    dii.sampler = unsafeCast!(VulkanSampler)(sd.sampler).vkObj;
                    return dii;
                }).array;
                vkWds.pImageInfo = vkArr.ptr;
                break;
            case DescriptorType.combinedImageSampler:
                auto sids = wds.write.imageSamplers;
                auto vkArr = sids.map!((ImageSamplerDescriptor sid) {
                    VkDescriptorImageInfo dii;
                    dii.sampler = unsafeCast!(VulkanSampler)(sid.sampler).vkObj;
                    dii.imageView = unsafeCast!(VulkanImageView)(sid.view).vkObj;
                    dii.imageLayout = sid.layout.toVk();
                    return dii;
                }).array;
                vkWds.pImageInfo = vkArr.ptr;
                break;
            case DescriptorType.sampledImage:
            case DescriptorType.storageImage:
            case DescriptorType.inputAttachment:
                auto ids = wds.write.images;
                auto vkArr = ids.map!((ImageDescriptor id) {
                    VkDescriptorImageInfo dii;
                    dii.imageView = unsafeCast!(VulkanImageView)(id.view).vkObj;
                    dii.imageLayout = id.layout.toVk();
                    return dii;
                }).array;
                vkWds.pImageInfo = vkArr.ptr;
                break;
            case DescriptorType.uniformBuffer:
            case DescriptorType.storageBuffer:
            case DescriptorType.uniformBufferDynamic:
            case DescriptorType.storageBufferDynamic:
                auto bds = wds.write.buffers;
                auto vkArr = bds.map!((BufferDescriptor bd) {
                    VkDescriptorBufferInfo dbi;
                    dbi.buffer = unsafeCast!(VulkanBuffer)(bd.buffer).vkObj;
                    dbi.offset = bd.offset;
                    dbi.range = bd.size;
                    if (bd.size > 1000000) {
                        asm { int 0x03; }
                    }
                    return dbi;
                }).array;
                vkWds.pBufferInfo = vkArr.ptr;
                break;
            case DescriptorType.uniformTexelBuffer:
            case DescriptorType.storageTexelBuffer:
                auto tbds = wds.write.texelBuffers;
                auto vkArr = tbds.map!((TexelBufferDescriptor tbd) {
                    return unsafeCast!(VulkanTexelBufferView)(tbd.bufferView).vkObj;
                }).array;
                vkWds.pTexelBufferView = vkArr.ptr;
                break;
            }

            return vkWds;
        }).array;

        auto vkCopies = copyOps.map!((CopyDescritporSet cds) {
            VkCopyDescriptorSet vkCds;
            vkCds.sType = VK_STRUCTURE_TYPE_COPY_DESCRIPTOR_SET;
            vkCds.srcSet = enforce(cast(VulkanDescriptorSet)cds.set.from).vkObj;
            vkCds.srcBinding = cds.binding.from;
            vkCds.srcArrayElement = cds.arrayElem.from;
            vkCds.dstSet = enforce(cast(VulkanDescriptorSet)cds.set.to).vkObj;
            vkCds.dstBinding = cds.binding.to;
            vkCds.dstArrayElement = cds.arrayElem.to;
            return vkCds;
        }).array;

        vk.UpdateDescriptorSets(vkObj,
            cast(uint)vkWrites.length, vkWrites.ptr,
            cast(uint)vkCopies.length, vkCopies.ptr
        );
    }

    override Pipeline[] createPipelines(PipelineInfo[] infos) {
        import gfx.core.util : transmute;
        import std.algorithm : map, max;
        import std.array : array;
        import std.string : toStringz;

        auto pcis = new VkGraphicsPipelineCreateInfo[infos.length];

        foreach (i; 0 .. infos.length) {
            VkPipelineShaderStageCreateInfo[] sscis;
            void addShaderStage(ShaderModule sm, ShaderStage ss) {
                VkPipelineShaderStageCreateInfo ssci;
                ssci.sType = VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO;
                ssci.stage = shaderStageToVk(ss);
                ssci.module_ = enforce(
                    cast(VulkanShaderModule)sm,
                    "did not pass a Vulkan shader module"
                ).vkObj;
                ssci.pName = toStringz(sm.entryPoint);
                sscis ~= ssci;
            }
            auto shaders = infos[i].shaders;
            enforce(shaders.vertex, "Vertex input shader is mandatory");
            addShaderStage(shaders.vertex, ShaderStage.vertex);
            if (shaders.tessControl)
                addShaderStage(shaders.tessControl, ShaderStage.tessellationControl);
            if (shaders.tessEval)
                addShaderStage(shaders.tessEval, ShaderStage.tessellationEvaluation);
            if (shaders.geometry)
                addShaderStage(shaders.geometry, ShaderStage.geometry);
            if (shaders.fragment)
                addShaderStage(shaders.fragment, ShaderStage.fragment);


            auto vkInputBindings = infos[i].inputBindings.map!(
                ib => VkVertexInputBindingDescription(
                    ib.binding, cast(uint)ib.stride,
                    ib.instanced ?
                            VK_VERTEX_INPUT_RATE_INSTANCE :
                            VK_VERTEX_INPUT_RATE_VERTEX
                )
            ).array;

            auto vkInputAttribs = infos[i].inputAttribs.map!(
                ia => VkVertexInputAttributeDescription(
                    ia.location, ia.binding, ia.format.toVk(), cast(uint)ia.offset
                )
            ).array;

            auto vkVtxInput = new VkPipelineVertexInputStateCreateInfo;
            vkVtxInput.sType = VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO;
            vkVtxInput.vertexBindingDescriptionCount = cast(uint)vkInputBindings.length;
            vkVtxInput.pVertexBindingDescriptions = vkInputBindings.ptr;
            vkVtxInput.vertexAttributeDescriptionCount = cast(uint)vkInputAttribs.length;
            vkVtxInput.pVertexAttributeDescriptions = vkInputAttribs.ptr;

            auto vkAssy = new VkPipelineInputAssemblyStateCreateInfo;
            vkAssy.sType = VK_STRUCTURE_TYPE_PIPELINE_INPUT_ASSEMBLY_STATE_CREATE_INFO;
            vkAssy.topology = infos[i].assembly.primitive.toVk();
            vkAssy.primitiveRestartEnable = infos[i].assembly.primitiveRestart ? VK_TRUE : VK_FALSE;

            auto vkViewport = new VkPipelineViewportStateCreateInfo;
            vkViewport.sType = VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_STATE_CREATE_INFO;
            if (infos[i].viewports.length) {
                auto vkViewports = infos[i].viewports.map!(vc => vc.viewport).map!(
                    vp => VkViewport(vp.x, vp.y, vp.width, vp.height, vp.minDepth, vp.maxDepth)
                ).array;
                auto vkScissors = infos[i].viewports.map!(vc => vc.scissors).map!(
                    r => VkRect2D(VkOffset2D(r.x, r.y), VkExtent2D(r.width, r.height))
                ).array;
                vkViewport.viewportCount = cast(uint)infos[i].viewports.length;
                vkViewport.pViewports = vkViewports.ptr;
                vkViewport.scissorCount = cast(uint)infos[i].viewports.length;
                vkViewport.pScissors = vkScissors.ptr;
            }
            else {
                static const dummyVp = VkViewport(0f, 0f, 1f, 1f, 0f, 1f);
                static const dummySc = VkRect2D(VkOffset2D(0, 0), VkExtent2D(1, 1));
                vkViewport.viewportCount = 1;
                vkViewport.pViewports = &dummyVp;
                vkViewport.scissorCount = 1;
                vkViewport.pScissors = &dummySc;
            }

            auto vkRasterizer = new VkPipelineRasterizationStateCreateInfo;
            vkRasterizer.sType = VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_CREATE_INFO;
            vkRasterizer.rasterizerDiscardEnable = shaders.fragment ? VK_FALSE : VK_TRUE;
            vkRasterizer.polygonMode = infos[i].rasterizer.mode.toVk();
            vkRasterizer.cullMode = cullModeToVk(infos[i].rasterizer.cull);
            vkRasterizer.frontFace = infos[i].rasterizer.front.toVk();
            vkRasterizer.lineWidth = infos[i].rasterizer.lineWidth;
            vkRasterizer.depthClampEnable = infos[i].rasterizer.depthClamp ? VK_TRUE : VK_FALSE;
            if (infos[i].rasterizer.depthBias.isSome) {
                DepthBias db = infos[i].rasterizer.depthBias.get;
                vkRasterizer.depthBiasEnable = VK_TRUE;
                vkRasterizer.depthBiasConstantFactor = db.constantFactor;
                vkRasterizer.depthBiasClamp = db.clamp;
                vkRasterizer.depthBiasSlopeFactor = db.slopeFactor;
            }
            else {
                vkRasterizer.depthBiasConstantFactor = 0f;
                vkRasterizer.depthBiasClamp = 0f;
                vkRasterizer.depthBiasSlopeFactor = 0f;
            }

            const depthInfo = infos[i].depthInfo;
            const stencilInfo = infos[i].stencilInfo;
            auto vkDepthStencil = new VkPipelineDepthStencilStateCreateInfo;
            vkDepthStencil.sType = VK_STRUCTURE_TYPE_PIPELINE_DEPTH_STENCIL_STATE_CREATE_INFO;
            vkDepthStencil.depthTestEnable = flagToVk(depthInfo.enabled);
            vkDepthStencil.depthWriteEnable = flagToVk(depthInfo.write);
            vkDepthStencil.depthCompareOp = depthInfo.compareOp.toVk();
            vkDepthStencil.depthBoundsTestEnable = flagToVk(depthInfo.boundsTest);
            vkDepthStencil.stencilTestEnable = flagToVk(stencilInfo.enabled);
            vkDepthStencil.front = transmute!VkStencilOpState(stencilInfo.front);
            vkDepthStencil.back = transmute!VkStencilOpState(stencilInfo.back);
            vkDepthStencil.minDepthBounds = depthInfo.minBounds;
            vkDepthStencil.maxDepthBounds = depthInfo.maxBounds;

            const blendInfo = infos[i].blendInfo;
            auto vkColorAttachments = blendInfo.attachments.map!(
                cba => VkPipelineColorBlendAttachmentState (
                    cba.enabled ? VK_TRUE : VK_FALSE,
                    cba.colorBlend.factor.from.toVk(),
                    cba.colorBlend.factor.to.toVk(),
                    cba.colorBlend.op.toVk(),
                    cba.alphaBlend.factor.from.toVk(),
                    cba.alphaBlend.factor.to.toVk(),
                    cba.alphaBlend.op.toVk(),
                    cast(VkColorComponentFlags)cba.colorMask
                )
            ).array;
            auto vkBlend = new VkPipelineColorBlendStateCreateInfo;
            vkBlend.sType = VK_STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_STATE_CREATE_INFO;
            if (blendInfo.logicOp.isSome) {
                vkBlend.logicOpEnable = VK_TRUE;
                vkBlend.logicOp = blendInfo.logicOp.get.toVk();
            }
            vkBlend.attachmentCount = cast(uint)vkColorAttachments.length;
            vkBlend.pAttachments = vkColorAttachments.ptr;
            vkBlend.blendConstants = blendInfo.blendConstants;

            VkPipelineDynamicStateCreateInfo *vkDynStatesInfo;
            if (infos[i].dynamicStates) {
                auto vkDynStates = infos[i].dynamicStates.map!(ds => ds.toVk()).array;
                vkDynStatesInfo = new VkPipelineDynamicStateCreateInfo;
                vkDynStatesInfo.sType = VK_STRUCTURE_TYPE_PIPELINE_DYNAMIC_STATE_CREATE_INFO;
                vkDynStatesInfo.dynamicStateCount = cast(uint)vkDynStates.length;
                vkDynStatesInfo.pDynamicStates = vkDynStates.ptr;
            }

            auto rp = infos[i].renderPass;
            auto vkRp = rp ? enforce(
                cast(VulkanRenderPass)rp,
                "did not supply a Vulkan render pass"
            ).vkObj : VK_NULL_ND_HANDLE;

            // following bindings are not implemented yet
            auto vkTess = new VkPipelineTessellationStateCreateInfo;
            vkTess.sType = VK_STRUCTURE_TYPE_PIPELINE_TESSELLATION_STATE_CREATE_INFO;
            auto vkMs = new VkPipelineMultisampleStateCreateInfo;
            vkMs.sType = VK_STRUCTURE_TYPE_PIPELINE_MULTISAMPLE_STATE_CREATE_INFO;
            vkMs.minSampleShading = 1f;

            pcis[i].sType = VK_STRUCTURE_TYPE_GRAPHICS_PIPELINE_CREATE_INFO;
            pcis[i].stageCount = cast(uint)sscis.length;
            pcis[i].pStages = sscis.ptr;
            pcis[i].pVertexInputState = vkVtxInput;
            pcis[i].pInputAssemblyState = vkAssy;
            pcis[i].pTessellationState = vkTess;
            pcis[i].pViewportState = vkViewport;
            pcis[i].pRasterizationState = vkRasterizer;
            pcis[i].pMultisampleState = vkMs;
            pcis[i].pDepthStencilState = vkDepthStencil;
            pcis[i].pColorBlendState = vkBlend;
            pcis[i].pDynamicState = vkDynStatesInfo;
            pcis[i].layout = enforce(
                cast(VulkanPipelineLayout)infos[i].layout,
                "did not pass a valid vulkan pipeline layout"
            ).vkObj;
            pcis[i].renderPass = vkRp;
            pcis[i].subpass = infos[i].subpassIndex;
            pcis[i].basePipelineIndex = -1;
        }

        auto vkPls = new VkPipeline[infos.length];
        vulkanEnforce(
            vk.CreateGraphicsPipelines(vkObj, VK_NULL_ND_HANDLE, cast(uint)pcis.length, pcis.ptr, null, vkPls.ptr),
            "Could not create Vulkan graphics pipeline"
        );

        auto pls = new Pipeline[infos.length];
        foreach (i; 0 .. vkPls.length) {
            pls[i] = new VulkanPipeline(vkPls[i], this, infos[i].layout);
        }
        return pls;
    }

    private Instance _inst;
    private VulkanPhysicalDevice _pd;
    private VkDeviceCmds _vk;
    private VulkanQueue[] _queues;
}
