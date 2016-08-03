s.boot;

(
~buffr = Buffer.read(s, "~/ferry.aiff".standardizePath);

SynthDef(\buf_grain_test, {arg gate = 1, amp = 1, sndbuf, envbuf = -1;
    var pan, env, freqdev;
    // use mouse x to control panning
    pan = MouseX.kr(-1, 1);
    env = EnvGen.kr(
        Env([0, 1, 0], [1, 1], \sin, 1),
        gate,
        levelScale: amp,
        doneAction: 2);
    Out.ar(0,
        GrainBuf.ar(2, Impulse.kr(10), 0.1, sndbuf, LFNoise1.kr.range(0.5, 2),
            LFNoise2.kr(0.1).range(0, 1), 2, pan, envbuf) * env)
    }).send(s);

)

// use built-in env
x = Synth(\buf_grain_test, [\sndbuf, ~buffr])
