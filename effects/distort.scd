~busses.add(\distortIn -> ~distortIn = Bus.audio(s,2));

SynthDef(\dist, {|
	outBus=(~masterOut),
	preGain=8,
	postGain=0.6|
	var input = In.ar(~distortIn, 2);
	var sig = (input * preGain).distort;
	Out.ar(outBus, sig * postGain);
}).add;