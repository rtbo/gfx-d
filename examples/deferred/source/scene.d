module scene;

import gfx.math;

struct Vertex
{
    FVec3 pos;
    FVec3 normal;
}

struct Mesh
{
    ushort[] indices;
    Vertex[] vertices;
}

struct DeferredScene
{
    MovingObj mov;
    SaucerSubStruct[] subStructs;

    /// prepare scene and return approximative bounding radius
    float prepare()
    {
        /// Build a structure of 9 sub structures, each containing 9 saucers.
        /// Saucers have a fixed position relative to their sub-structure,
        /// which have fixed position relative to the super structure.
        /// Each object (structure, sub-structure and saucer spin around their center)
        /// is setup such as to not have collisions.

        import std.algorithm : map;
        import std.array : array;
        import std.math : PI, sqrt;
        import std.random : Random, uniform;

        enum margin = 1f;
        enum saucerSz = 3f;
        enum saucerBound = saucerSz + 2 * margin;
        enum subStructSz = saucerBound * 3;
        enum subStructBound = subStructSz + 2 * margin;
        enum superStructSz = subStructBound * 3;
        enum numSubStructs = 9;
        enum numSaucers = 9;

        enum subDist = (superStructSz / 2f) - (subStructBound / 2f);
        enum saucerDist = (subStructSz / 2f) - (saucerBound / 2f);

        auto rnd = Random(12);
        size_t saucerIdx = 0;

        FVec3 spin(in float minRpm, in float maxRpm)
        {
            enum RPM = 2*PI / 60;
            return fvec(
                uniform(minRpm * RPM, maxRpm * RPM, rnd),
                uniform(minRpm * RPM, maxRpm * RPM, rnd),
                uniform(minRpm * RPM, maxRpm * RPM, rnd),
            );
        }

        MovingObj[] buildMovingObjs(in uint num, in float dist, in float minRpm, in float maxRpm)
        {
            MovingObj[] objs = new MovingObj[num];

            const coord = dist * sqrt(2f) / 2;

            foreach(i; 0 .. num) {
                FVec3 pos = fvec(0, 0, 0);
                if (i > 0) {
                    const mask = i - 1;
                    pos.x = (mask & 0b001) ? coord : -coord;
                    pos.y = (mask & 0b010) ? coord : -coord;
                    pos.z = (mask & 0b100) ? coord : -coord;
                }
                objs[i] = MovingObj(pos, spin(minRpm, maxRpm), FMat3.identity);
            }
            return objs;
        }

        FVec3 color() {
            return normalize(
                fvec(
                    uniform(0.1, 1.0, rnd),
                    uniform(0.1, 1.0, rnd),
                    uniform(0.1, 1.0, rnd),
                )
            );
        }

        Saucer makeSaucer(MovingObj mov) {
            const float time = uniform(1.0, 10.0, rnd);
            const float onOff = uniform(0.1, 0.6, rnd); // on 10% to 60%
            const float[2] timeOnOff = [time * onOff, time * (1 - onOff)];

            SaucerBody body;
            SaucerBody cockpit;
            SaucerBody antenna;
            const bodyCol = color();
            const antennaCol = color();
            FVec3 antennaPos;
            {
                const xy = uniform(2.5, 3, rnd);
                const z = uniform(0.8, 1, rnd);
                body.transform = scale(fvec(xy, xy, z));
                body.color = bodyCol * 0.8;
            }
            {
                const s = uniform(0.5, 1, rnd);
                const x = uniform(-0.5, 0, rnd);
                const z = uniform(0.8, 1, rnd);
                cockpit.transform = translation(fvec(x, 0, z))
                        * scale(FVec3(s));
                cockpit.color = bodyCol;
            }
            {
                const s = uniform(0.1, 0.3, rnd);
                const x = uniform(1, 2, rnd);
                const z = uniform(1.5, 2.5, rnd);
                antennaPos = fvec(x, 0, z);
                antenna.transform = translation(antennaPos)
                        * scale(FVec3(s));
                antenna.color = antennaCol;
            }

            return Saucer(
                mov, saucerIdx++, [body, cockpit, antenna],
                antennaCol,
                antennaPos,
                timeOnOff,
                uniform(3f, 9f, rnd), // light radius
                uniform(0.0, time, rnd), // initial phase
            );
        }
        SaucerSubStruct makeSubStruct(MovingObj mov) {
            return SaucerSubStruct(
                mov,
                buildMovingObjs(numSaucers, saucerDist, 6f, 7f)
                    .map!(mov => makeSaucer(mov))
                    .array
            );
        }

        mov.spin = spin(2f, 3f);
        subStructs = buildMovingObjs(numSubStructs, subDist, 4f, 5f)
            .map!(mov => makeSubStruct(mov))
            .array;

        return superStructSz / 2f;
    }

    size_t saucerCount()
    {
        import std.algorithm : map, sum;

        return subStructs
            .map!(ss => ss.saucers.length)
            .sum();
    }
}

struct MovingObj
{
    /// position of the object relative to its parent
    FVec3 position = fvec(0, 0, 0);
    /// rotation speed of the object around itself
    /// using Euler angles, in rad/s
    FVec3 spin = fvec(0, 0, 0);
    /// current rotation of the object
    FMat3 rotation = FMat3.identity;

    /// rotate the rotation matrix with the spin euler vector
    /// over dt secs
    void rotate(in float dt)
    {
        const euler = spin * dt;
        rotation *= eulerAngles(euler);
    }

    /// Compute the full transform
    FMat4 transform()
    {
        return translate(
            mat(
                vec(rotation[0], 0),
                vec(rotation[1], 0),
                vec(rotation[2], 0),
                vec(0, 0, 0, 1),
            ),
            position,
        );
    }
}

struct SaucerBody
{
    FMat4 transform = FMat4.identity;
    FVec3 color = fvec(0, 0, 0);
}

struct Saucer
{
    MovingObj mov;
    size_t saucerIdx;
    SaucerBody[] bodies;

    FVec3 lightCol;
    FVec3 lightPos;
    float[2] lightTimeOnOff; // time with light spent on and off each cycle
    float lightRadius;

    float phase;
    bool lightOn;

    void anim(in float dt) {
        mov.rotate(dt);
        const period = lightTimeOnOff[0] + lightTimeOnOff[1];
        phase += dt;
        while (phase >= period) phase -= period;
        lightOn = phase <= lightTimeOnOff[0];
    }
}

struct SaucerSubStruct
{
    MovingObj mov;
    Saucer[] saucers;
}

Mesh buildUvSpheroid(in FVec3 center, in float radius, in float height,
        in uint latDivs = 8)
{
    import std.array : uninitializedArray;
    import std.math : PI, cos, sin;

    const longDivs = latDivs * 2;
    const totalVertices = 2 + (latDivs - 1) * longDivs;
    const totalIndices = 3 * longDivs * (2 + 2 * (latDivs - 2));

    auto vertices = uninitializedArray!(Vertex[])(totalVertices);

    size_t ind = 0;
    void unitVertex(in FVec3 pos)
    {
        const v = fvec(radius * pos.xy, height * pos.z);
        vertices[ind++] = Vertex(center + v, normalize(v));
    }

    const latAngle = PI / latDivs;
    const longAngle = 2 * PI / longDivs;

    // north pole
    unitVertex(fvec(0, 0, 1));
    // latitudes
    foreach (lat; 1 .. latDivs)
    {
        const alpha = latAngle * lat;
        const z = cos(alpha);
        const sa = sin(alpha);
        foreach (lng; 0 .. longDivs)
        {
            const beta = longAngle * lng;
            const x = cos(beta) * sa;
            const y = sin(beta) * sa;

            unitVertex(fvec(x, y, z));
        }
    }
    // south pole
    unitVertex(fvec(0, 0, -1));
    assert(ind == totalVertices);

    // build ccw triangle faces
    auto indices = uninitializedArray!(ushort[])(totalIndices);
    ind = 0;
    void face(in size_t v0, in size_t v1, in size_t v2)
    {
        indices[ind++] = cast(ushort) v0;
        indices[ind++] = cast(ushort) v1;
        indices[ind++] = cast(ushort) v2;
    }

    size_t left(size_t lng)
    {
        return lng;
    }

    size_t right(size_t lng)
    {
        return lng == longDivs - 1 ? 0 : lng + 1;
    }

    // northern div triangles
    foreach (lng; 0 .. longDivs)
    {
        const pole = 0;
        const bot = 1;
        face(pole, bot + left(lng), bot + right(lng));
    }
    // middle divs rectangles
    foreach (lat; 0 .. latDivs - 2)
    {
        const top = 1 + lat * longDivs;
        const bot = top + longDivs;
        foreach (lng; 0 .. longDivs)
        {
            const l = left(lng);
            const r = right(lng);

            face(top + l, bot + l, bot + r);
            face(top + l, bot + r, top + r);
        }
    }
    // southern div triangles
    foreach (lng; 0 .. longDivs)
    {
        const pole = totalVertices - 1;
        const top = 1 + (latDivs - 2) * longDivs;
        face(pole, top + right(lng), top + left(lng));
    }
    assert(ind == totalIndices);

    return Mesh(indices, vertices);
}
