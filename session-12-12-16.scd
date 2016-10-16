//session file


// FIRST:  edit config.scd to set local server stuff. This is for
//         Audio hardware, RAM allocation, etc.

// SECOND: run the initialization file,
//         which should connect to the network and
//         instantiate shared synths

("~/git/sphnxr/init.scd").loadPaths;

(

// This should create an env variable named for each peer in the AddrBook
~me=~addrBook.me;

~addrBook.names.do({ arg item, i;
	currentEnvironment.put(item.asSymbol, ~addrBook.at(item.asSymbol));
	item.postln });



// add a couple of effects.

~rose.addEffect(\reverb, \freeverb);
~rose.addEffect(\distortion, \dist);
~rose.effectsList;

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
)

(
// 3. now set the individual pdefns

Pdefn(\sinsawTarget, \rose, inf);
Pdefn(\sinsawInstrument, \sin, inf);
Pdefn(\sinsawOutBus, \masterOut, inf);
Pdefn(\sinsawFreq, Pshuf(([40,52,54,55,58,60]).midicps, inf));

Pdefn(\sinsawFreq, Pslide((#[1,2,3,4,5,8,10]+30).midicps, inf, 2, 1, 3));




// Pdefn(\sinsawFreq,
// 	Pshuf(
// 		(
// 			Pslide((#[1,2,3,4,5,8,10]+30).midicps, inf, 2, 1, 3),
// 			Pslide((#[1,2,3,4,5,8,10]+30).midicps, inf, 2, 1, 3)
// 	)),
// inf);



	Pslide((#[1,2,3,4,5,8,10]+30).midicps, inf, 2, 1, 3));






Pdefn(\sinsawDuration, Pwalk(
    [0.1, 0.5, 0.25, 0.5, 0.25],
    Pseq([1], inf),
    Pseq([1, -1], inf),    // turn around at either end
    0));


Pdefn(\sinsawDuration, Pshuf([0.1, 0.5, 0.25, 0.5, 0.25]/2, inf));


Pdefn(\sinsawMod1, Pshuf([15, 0.25, 0.15, 0.05], inf));
Pdefn(\sinsawMod2, Pshuf([0.15, 0.25, 15, 5], inf));


Pdefn(\sinsawAmp, Pshuf([0.15, 0.25, 0.15, 0.05]*3, inf));
Pdefn(\sinsawAtt, 0.001, inf);

Pdefn(\sinsawAtt, Pshuf([0.0125, 0.25, 0.25, 0.5, 0.25], inf));

(
Pdefn(\sinsawWait, Pwalk(
    [0.124, 0.25, 0.25, 0.15, 0.05]/1,
    Pseq([1], inf),
    Pseq([1, -1], inf),    // turn around at either end
    0));
)
Pdefn(\sinsawWait, Pshuf([0.125, 0.25, 0.25, 0.5, 0.25]/2, inf));
)


// 4. start the pstreams
(
~sinsaw.stop;
~sinsaw.play;
)
Pdefn(\sinsawInstrument, \saw, inf);
Pdefn(\sinsawOutBus, \reverb, inf);
~rose.setEffect(\reverb, \room, 0.99);
~rose.setEffect(\reverb, \mix, 0.5);
~rose.setEffect(\reverb, \damp, 0.99);

~sinsaw.stop;


Pdefn(\sinsawInstrument, \sin, inf);
Pdefn(\sinsawOutBus, \distortion, inf);

~sinsaw2.play;




Pdefn(\sinsawOutBus, \masterOut, inf);


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

