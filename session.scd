//session file


// run the initialization file, should connect to the network and instantiate shared synths
("~/git/sphnxr/init.scd").loadPaths;


(

// now set up a Pstream with some basic defaults and a Pdefn for each arg you want to control
// you could do this multiple times for the same synth, with different values for different voices
// or different targets, busses, etc.

~sinsaw = PStream(
	Pbind(
		\target, Pdefn(\sinsawTarget, ~hostname, inf),
		\oscpath, "/synthMsg",
		\instrument, Pdefn(\sinsawInstrument, \sin, inf),
		\outBus, Pdefn(\sinsawOutBus, 0, inf),
		\freq, Pdefn(\sinsawFreq),
		\dur, Pdefn(\sinsawDuration, 0.1, inf),
		\amp, Pdefn(\sinsawAmp, 0, inf),
		\pan, Pdefn(\sinsawPan, 0, inf),
		\att, Pdefn(\sinsawAtt),
		\mod1, Pdefn(\sinsawMod1),
		\mod2, Pdefn(\sinsawMod2)
	), Pdefn(\sinsawWait, 0.1, inf),
	~addrBook);

// set pdefn values for a section
Pdefn(\sinsawTarget, \river,  inf);
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

// start the pstream
~sinsaw.play;


// change pdefn values while it is running
(
Pdefn(\sinsawTarget, Pseq(['\river', '\rose'], inf));
Pdefn(\sinsawFreq, Pshuf([40, 42, 24, 44, 40, 50, 60, 40, 80].midicps, inf));
Pdefn(\sinsawDuration, Pshuf([0.5, 0.5, 0.25, 0.5, 0.25], inf));
Pdefn(\sinsawWait, Pshuf([0.125, 0.125, 0.25, 0.25, 0.5, 0.25], inf));
)


(
Pdefn(\sinsawFreq, Pseq([40, 42, 44, 44, 48, 50, 52, 52,54,60].midicps, inf));
Pdefn(\sinsawDuration, Prand([0.5, 0.5, 0.25, 0.5, 0.25], inf));
Pdefn(\sinsawWait, Prand([0.125, 0.125, 0.25, 0.25], inf));
)


// stop the pstream
~sinsaw.stop;


