~busses.add(\freeverbIn -> ~freeverbIn = Bus.audio(s,2));

SynthDef(\freeverb, {|
	outBus=(~masterOut),
	mix = 0.25,
	room = 0.15,
	damp = 0.5|
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