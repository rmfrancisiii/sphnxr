//session file

("~/git/sphnxr/init.scd").loadPaths;


~effectlist=EffectList.new;
~effectlist.addEffect("freeverb", "freeverb" );
~effectlist.addEffect("distortion", "dist" );
~effectlist.addEffect("distortion2", "dist" );

~effectlist.busIndex(\masterOut).postln;
~effectlist.busIndex(\freeverb).postln;


// tuning up

~addrBook.testAllAudio;
~addrBook.testAllMsg;
~addrBook.peers;


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
		\instrument, Pdefn(\sinsawInstrument),
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


)


// Section I
(
Pdefn(\sinsawTarget, '\rose', inf);
Pdefn(\sinsawInstrument, \saw, inf);
Pdefn(\sinsawOutBus, ~masterOut.index, inf);
Pdefn(\sinsawFreq, Pshuf(([50,52,54,55,58,60].midicps), inf));
Pdefn(\sinsawDuration, Pshuf([0.5, 0.25, 0.5, 0.25], inf));
Pdefn(\sinsawAmp, 0.5, inf);
Pdefn(\sinsawAtt, 0.15, inf);
Pdefn(\sinsawWait, Pshuf([0.125, 0.25, 0.25, 0.5, 0.25], inf));
)

// start the pstreams
(
~sinsaw.play;
)




Pdefn(\sinsawOutBus, ~effectlist.busIndex(\freeverb), inf);
Pdefn(\sinsawOutBus, ~effectlist.busIndex(\distortion), inf);
Pdefn(\sinsawOutBus, ~effectlist.busIndex(\masterOut), inf);


~effectlist.set(\freeverb, \mix, 0.95);
~effectlist.set(\freeverb, \room, 0.5);
~effectlist.set(\freeverb, \damp, 0.95);


(
~sinsaw.stop;
)

// Free Effects
(
~effectlist.free(\freeverb);
~effectlist.free(\distortion);
~effectlist.free(\distortion2);
~effectlist.free(\masterOut);


)

~effectlist.list.postln;
// SynthDescLib.global.read;
// SynthDescLib.global.browse;
// SynthDescLib.global.at(\sin);
//
SynthDescLib.global.at(\freeverb);
