//session file


//// glurggg. this only works locally. on a remote machine the management of busses isn't robust enough... could send details as osc data. need OSCDef for Bus responder.


("~/git/sphnxr/init.scd").loadPaths;



~addrBook.names.postln;
~addrBook.at(\rose).postln;
~addrBook.addrs(\rose).postln;
~addrBook.addrs.postln;


// NEXT (after "ready to Collide")
(

~busses.add(\freeverbIn -> ~freeverbIn = Bus.audio(s,2));
~busses.add(\freeverbOut -> ~freeverbOut = Bus.audio(s,2));
~freeverb = Synth.head(~effectGroup, \freeverb, [\outBus, ~masterOut, \inBus, ~freeverbIn]);
~freeverb.set(\mix, 0.95);
~freeverb.set(\room, 0.95);
~freeverb.set(\damp, 0.95);

)

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
Pdefn(\sinsawOutBus, ~freeverbIn.index, inf);
Pdefn(\sinsawOutBus, ~masterOut.index, inf);
)

// start the pstreams
(
~sinsaw.play;
)




Pdefn(\sinsawOutBus, ~masterOut.index, inf);
Pdefn(\sinsawFreq, Pshuf(([50,52,54,55,58,60].midicps*1), inf));
Pdefn(\sinsawDuration, Pshuf([0.5, 0.25, 0.5, 0.25]*0.01, inf));
Pdefn(\sinsawAmp, 0.5, inf);
Pdefn(\sinsawWait, Pshuf([0.125, 0.25, 0.25, 0.5, 0.25], inf));

~freeverb.set(\mix, 0.25);
~freeverb.set(\room, 0.15);
~freeverb.set(\damp, 0.25);


// change the p midstream:


(

)




SynthDescLib.global.read;
SynthDescLib.global.browse;


~busses.postln;

~busses.keysValuesDo{ |key, value| key.post; value.index.postln};

~routeIn.get({ arg val; val.postln;});


~distort = Synth.head(~effectGroup, \dist, [\outBus, ~masterOut]);

~freeverbOut.index.postln;
~freeverbIn.index.postln;
~masterOut.index.postln;




)





(
Pdefn(\sinsawOutBus, (~masterOut.index), inf);
)

(

)



//  (~freeverb.index).postln;

//change the effect values






// stop the pstream
(
~sinsaw.stop;
)
