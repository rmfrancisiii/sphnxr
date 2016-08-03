(
s.boot;
s.waitForBoot({

	p = "/git/manly.wav";
	~manlyBuf = Buffer.readChannel(s, p, channels:0);

	"/git/sphnxr/join_utopia.scd".loadPaths;


	~groups = [
		// put these groups in order, synths >> effects
		~synthGroup = Group.tail(s),
		~effectGroup = Group.tail(s)
	];

	~busses = [
		~masterOut = s.outputBus,
		~sinsawOut = Bus.audio(s,1),
		~textOut = Bus.audio(s,1),
		~freeverbIn = Bus.audio(s,1),
		~pitchIn = Bus.audio(s,1),
		~voiceIn = Bus.audio(s,1)
	];

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

	SynthDef(\textBuffer, {|
		outBus=(~textOut),
		bufnum|
		Out.ar(outBus,
			PlayBuf.ar(
				1,
				bufnum,
				BufRateScale.kr(
					bufnum
	)))}).add;

	SynthDef(\freeverb, {|
		outBus=(~masterOut),
		inBus=(~freeverbIn),
		mix = 0.25,
		room = 0.15,
		damp = 0.5|
		var input = In.ar(inBus, 1);
		Out.ar(outBus,
			FreeVerb.ar(
				input,
				mix, // mix 0-1
				room, // room 0-1
				damp // damp 0-1
			)
		);
	}).add;

	SynthDef(\vocoder, {

		Out.ar(~masterOut,
			Vocoder.ar(
				Saw.ar(400,4),
				In.ar(~voiceIn),
				56)
			);
	}).add;
});
)

~text = Synth.head(~synthGroup,
	\textBuffer, [
		\outBus, ~voiceIn,
		\bufnum, ~manlyBuf

]);


~vocoder = Synth.head(~effectGroup,
	\vocoder, [
		\outBus, ~freeverbIn,
		\pitchInBus, ~sinsawOut,
		\voiceInBus, ~voiceIn,
		\numBands, 100
]);

~freeverb = Synth.head(~effectGroup,
	\freeverb, [
		\outBus, ~masterOut,
		\inBus, ~freeverbIn,
		\mix, 0.25,
		\room, 0.15,
		\damp, 0.5
]);


(
~sinRhythm = PStream(

	Pbind(
		\target, Pdefn(\target, \river, inf),
		\oscpath, "/synthMsg",
		\instrument, Pdefn(\instrument, \sin, inf),
		\sinsawOutBus, Pdefn(\sinsawOutBus, 6, inf),
		\sinsawFreq, Pdefn(\sinsawFreq, Pseq([60, 62, 62, 66].midicps, inf)),
		\sinsawDuration, Pdefn(\sinsawDuration, Pseq([0.5, 0.5, 0.25, 0.5, 0.25], inf)),
		\sinsawAmp, Pdefn(\sinsawAmp, Pseq([0.025], inf)),
		\sinsawPan, Pdefn(\sinsawPan,
			Prand([0.0, -0.25, -0.5, -0.75, -1.0, 0.25, 0.5, 0.75, 1.0], inf)),
		\sinsawAtt, Pdefn(\sinsawAtt, Pseq([0.01], inf)),
		\sinsawMod1, Pdefn(\sinsawMod1, 0, inf),
		\sinsawMod2, Pdefn(\sinsawMod2, 0, inf)
	), Pdefn(\sinsawWait, Pseq([0.5, 0.5, 0.25, 0.5, 0.25], inf)),
	~addrBook

).play;
)