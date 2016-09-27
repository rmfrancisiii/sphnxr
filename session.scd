//session file


// FIRST:  edit config.scd to set local server stuff. This is for
//         Audio hardware, RAM allocation, etc.

// SECOND: run the initialization file,
//         which should connect to the network and
//         instantiate shared synths

("~/git/sphnxr/init.scd").loadPaths;


// NEXT (after "ready to Collide")

(
// 1. Set up a Pstream with some basic defaults.
//    Assign a Pdefn for each arg you want to control.
//    You could do this multiple times for the same synth
//    assigning different ***(or the same!)*** Pdefns
//    for different voices with shared or separate control values

~sinsaw = PStream(
	Pbind(
		\target, Pdefn(\sinsawTarget, ~hostname, inf),
		\oscpath, "/synthMsg",
		\instrument, Pdefn(\sinsawInstrument, \sin, inf),
		\outBus, Pdefn(\sinsawOutBus),
		\freq, Pdefn(\sinsawFreq),
		\dur, Pdefn(\sinsawDuration),
		\amp, Pdefn(\sinsawAmp),
		\pan, Pdefn(\sinsawPan),
		\att, Pdefn(\sinsawAtt),
		\mod1, Pdefn(\sinsawMod1),
		\mod2, Pdefn(\sinsawMod2)
	), Pdefn(\sinsawWait),
	~addrBook);


~sinsaw2 = PStream(
	Pbind(
		\target, Pdefn(\sinsaw2Target, ~hostname, inf),
		\oscpath, "/synthMsg",
		\instrument, Pdefn(\sinsaw2Instrument, \saw, inf),
		\outBus, Pdefn(\sinsaw2OutBus),
		\freq, Pdefn(\sinsawFreq),
		\dur, Pdefn(\sinsawDuration),
		\amp, Pdefn(\sinsawAmp),
		\pan, Pdefn(\sinsawPan),
		\att, Pdefn(\sinsawAtt),
		\mod1, Pdefn(\sinsawMod1),
		\mod2, Pdefn(\sinsawMod2)
	), Pdefn(\sinsawWait),
	~addrBook);

)

(
// set initial pdefn values for a section

// Section I

Pdefn(\sinsawTarget, \rose, inf);
Pdefn(\sinsaw2Target, \rose, inf);
Pdefn(\sinsawOutBus, 0, inf);
Pdefn(\sinsawInstrument, \sin, inf);
Pdefn(\sinsawFreq, Pshuf([44, 46, 48, 48, 50, 52].midicps, inf));
Pdefn(\sinsawDuration, Pshuf([0.5, 0.5, 0.25, 0.5, 0.25], inf));
Pdefn(\sinsawAmp, Pseq([0.25], inf));
Pdefn(\sinsawPan, Pseq([0.0, -0.25, -0.5, -0.75, -1.0, 0.25, 0.5, 0.75, 1.0], inf));
Pdefn(\sinsawAtt, Pseq([0.001], inf));
Pdefn(\sinsawMod1, 5, inf);
Pdefn(\sinsawMod2, 10, inf);
Pdefn(\sinsawWait, Pshuf([0.125, 0.125, 0.25, 0.25, 0.5, 0.25], inf));
)


// start the pstreams
(
~sinsaw.play;
~sinsaw2.play;
)


// change the p midstream:

(
Pdefn(\sinsawInstrument, \saw, inf);
//Pdefn(\sinsawTarget, Pseq(['\river', '\rose'], inf));
//Pdefn(\sinsaw2Target, \river,  inf);
Pdefn(\sinsawFreq, Pshuf([40, 42, 24, 44, 40, 50, 60, 40, 80].midicps, inf));
Pdefn(\sinsawDuration, Pshuf([0.5, 0.5, 0.25, 0.5, 0.25], inf));
Pdefn(\sinsawWait, Pshuf([0.125, 0.125, 0.25, 0.25, 0.5, 0.25], inf));
)


(
Pdefn(\sinsawFreq, Pseq([40, 42, 44, 44, 48, 50, 52, 52,54,60].midicps, inf));
Pdefn(\sinsawDuration, Prand([0.5, 0.5, 0.25, 0.5, 0.25], inf));
Pdefn(\sinsawWait, Prand([0.125, 0.125, 0.25, 0.25], inf));
)



// activate an effect:
(
~distort = Synth.head(~effectGroup, \dist, [\outBus, ~masterOut]);
~freeverb = Synth.head(~effectGroup, \freeverb, [\outBus, ~masterOut]);
)

// reroute the synth
Pdefn(\sinsawOutBus, 6, inf);


// reroute the other one
Pdefn(\sinsaw2OutBus, 6, inf);

//  (~freeverb.index).postln;

//change the effect values

~freeverb.set(\mix, 0.95);
~freeverb.set(\room, 0.95);
~freeverb.set(\damp, 0.95);

Pdefn(\sinsawOutBus, 6, inf);




// stop the pstream
(
~sinsaw.stop;
~sinsaw2.stop;
)
