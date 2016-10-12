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

(

// This should create an env variable named for each peer in the AddrBook
~me=~addrBook.me;

~addrBook.names.do({ arg item, i;
	currentEnvironment.put(item.asSymbol, ~addrBook.at(item.asSymbol));
	item.postln });

~effects=~addrBook.me.effectBank.dict;

~effects.keys.postln;

// add a couple of effects.

~rose.addEffect(\reverb, \freeverb);
~rose.addEffect(\distortion, \dist);
~rose.effectsList;

)

(
// add a couple of effects REMOTE.


~river.addEffect(\reverb, \freeverb);
~river.addEffect(\distortion, \dist);
~river.effectsList;

)




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
Pdefn(\sinsaw2OutBus, \masterOut, inf);


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
)


Pdefn(\sinsawInstrument, \saw, inf);
Pdefn(\sinsawInstrument, \sin, inf);

Pdefn(\sinsawOutBus, \distortion, inf);
Pdefn(\sinsawOutBus, \reverb, inf);
Pdefn(\sinsawOutBus, \masterOut, inf);


~sinsaw2.play;
~ixibass.play;


Pdefn(\ixiOutBus, \distortion, inf);
Pdefn(\sinsaw2OutBus, \masterOut, inf);
Pdefn(\sinsawOutBus, \masterOut, inf);

Pdefn(\ixiOutBus, \masterOut, inf);


/// change the target Peer
//Pdefn(\sinsawTarget, \river, inf);
//Pdefn(\sinsaw2Target, \river, inf);
//Pdefn(\ixiTarget, \river, inf);

// 5. change the p midstream:
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

