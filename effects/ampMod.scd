SynthDef(\ampMod, {|
	inBus=(~ampModIn),
	outBus=(~masterOut),
	freq=400|
	var sig = In.ar(inBus, 2);
	var mod = SinOsc.ar(freq).abs; //alt: MouseX.kr(2, 200, 1)
	Out.ar(outBus, sig * mod);
}).add;