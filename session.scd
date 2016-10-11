//session file


// FIRST:  edit config.scd to set local server stuff. This is for
//         Audio hardware, RAM allocation, etc.

// SECOND: run the initialization file,
//         which should connect to the network and
//         instantiate shared synths

("~/git/sphnxr/init.scd").loadPaths;


// test the new network
~addrBook.testAllAudio;
~addrBook.testAllMsg;
~addrBook.peers; // who's out there?

// This should create an env variable named for each peer in the AddrBook
(
~me=~addrBook.me;

~addrBook.names.do({ arg item, i;
	currentEnvironment.put(item.asSymbol, ~addrBook.at(item.asSymbol));
	item.postln });
)

// add a couple of effects.
(
~me.addEffect(\reverb, \freeverb);
~me.addEffect(\reverb2, \freeverb);
~me.addEffect(\distortion, \dist);
)

~river.effectsList;
~me.effectsList;

(
~river.addEffect(\rreverb, \freeverb);
~river.addEffect(\rreverb2, \freeverb);
~river.addEffect(\rdistortion, \dist);
)
~river.effectsList;
~me.effectsList;

~river.effectIndex(\rdistortion);
~river.effectIndex(\masterOut);
~river.effectIndex(\error);


~me.effectIndex(\reverb);
~me.effectIndex(\distortion);
~me.freeEffect(\reverb2);
~me.effectsList;

~river.freeEffect(\rreverb2);
~river.effectsList;
~river.effectIndex(\rreverb2);
~river.effectIndex(\rreverb);





// currently a synth message still needs the bus managed manually.
//        eg: Pdefn(\sinsawOutBus, 6, inf);
//
// instead we should be referencing this by the name/key of the effect from the peer's effectList:
// Pdefn(\sinsawOutBus, \distortion, inf);
// and have the OSCDef or the OSC sender function doing a lookup


// *** also need to set up a responder for the current Control values of a synth



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

~ixibass = PStream(
	Pbind(
		\target, Pdefn(\ixiTarget, ~hostname, inf),
		\oscpath, "/synthMsg",
		\instrument, Pdefn(\ixiInstrument),
		\out, Pdefn(\ixiOutBus),
		\amp, Pdefn(\ixiAmp),
		\t_trig, Pdefn(\ixiTrig),
		\freq, Pdefn(\ixiFreq),
		\rq, Pdefn(\ixiRQ),
	), Pdefn(\ixiWait),
	~addrBook);
)

(
// 3. now set the individual pdefns

Pdefn(\sinsawTarget, \rose, inf);
Pdefn(\sinsawInstrument, \sin, inf);
Pdefn(\sinsawOutBus, \masterOut, inf);

Pdefn(\sinsaw2Target, \rose, inf);
Pdefn(\sinsaw2Instrument, \saw, inf);
Pdefn(\sinsaw2OutBus, 16, inf);


Pdefn(\sinsawFreq, Pshuf(([50,52,54,55,58,60]+5).midicps, inf));
Pdefn(\sinsawDuration, Pshuf([0.5, 0.25, 0.5, 0.25], inf));
Pdefn(\sinsawAmp, 0.25, inf);
Pdefn(\sinsawAtt, 0.75, inf);
Pdefn(\sinsawWait, Pshuf([0.125, 0.25, 0.25, 0.5, 0.25], inf));


Pdefn(\ixiTarget, \rose, inf);
Pdefn(\ixiInstrument, \ixibass, inf);
Pdefn(\ixiOutBus, \masterOut, inf);
Pdefn(\ixiFreq, Pshuf(([50,52,54,55,58,60]-5).midicps, inf));
Pdefn(\ixiAmp, 0.1, inf);
Pdefn(\ixiRQ, 0.01, inf);
Pdefn(\ixiTrig, 1, inf);
Pdefn(\ixiWait, Pseq([ 0.125, 0.25, 0.5, 0.25, 0.25, 0.5, 0.25, 1.0], inf));

)


// 4. start the pstreams
(
~sinsaw.play;
~sinsaw.stop;
~sinsaw2.play;
~ixibass.play;
)


Pdefn(\sinsawInstrument, \saw, inf);
Pdefn(\sinsawOutBus, \reverb, inf);
Pdefn(\sinsawOutBus, \distortion, inf);
Pdefn(\sinsawOutBus, \masterOut, inf);
Pdefn(\ixiOutBus, \reverb, inf);


/// change the target Peer
//Pdefn(\sinsawTarget, \river, inf);
//Pdefn(\sinsaw2Target, \river, inf);
//Pdefn(\ixiTarget, \river, inf);

// 5. change the p midstream:


Pdefn(\sinsawOutBus, 0, inf);
Pdefn(\sinsaw2OutBus, ~effectList.busIndex(\reverb), inf);

// *** should be Peer.setEffect
//~effectList.set(\reverb, \mix, 0.9);
//~effectList.set(\reverb, \room, 0.99);
//~effectList.set(\reverb, \damp, 0.01);
//~effectList.set(\reverb, \mix, 0.99);

Pdefn(\sinsaw2Instrument, \sin, inf);
Pdefn(\sinsaw2Instrument, \saw, inf);



//Pdefn(\sinsaw2OutBus, ~effectList.busIndex(\distortion), inf);
//~effectList.set(\distortion, \postGain, 0.12);
//~effectList.set(\distortion, \preGain, 50.0);

Pdefn(\sinsaw2Instrument, \sin, inf);




// 6. stop the pstream
(
~sinsaw.stop;
~sinsaw2.stop;
~ixibass.stop;
)

// *** LIES: actually i don't think this works any more
// we need a new method for freeing all busses and synths
// 7. free the effects synths and remove from the list
// *** should be peer.freeEffect
// *** Is this freeing the bus too? or just the synth?

// (
// ~effectList.free(\reverb);
// ~effectList.free(\distortion);
// )
