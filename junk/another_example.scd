(
SynthDef("Pdefhelp", { arg out, freq, sustain=1, amp=1, pan;
    var env, u=1;
    env = EnvGen.kr(Env.perc(0.03, sustain), 1, doneAction:2);
    5.do { var d; d = exprand(0.01, 1); u = SinOsc.ar(d * 300, u, rrand(0.1,1.2) * d, 1) };
    Out.ar(out, Pan2.ar(SinOsc.ar(u + 1 * freq, 0, amp * env), pan));

}).add;
s.boot;
)

(
Pdefn(\deg, Pseq([0, 3, 2],inf));

Pset(\instrument, \Pdefhelp,
    Ppar([
        Pbind(\degree, Pdefn(\deg), \pan, -0.8),
        Pbind(\degree, Pdefn(\deg), \dur, 1/3, \pan, 0.8)
])
).play;
)

Pdefn(\deg, Prand([0, 3, [1s, 4]],inf));

Pdefn(\deg, Pn(Pshuf([0, 3, 2, 7, 6],2),inf));

(
Pdefn(\deg, Plazy { var pat;
    pat = [Pshuf([0, 3, 2, 7, 6],2), Pseries(0, 1, 11), Pseries(11, -1, 11)].choose;
    Pn(pat, inf)
});
)