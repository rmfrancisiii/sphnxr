
s.boot;

(

~groups = [
	// put these groups in order, synths >> effects
	~synthGroup = Group.tail(s),
	~effectGroup = Group.tail(s)
];

~busses = [
	// create these busses and assign them later
	~freeverbIn = Bus.audio(s,2),
	~distortIn = Bus.audio(s,2),
];

~masterOut = 0; // just for legibility

SynthDef(\sin, {
	|outBus=(~masterOut), freq=1000, duration=1,
	amp=0.5, pan=0, att=0.5,
	mod1=10, mod2=10|
	var env = Env([0.001, 0.99, 0.001],
		[att, 1.0-att],
		[\sin, \sin]);
	var envGen = EnvGen.kr(
		env,
		doneAction: 2,
		timeScale: duration);
	var sin = SinOsc.ar(
		freq,
		SinOsc.ar(XLine.kr(mod1, mod2, duration),0, 2pi),
		amp);
	Out.ar(outBus,
		Pan2.ar(
			sin * envGen,
			pan));
}).add;

SynthDef(\freeverb, {
	|outBus=(~masterOut), mix = 0.25, room = 0.15, damp = 0.5|
	var input = In.ar(~freeverbIn, 2);
	Out.ar(outBus,
		FreeVerb.ar(
			input,
			mix, // mix 0-1
			room, // room 0-1
			damp // damp 0-1
		)
	);
}).add;

SynthDef(\dist, {
	|outBus=(~masterOut), preGain=8, postGain=0.6|
    var input = In.ar(~distortIn, 2);
    var sig = (input * preGain).distort;
    Out.ar(outBus, sig * postGain);
}).add;

)

( //sin >> out
Synth.head(~synthGroup, \sin);
)

( //sin >> distortion >> out
~distort = Synth.head(~effectGroup, \dist, [\outBus, ~masterOut]);
Synth.head(~synthGroup, \sin, [\outBus, ~distortIn]);
)

( //sin >> freeverb >> out
~freeverb = Synth.head(~effectGroup, \freeverb, [\outBus, ~masterOut]);
Synth.head(~synthGroup, \sin, [\outBus, ~freeverbIn]);
)


( //sin >> distortion >> freeverb >> out
~distort = Synth.head(~effectGroup, \dist, [\outBus, ~freeverbIn]);
~freeverb = Synth.head(~effectGroup, \freeverb, [\outBus, ~masterOut]);
Synth.head(~synthGroup, \sin, [\outBus, ~distortIn]);
)

( //sin >> freeverb >> distortion >> out
~freeverb = Synth.head(~effectGroup, \freeverb, [\outBus, ~distortIn]);
~distort = Synth.head(~effectGroup, \dist, [\outBus, ~masterOut]);
Synth.head(~synthGroup, \sin, [\outBus, ~freeverbIn]);
)



( // Modify freeverb parameters

~freeverb.set(\mix, 0.9);
~freeverb.set(\room, 0.9);
~freeverb.set(\damp, 0.9);

// sin >> freeverb >> distortion >> out
Synth.head(~synthGroup, \sin, [\outBus, ~freeverbIn]);
)