SynthDef(\sin, {|
	outBus=(~masterOut),
	freq=440,
	dur=0.1,
	amp=0.25,
	pan=0,
	att=0.15,
	mod1=0,
	mod2=0|
	var env = Env([0.001, 0.99, 0.001], [att, 1.0-att], [\sin, \sin]);
	var envGen = EnvGen.kr(env, doneAction: 2, timeScale: dur);
	var sin = SinOsc.ar(freq, SinOsc.ar(XLine.kr(mod1, mod2, dur), 0, 2pi), amp);
	Out.ar(outBus, Pan2.ar(sin * envGen, pan));
}).add;