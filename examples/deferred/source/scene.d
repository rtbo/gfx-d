module scene;

import gfx.math;

interface LightAnim
{
    void anim(in float dt);
    @property FVec3 color();
    @property bool on();
}

/// constant light without animation
class ConstantLight : LightAnim
{
    FVec3 _color;

    this(FVec3 color)
    {
        _color = color;
    }

    override void anim(in float) {}
    override @property FVec3 color()
    {
        return _color;
    }
    override @property bool on()
    {
        return true;
    }
}

private float smoothstep(float edge0, float edge1, float x) {
  // Scale, bias and saturate x to 0..1 range
  x = clamp((x - edge0) / (edge1 - edge0), 0.0, 1.0);
  // Evaluate polynomial
  return x * x * (3 - 2 * x);
}

private float clamp(float x, float lowerlimit, float upperlimit) {
  if (x < lowerlimit)
    x = lowerlimit;
  if (x > upperlimit)
    x = upperlimit;
  return x;
}

/// blinking light
class BlinkLight : LightAnim
{
    LightAnim _anim;
    float _on;
    float _period;
    float _step;
    float _phase;
    float _level;

    this(LightAnim anim, in float on, in float off, in float step, in float phase)
    in (on > step && off > step, "Blink light on or off is smaller than step")
    in (phase >= 0f && phase < (on + off), "Blink light initial phase out of period")
    {
        _anim = anim;
        _on = on;
        _period = on + off;
        _step = step;
        _phase = phase;
        computeLevel();
    }

    final void computeLevel()
    {
        if (_phase < (_on-_step)) {
            _level = 1f;
        }
        else if (_phase < _on) {
            // step down
            _level = 1f - smoothstep(_on - _step, _on, _phase);
        }
        else if (_phase < (_period-_step)) {
            _level = 0f;
        }
        else {
            // step up
            _level = smoothstep(_period - _step, _period, _phase);
        }
    }

    override void anim(in float dt)
    {
        _anim.anim(dt);
        _phase += dt;
        while (_phase >= _period) _phase -= _period;
        computeLevel();
    }

    override @property FVec3 color()
    {
        return _anim.color * _level;
    }

    override @property bool on()
    {
        return _level > 0f && _anim.on;
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
    float shininess = 1f;
}

struct Saucer
{
    MovingObj mov;
    size_t saucerIdx;
    SaucerBody[] bodies;

    FVec3 lightPos;
    float lightLuminosity;
    LightAnim lightAnim;

    void anim(in float dt)
    {
        mov.rotate(dt);
        lightAnim.anim(dt);
    }
}

struct SaucerSubStruct
{
    MovingObj mov;
    Saucer[] saucers;
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
        import std.random : choice, Random, uniform;

        const margin = 1f;
        const saucerSz = 3f;
        const saucerBound = saucerSz + 2 * margin;          // 5
        const subStructSz = 3 * saucerBound;                // 15
        const subStructBound = subStructSz + 2 * margin;    // 17
        const sceneSz = subStructBound * 3;                 // 51
        const numSubStructs = 9;
        const numSaucers = 9;

        const subDist = (sceneSz / 2f) - (subStructSz / 2f);
        const saucerDist = (subStructBound / 2f) - (saucerSz / 2f);

        auto rnd = Random(43);
        size_t saucerIdx = 0;

        FVec3 spin(in float minRpm, in float maxRpm)
        {
            const float[2] sign = [-1f, 1f];
            const signs = fvec(
                choice(sign[], rnd),
                choice(sign[], rnd),
                choice(sign[], rnd),
            );

            enum RPM = 2*PI / 60;
            return signs * fvec(
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

        LightAnim makeAnim()
        {
            import std.algorithm : max;

            auto base = new ConstantLight(color());
            const float period = uniform(1.0, 10.0, rnd);
            const float onOff = uniform(0.1, 0.6, rnd); // on 10% to 60%
            const float on = max(0.5f, period * onOff);
            const float off = period - on;
            const float step = 0.3f;
            const float phase = uniform(0f, period, rnd);
            return new BlinkLight(base, on, off, step, phase);
        }


        Saucer makeSaucer(MovingObj mov) {

            SaucerBody body;
            SaucerBody cockpit;
            SaucerBody bulb;
            const bodyCol = color();
            const bulbCol = color();
            FVec3 bulbPos;
            {
                const xy = uniform(2.5, 3, rnd);
                const z = uniform(0.8, 1, rnd);
                body.transform = scale(fvec(xy, xy, z));
                body.color = bodyCol * 0.8;
                body.shininess = uniform(6.0, 16.0, rnd);
            }
            {
                const s = uniform(0.5, 1, rnd);
                const x = uniform(-0.5, 0, rnd);
                const z = uniform(0.8, 1, rnd);
                cockpit.transform = translation(fvec(x, 0, z))
                        * scale(FVec3(s));
                cockpit.color = bodyCol;
                cockpit.shininess = uniform(20.0, 32.0, rnd);
            }
            {
                const s = uniform(0.2, 0.3, rnd);
                const x = uniform(1.0, 2.0, rnd);
                const z = uniform(1.5, 2.5, rnd);
                bulbPos = fvec(x, 0, z);
                bulb.transform = translation(bulbPos)
                        * scale(FVec3(s));
                bulb.color = bulbCol;
                bulb.shininess = uniform(20.0, 32.0, rnd);
            }

            return Saucer(
                mov, saucerIdx++, [body, cockpit, bulb],
                bulbPos,
                uniform(2f, 12f, rnd), // light luminosity
                makeAnim(),
            );
        }

        SaucerSubStruct makeSubStruct(MovingObj mov) {
            return SaucerSubStruct(
                mov,
                buildMovingObjs(numSaucers, saucerDist, 3f, 7f)
                    .map!(mov => makeSaucer(mov))
                    .array
            );
        }

        mov.spin = spin(2f, 3f);
        subStructs = buildMovingObjs(numSubStructs, subDist, 1f, 5f)
            .map!(mov => makeSubStruct(mov))
            .array;

        return sceneSz / 2f;
    }

    @property size_t saucerCount()
    {
        import std.algorithm : map, sum;

        return subStructs
            .map!(ss => ss.saucers.length)
            .sum();
    }
}
