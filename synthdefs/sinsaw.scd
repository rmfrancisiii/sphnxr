"loading synthdef \sin...".post;
SynthDef(\sin, {|
	sinsawOutBus=(~masterOut),
	sinsawFreq=440,
	sinsawDuration=0.1,
	sinsawAmp=0.25,
	sinsawPan=0,
	sinsawAtt=0.15,
	sinsawMod1=0,
	sinsawMod2=0|
	var env = Env([0.001, 0.99, 0.001], [sinsawAtt, 1.0-sinsawAtt], [\sin, \sin]);
	var envGen = EnvGen.kr(env, doneAction: 2, timeScale: sinsawDuration);
	var sin = SinOsc.ar(sinsawFreq, SinOsc.ar(XLine.kr(sinsawMod1, sinsawMod2, sinsawDuration), 0, 2pi), sinsawAmp);
	Out.ar(sinsawOutBus, Pan2.ar(sin * envGen, sinsawPan));
}).add;
"loaded.".postln;

"loading synthdef \saw...".post;
SynthDef(\saw, {|
	sinsawOutBus=(~masterOut),
	sinsawFreq=440,
	sinsawDuration=0.1,
	sinsawAmp=0.25,
	sinsawPan=0,
	sinsawAtt=0.15,
	sinsawMod1=0,
	sinsawMod2=0|
	var env = Env([0.001, 0.75, 0.001], [sinsawAtt, 1.0-sinsawAtt], [\sin, \sin]);
	var envGen = EnvGen.kr(env, doneAction: 2, timeScale: sinsawDuration);
	var saw = Saw.ar(sinsawFreq, sinsawAmp);
	Out.ar(sinsawOutBus, Pan2.ar(saw * envGen, sinsawPan));
}).add;
"loaded.".postln;

s.sync;

"creating ~sinRhythm".post;


~sinRhythm = PStream(

	Pbind(
		\target, Pdefn(\sinsawTarget, ~hostname, inf),
		\oscpath, "/synthMsg",
		\instrument, Pdefn(\sinsawInstrument, \sin, inf),
		\sinsawOutBus, Pdefn(\sinsawOutBus, 0, inf),
		\sinsawFreq, Pdefn(\sinsawFreq),
		\sinsawDuration, Pdefn(\sinsawDuration, 0.1, inf),
		\sinsawAmp, Pdefn(\sinsawAmp, 0, inf),
		\sinsawPan, Pdefn(\sinsawPan, 0, inf),
		\sinsawAtt, Pdefn(\sinsawAtt),
		\sinsawMod1, Pdefn(\sinsawMod1),
		\sinsawMod2, Pdefn(\sinsawMod2)
	), Pdefn(\sinsawWait, 0.1, inf),
	~addrBook
).play;
