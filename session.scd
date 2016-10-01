//session file


// FIRST:  edit config.scd to set local server stuff. This is for
//         Audio hardware, RAM allocation, etc.

// SECOND: run the initialization file,
//         which should connect to the network and
//         instantiate shared synths

("~/git/sphnxr/init.scd") .loadPaths;

// test the new network
~addrBook.testAllAudio;
~addrBook.testAllMsg;

(
// add a couple of effects.
// *** should add a list argument for setting initial values of effect

~effectList.addEffect(\reverb, "freeverb" );
~effectList.addEffect(\distortion, "dist" );
)


// get a list of available effects and their bus index
~addrBook.send(\rose, "/busListMsg");

(
// 2. Set up a Pstream with some basic defaults.
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


~sinsaw2 = PStream(
	Pbind(
		\target, Pdefn(\sinsaw2Target, ~hostname, inf),
		\oscpath, "/synthMsg",
		\instrument, Pdefn(\sinsaw2Instrument),
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


// 3. now set the individual pdefns

Pdefn(\sinsawTarget, \rose, inf);
Pdefn(\sinsaw2Target, \rose, inf);
Pdefn(\sinsawInstrument, \saw, inf);
Pdefn(\sinsaw2Instrument, \saw, inf);
Pdefn(\sinsawOutBus, ~effectList.busIndex(\masterOut), inf);
Pdefn(\sinsaw2OutBus, ~effectList.busIndex(\masterOut), inf);
Pdefn(\sinsawFreq, Pshuf(([50,52,54,55,58,60].midicps), inf));
Pdefn(\sinsawDuration, Pshuf([0.5, 0.25, 0.5, 0.25], inf));
Pdefn(\sinsawAmp, 0.15, inf);
Pdefn(\sinsawAtt, 0.15, inf);
Pdefn(\sinsawWait, Pshuf([0.125, 0.25, 0.25, 0.5, 0.25], inf));
)


// 4. start the pstreams
(
~sinsaw.play;
~sinsaw2.play;
)


// 5. change the p midstream:


Pdefn(\sinsawOutBus, ~effectList.busIndex(\reverb), inf);
Pdefn(\sinsaw2OutBus, ~effectList.busIndex(\reverb), inf);

~effectList.set(\reverb, \mix, 0.5);
~effectList.set(\reverb, \room, 0.99);
~effectList.set(\reverb, \damp, 0.01);
~effectList.set(\reverb, \mix, 0.99);

Pdefn(\sinsaw2Instrument, \sin, inf);

Pdefn(\sinsaw2OutBus, ~effectList.busIndex(\distortion), inf);
~effectList.set(\distortion, \postGain, 0.12);
~effectList.set(\distortion, \preGain, 50.0);

Pdefn(\sinsawInstrument, \sin, inf);




// 6. stop the pstream
(
~sinsaw.stop;
~sinsaw2.stop;
)

// 7. free the effects synths and remove from the list
(
~effectList.free(\reverb);
~effectList.free(\distortion);
)

// other stuff later:

// ~effectlist.list.postln;
// SynthDescLib.global.read;
// SynthDescLib.global.browse;
// SynthDescLib.global.at(\sin);
//
 SynthDescLib.global.at(\freeverb);
 SynthDescLib.global.at(\dist);
