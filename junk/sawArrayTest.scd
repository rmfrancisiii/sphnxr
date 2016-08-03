(SynthDef(\saw, {|
	sinsawOutBus=(0),
	sinsawFreq=#[440,0,0,0,0,0],
	sinsawDuration=5.0,
	sinsawAmp=#[0.25,0,0,0,0,0],
	sinsawPan=0,
	sinsawAtt=0.15,
	sinsawMod1=0,
	sinsawMod2=0|
	var env = Env([0.001, 0.75, 0.001], [sinsawAtt, 1.0-sinsawAtt], [\sin, \sin]);
	var envGen = EnvGen.kr(env, doneAction: 2, timeScale: sinsawDuration);
	var saw = LFSaw.ar(sinsawFreq, 1, sinsawAmp);
	Out.ar(sinsawOutBus, Pan2.ar(saw * envGen, sinsawPan));
}).add;
)

LFSaw
x = Synth(\saw,[sinsawFreq:[330, 440, 586, 781],sinsawAmp:[0.25,0.2,0.15,0.1]]);
x = Synth(\saw,[sinsawFreq:[60, 63, 78].midicps,sinsawAmp:[0.25,0.25,0.25]]);
x = Synth(\saw);


