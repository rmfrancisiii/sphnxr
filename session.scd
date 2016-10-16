//session file


// 1.  Edit config.scd to set local server stuff. This is for
//         Audio hardware, RAM allocation, etc.

// 2.  Run the initialization file,
("~/git/sphnxr/init.scd").loadPaths;
//         which should connect to the network and
//         instantiate shared synths


// 3.  Load generic pstreams
("~/git/sphnxr/pstreams.scd").loadPaths;


// 4.  Generic testing
("~/git/sphnxr/tests.scd").loadPaths;

// This should create an env variable named for each peer in the AddrBook
(~addrBook.names.do({ arg item, i;
	currentEnvironment.put(item.asSymbol, ~addrBook.at(item.asSymbol));
	item.postln });
)
(
// 5.  Add a couple of effects.
~rose.addEffect(\reverb, \freeverb);
~rose.addEffect(\distortion, \dist);
)


~addrBook.broadcastEffectList;

(
// 6.  Now set the individual pdefns
Pdefn(\sinTarget, \rose, inf);
Pdefn(\sinInstrument, \sin, inf);
Pdefn(\sinOutBus, \masterOut, inf);
Pdefn(\sinFreq, Pshuf(([50,52,54,55,58,60]+5).midicps, inf));
Pdefn(\sinDuration, Pshuf([0.5, 0.25, 0.5, 0.25], inf));
Pdefn(\sinAmp, 0.25, inf);
Pdefn(\sinAtt, 0.015, inf);
Pdefn(\sinWait, Pshuf([0.125, 0.25, 0.25, 0.5, 0.25], inf));
Pdefn(\sinWait, Pseq([0.5], inf));
Pdefn(\sinFreq, Pseq(([50,52,54,55]).midicps, inf));
Pdefn(\sinDuration, Pseq([0.25], inf));
)


// 7.  Start the synth
~sin.play;


(
// 6.  Now set the individual pdefns
Pdefn(\ixiTarget, \rose, inf);
Pdefn(\ixiInstrument, \ixibass, inf);
Pdefn(\ixiOutBus, \masterOut, inf);
Pdefn(\ixiFreq, Pshuf(([50,52,54,55,58,60]+5).midicps, inf));
Pdefn(\ixiDuration, Pshuf([0.5, 0.25, 0.5, 0.25], inf));
Pdefn(\ixiAmp, 0.25, inf);
Pdefn(\ixiTrig, 0.75, inf);
Pdefn(\ixiRQ, 0.75, inf);
Pdefn(\ixiWait, Pshuf([0.125, 0.25, 0.25, 0.5, 0.25], inf));
)
~ixibass.play;

// 8.  Change the outbus
Pdefn(\sinOutBus, \reverb, inf);


// 9. Change effect parameters
~rose.setEffect(\reverb, \room, 0.99);
~rose.setEffect(\reverb, \mix, 0.99);
~rose.setEffect(\reverb, \damp, 0.99);


// 10.  Change the outbus
Pdefn(\sinOutBus, \distortion, inf);

// 11.  Change the outbus
~rose.setEffect(\distortion, \postGain, 0.12);
~rose.setEffect(\distortion, \preGain, 50.0);


// 12.  Stop the pstream
~sin.stop;
