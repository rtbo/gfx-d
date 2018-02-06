/// Vulkan device module
module gfx.vulkan.device;

package:

import core.time : Duration;

import gfx.bindings.vulkan;

import gfx.core.rc;
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
    this (VkType vk, VulkanDevice dev)
    {
        _vk = vk;
        _dev = dev;
        _dev.retain();
        _cmds = _dev.cmds;
    }

    override void dispose() {
        mixin("cmds."~destroyFn~"(vkDev, vk, null);");
        _dev.release();
        _dev = null;
    }

    final @property VkType vk() {
        return _vk;
    }

    final @property VulkanDevice dev() {
        return _dev;
    }

    final @property VkDevice vkDev() {
        return _dev.vk;
    }

    final @property VkDeviceCmds cmds() {
        return _cmds;
    }

    private VkType _vk;
    private VulkanDevice _dev;
    private VkDeviceCmds _cmds;
}

final class VulkanDevice : VulkanObj!(VkDevice), Device
{
    mixin(atomicRcCode);

    this (VkDevice vk, VulkanPhysicalDevice pd)
    {
        super(vk);
        _pd = pd;
        _pd.retain();
        _cmds = new VkDeviceCmds(vk, pd.cmds);
    }

    override void dispose() {
        cmds.destroyDevice(vk, null);
        _pd.release();
        _pd = null;
    }

    @property VulkanPhysicalDevice pd() {
        return _pd;
    }

    @property VkDeviceCmds cmds() {
        return _cmds;
    }

    override void waitIdle() {
        vulkanEnforce(
            cmds.deviceWaitIdle(vk),
            "Problem waiting for device"
        );
    }

    override Queue getQueue(uint queueFamilyIndex, uint queueIndex) {
        VkQueue vkQ;
        cmds.getDeviceQueue(vk, queueFamilyIndex, queueIndex, &vkQ);

        foreach (q; _queues) {
            if (q.vk is vkQ) {
                return q;
            }
        }

        auto q = new VulkanQueue(vkQ, this);
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
            cmds.createCommandPool(vk, &cci, null, &vkPool),
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
        vulkanEnforce(cmds.allocateMemory(vk, &mai, null, &vkMem), "Could not allocate device memory");

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
            mmr.memory = (cast(VulkanDeviceMemory)mm.dm).vk;
            mmr.offset = mm.offset;
            mmr.size = mm.size;
            return mmr;
        }).array;

        cmds.flushMappedMemoryRanges(vk, cast(uint)mmrs.length, mmrs.ptr);
    }

    override void invalidateMappedMemory(MappedMemorySet set) {
        import std.algorithm : map;
        import std.array : array;
        VkMappedMemoryRange[] mmrs = set.mms.map!((MappedMemorySet.MM mm) {
            VkMappedMemoryRange mmr;
            mmr.sType = VK_STRUCTURE_TYPE_MAPPED_MEMORY_RANGE;
            mmr.memory = (cast(VulkanDeviceMemory)mm.dm).vk;
            mmr.offset = mm.offset;
            mmr.size = mm.size;
            return mmr;
        }).array;

        cmds.invalidateMappedMemoryRanges(vk, cast(uint)mmrs.length, mmrs.ptr);
    }

    override Buffer createBuffer(BufferUsage usage, size_t size)
    {
        VkBufferCreateInfo bci;
        bci.sType = VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
        bci.size = size;
        bci.usage = bufferUsageToVk(usage);

        VkBuffer vkBuf;
        vulkanEnforce(cmds.createBuffer(vk, &bci, null, &vkBuf), "Could not create a Vulkan buffer");

        return new VulkanBuffer(vkBuf, this, usage, size);
    }

    override Image createImage(ImageType type, ImageDims dims, Format format,
                               ImageUsage usage, uint samples, uint levels=1)
    {
        VkImageCreateInfo ici;
        ici.sType = VK_STRUCTURE_TYPE_IMAGE_CREATE_INFO;
        if (type.isCube) ici.flags |= VK_IMAGE_CREATE_CUBE_COMPATIBLE_BIT;
        ici.imageType = type.toVk();
        ici.format = format.toVk();
        ici.extent = VkExtent3D(dims.width, dims.height, dims.depth);
        ici.mipLevels = levels;
        ici.arrayLayers = dims.layers;
        ici.samples = cast(typeof(ici.samples))samples;
        ici.tiling = VK_IMAGE_TILING_OPTIMAL;
        ici.usage = imageUsageToVk(usage);
        ici.sharingMode = VK_SHARING_MODE_EXCLUSIVE;

        VkImage vkImg;
        vulkanEnforce(cmds.createImage(vk, &ici, null, &vkImg), "Could not create a Vulkan image");

        return new VulkanImage(vkImg, this, type, dims, format);
    }

    Sampler createSampler(in SamplerInfo info) {
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
        info.anisotropy.save.each!((float max) {
            sci.anisotropyEnable = VK_TRUE;
            sci.maxAnisotropy = max;
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
            cmds.createSampler(vk, &sci, null, &vkS),
            "Could not create Vulkan sampler"
        );

        return new VulkanSampler(vkS, this);
    }

    override Semaphore createSemaphore()
    {
        VkSemaphoreCreateInfo sci;
        sci.sType = VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO;

        VkSemaphore vkSem;
        vulkanEnforce(cmds.createSemaphore(vk, &sci, null, &vkSem), "Could not create a Vulkan semaphore");

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
        vulkanEnforce(cmds.createFence(vk, &fci, null, &vkF), "Could not create a Vulkan fence");

        return new VulkanFence(vkF, this);
    }

    override void resetFences(Fence[] fences) {
        import std.algorithm : map;
        import std.array : array;

        auto vkFs = fences.map!(
            f => enforce(cast(VulkanFence)f, "Did not pass a Vulkan fence").vk
        ).array;

        vulkanEnforce(
            cmds.resetFences(vk, cast(uint)vkFs.length, &vkFs[0]),
            "Could not reset vulkan fences"
        );
    }

    override void waitForFences(Fence[] fences, Flag!"waitAll" waitAll, Duration timeout)
    {
        import std.algorithm : map;
        import std.array : array;

        auto vkFs = fences.map!(
            f => enforce(cast(VulkanFence)f, "Did not pass a Vulkan fence").vk
        ).array;

        const vkWaitAll = waitAll ? VK_TRUE : VK_FALSE;
        const nsecs = timeout.total!"nsecs";
        const vkTimeout = nsecs < 0 ? ulong.max : cast(ulong)nsecs;

        vulkanEnforce(
            cmds.waitForFences(vk, cast(uint)vkFs.length, &vkFs[0], vkWaitAll, vkTimeout),
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
        sci.surface = surf.vk;
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
        sci.oldSwapchain = oldSc ? oldSc.vk : VK_NULL_ND_HANDLE;

        VkSwapchainKHR vkSc;
        vulkanEnforce(
            cmds.createSwapchainKHR(vk, &sci, null, &vkSc),
            "Could not create a Vulkan Swap chain"
        );

        return new VulkanSwapchain(vkSc, this, size, format);
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
            vkAd.loadOp = ad.colorDepthOps.load.toVk();
            vkAd.storeOp = ad.colorDepthOps.store.toVk();
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
            cmds.createRenderPass(vk, &rpci, null, &vkRp),
            "Could not create a Vulkan render pass"
        );

        return new VulkanRenderPass(vkRp, this);
    }


    override Framebuffer createFramebuffer(RenderPass rp, ImageView[] attachments,
                                           uint width, uint height, uint layers)
    {
        import std.algorithm : map;
        import std.array : array;

        auto vkRp = enforce(cast(VulkanRenderPass)rp, "Did not pass a Vulkan render pass").vk;
        auto vkAttachments = attachments.map!(
            iv => enforce(cast(VulkanImageView)iv, "Did not pass a Vulkan image view").vk
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
            cmds.createFramebuffer(vk, &fci, null, &vkFb),
            "Could not create a Vulkan Framebuffer"
        );

        return new VulkanFramebuffer(vkFb, this, attachments);
    }

    override ShaderModule createShaderModule(ShaderLanguage sl, string code, string entryPoint)
    {
        enforce(sl == ShaderLanguage.spirV, "Vulkan only understands SPIR-V");
        enforce(code.length % 4 == 0, "SPIR-V code size must be a multiple of 4");
        VkShaderModuleCreateInfo smci;
        smci.sType = VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO;
        smci.codeSize = cast(uint)code.length;
        smci.pCode = cast(const(uint)*)code.ptr;

        VkShaderModule vkSm;
        vulkanEnforce(
            cmds.createShaderModule(vk, &smci, null, &vkSm),
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
            cmds.createDescriptorSetLayout(vk, &ci, null, &vkL),
            "Could not create Vulkan descriptor set layout"
        );

        return new VulkanDescriptorSetLayout(vkL, this);
    }

    override PipelineLayout createPipelineLayout(DescriptorSetLayout[] layouts,
                                                 PushConstantRange[] ranges)
    {
        import std.algorithm : map;
        import std.array : array;

        auto vkLayouts = layouts.map!(
            l => enforce(cast(VulkanDescriptorSetLayout)l).vk
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
            cmds.createPipelineLayout(vk, &ci, null, &vkPl),
            "Could not create Vulkan pipeline layout"
        );
        return new VulkanPipelineLayout(vkPl, this);
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
            cmds.createDescriptorPool(vk, &ci, null, &vkP),
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
            vkWds.dstSet = enforce(cast(VulkanDescriptorSet)wds.dstSet).vk;
            vkWds.dstBinding = wds.dstBinding;
            vkWds.dstArrayElement = wds.dstArrayElem;
            vkWds.descriptorCount = cast(uint)wds.writes.count;
            vkWds.descriptorType = wds.writes.type.toVk();

            switch (wds.writes.type) {
            case DescriptorType.sampler:
                auto w = unsafeCast!(SamplerDescWrites)(wds.writes);
                auto vkArr = w.descs.map!((Sampler s) {
                    VkDescriptorImageInfo dii;
                    dii.sampler = enforce(cast(VulkanSampler)s).vk;
                    return dii;
                }).array;
                vkWds.pImageInfo = vkArr.ptr;
                break;
            case DescriptorType.combinedImageSampler:
                auto w = unsafeCast!(CombinedImageSamplerDescWrites)(wds.writes);
                auto vkArr = w.descs.map!((CombinedImageSampler cis) {
                    VkDescriptorImageInfo dii;
                    dii.sampler = enforce(cast(VulkanSampler)cis.sampler).vk;
                    dii.imageView = enforce(cast(VulkanImageView)cis.view).vk;
                    dii.imageLayout = cis.layout.toVk();
                    return dii;
                }).array;
                vkWds.pImageInfo = vkArr.ptr;
                break;
            case DescriptorType.sampledImage:
            case DescriptorType.storageImage:
            case DescriptorType.inputAttachment:
                auto w = unsafeCast!(TDescWritesBase!(ImageViewLayout))(wds.writes);
                auto vkArr = w.descs.map!((ImageViewLayout ivl) {
                    VkDescriptorImageInfo dii;
                    dii.imageView = enforce(cast(VulkanImageView)ivl.view).vk;
                    dii.imageLayout = ivl.layout.toVk();
                    return dii;
                }).array;
                vkWds.pImageInfo = vkArr.ptr;
                break;
            case DescriptorType.uniformBuffer:
            case DescriptorType.storageBuffer:
                auto w = unsafeCast!(TDescWritesBase!(BufferRange))(wds.writes);
                auto vkArr = w.descs.map!((BufferRange br) {
                    VkDescriptorBufferInfo dbi;
                    dbi.buffer = enforce(cast(VulkanBuffer)br.buffer).vk;
                    dbi.offset = br.offset;
                    dbi.range = br.range;
                    return dbi;
                }).array;
                vkWds.pBufferInfo = vkArr.ptr;
                break;
            case DescriptorType.uniformTexelBuffer:
            case DescriptorType.storageTexelBuffer:
                auto w = unsafeCast!(TDescWritesBase!(BufferView))(wds.writes);
                auto vkArr = w.descs.map!((BufferView bv) {
                    return enforce(cast(VulkanBufferView)bv).vk;
                }).array;
                vkWds.pTexelBufferView = vkArr.ptr;
                break;
            default:
                vkWds.descriptorCount = 0;
                break;
            }

            return vkWds;
        }).array;

        auto vkCopies = copyOps.map!((CopyDescritporSet cds) {
            VkCopyDescriptorSet vkCds;
            vkCds.sType = VK_STRUCTURE_TYPE_COPY_DESCRIPTOR_SET;
            vkCds.srcSet = enforce(cast(VulkanDescriptorSet)cds.set.from).vk;
            vkCds.srcBinding = cds.binding.from;
            vkCds.srcArrayElement = cds.arrayElem.from;
            vkCds.dstSet = enforce(cast(VulkanDescriptorSet)cds.set.to).vk;
            vkCds.dstBinding = cds.binding.to;
            vkCds.dstArrayElement = cds.arrayElem.to;
            return vkCds;
        }).array;

        cmds.updateDescriptorSets(vk,
            cast(uint)vkWrites.length, vkWrites.ptr,
            cast(uint)vkCopies.length, vkCopies.ptr
        );
    }

    override Pipeline[] createPipelines(PipelineInfo[] infos) {
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
                ).vk;
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

            auto vkViewports = infos[i].viewports.map!(vc => vc.viewport).map!(
                vp => VkViewport(vp.x, vp.y, vp.width, vp.height, vp.minDepth, vp.maxDepth)
            ).array;
            auto vkScissors = infos[i].viewports.map!(vc => vc.scissors).map!(
                r => VkRect2D(VkOffset2D(r.x, r.y), VkExtent2D(r.width, r.height))
            ).array;
            auto vkViewport = new VkPipelineViewportStateCreateInfo;
            vkViewport.sType = VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_STATE_CREATE_INFO;
            vkViewport.viewportCount = cast(uint)max(1, infos[i].viewports.length);
            vkViewport.pViewports = vkViewports.ptr;
            vkViewport.scissorCount = cast(uint)max(1, infos[i].viewports.length);
            vkViewport.pScissors = vkScissors.ptr;

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
            ).vk : VK_NULL_ND_HANDLE;

            // following bindings are not implemented yet
            auto vkTess = new VkPipelineTessellationStateCreateInfo;
            vkTess.sType = VK_STRUCTURE_TYPE_PIPELINE_TESSELLATION_STATE_CREATE_INFO;
            auto vkMs = new VkPipelineMultisampleStateCreateInfo;
            vkMs.sType = VK_STRUCTURE_TYPE_PIPELINE_MULTISAMPLE_STATE_CREATE_INFO;
            vkMs.minSampleShading = 1f;
            auto vkDepthStencil = new VkPipelineDepthStencilStateCreateInfo;
            vkDepthStencil.sType = VK_STRUCTURE_TYPE_PIPELINE_DEPTH_STENCIL_STATE_CREATE_INFO;

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
            ).vk;
            pcis[i].renderPass = vkRp;
            pcis[i].subpass = infos[i].subpassIndex;
            pcis[i].basePipelineIndex = -1;
        }

        auto vkPls = new VkPipeline[infos.length];
        vulkanEnforce(
            cmds.createGraphicsPipelines(vk, VK_NULL_ND_HANDLE, cast(uint)pcis.length, pcis.ptr, null, vkPls.ptr),
            "Could not create Vulkan graphics pipeline"
        );

        auto pls = new Pipeline[infos.length];
        foreach (i; 0 .. vkPls.length) {
            pls[i] = new VulkanPipeline(vkPls[i], this, infos[i].layout);
        }
        return pls;
    }

    private VulkanPhysicalDevice _pd;
    private VkDeviceCmds _cmds;
    private VulkanQueue[] _queues;
}
