//session file


// 1.  Edit config.scd to set local server stuff. This is for
//         Audio hardware, RAM allocation, etc.

// 2.  Run the initialization file,
("~/git/sphnxr/init.scd").loadPaths;
//         which should connect to the network and
//         instantiate shared synths


// 3.  Load generic pstreams
("~/git/sphnxr/pstreams.scd").loadPaths;


// 4.  Generic testing (optional)
("~/git/sphnxr/tests.scd").loadPaths;


(
//5. AFTER all Peers have joined
// This should create an env variable named for each peer in the AddrBook
~addrBook.names.do({ arg item, i;
	currentEnvironment.put(item.asSymbol, ~addrBook.at(item.asSymbol));
	item.postln });
)



(
// 6.  Add a couple of effects.
~rose.addEffect(\reverb, \freeverb);
~rose.addEffect(\distortion, \dist);
)

// note: to see available effects: ~peer.effectsList;
~river.effectsList;
~rose.effectsList;

// note: if for some reason the effects lists arent updating, have the machine that isn't working run this:
~addrBook.broadcastEffectList;




(
// 7.  Now set the individual pdefns for one synth

Pdefn(\sinTarget, \rose, inf);
Pdefn(\sinInstrument, \sin, inf);
Pdefn(\sinOutBus, \masterOut, inf);
Pdefn(\sinFreq, Pshuf(([48,50,52,53,55,57,58]).midicps, inf));
Pdefn(\sinAmp, 0.5, inf);
Pdefn(\sinAtt, 0.01, inf);
Pdefn(\sinWait, Pseq([0.5], inf));
Pdefn(\sinDuration, Pseq([0.25], inf));
Pdefn(\sinPan, Pseq([0], inf));

// this is a slightly more complex pattern:
Pdefn(\sinFreq,
	Pseq([
		Pshuf([48,50,52,53,55,57,58].midicps, 4),
		Pseq([48,52,53,55,58].midicps, 2)
	], inf),
	inf);
)



// 8. this is just to make sure the global tempo is set to something reasonable.
~clock.setGlobalTempo(1);


// 9.  Start the synth
~sin.play;


(
// 10.  Now set the individual pdefns for a second synth
Pdefn(\ixiTarget, \rose, inf);
Pdefn(\ixiInstrument, \ixibass, inf);
Pdefn(\ixiOutBus, \masterOut, inf);
Pdefn(\ixiFreq, Pshuf(([48,50,52,53,55,57,58]).midicps, inf));
Pdefn(\ixiAmp, 0.05, inf);
Pdefn(\ixiTrig, 1, inf);
Pdefn(\ixiRQ, 0.004, inf);
Pdefn(\ixiWait, Pseq([0.5], inf));
)

// 11. Start the synth
~ixibass.play;


// 12. change timing:
Pdefn(\sinWait, Pseq([0.25], inf));


// 13. change timing back:
Pdefn(\sinWait, Pseq([0.5], inf));

// 14.  Change the outbus to an effect
(
~rose.setEffect(\distortion, \postGain, 0.05);
~rose.setEffect(\distortion, \preGain, 20.0);

Pdefn(\ixiOutBus, \reverb, inf);
Pdefn(\sinOutBus, \distortion, inf);
)

// 15. try 1/4 notes
Pdefn(\ixiWait, Pseq([0.25], inf));

// 16. try 1/8 notes
Pdefn(\ixiWait, Pseq([0.125], inf));

(
// 17. try a more complicated pattern
Pdefn(\sinWait, Pshuf([0.125, 0.5, 0.125, 0.25], inf));
Pdefn(\sinDuration, Pshuf([0.125, 0.25, 0.5, 0.125], inf));
Pdefn(\ixiWait, Pshuf([0.125, 0.25, 0.5, 0.125], inf));
)

(
// 18.  Change the modulation of the sin synth
Pdefn(\sinOutBus, \reverb, inf);
Pdefn(\sinMod1, Prand([0,1,10,20,25,100,500], inf));
)


// 19.  Change the effect and the modulation
(
~rose.setEffect(\reverb, \room, 0.75);
~rose.setEffect(\reverb, \mix, 0.5);
~rose.setEffect(\reverb, \damp, 0.5);
Pdefn(\sinMod2, Pseq([0,1,10,20,25,100,500], inf));
)

// 20. try doubling the clock:
~clock.setGlobalTempo(2,10);


(
// 21. note clock set 4x as fast, wait time set 4x as long

~clock.setGlobalTempo(4,0);
Pdefn(\ixiWait, Pseq([1], inf));
Pdefn(\sinWait, Pseq([1], inf));
)

(
// 22. back to normal
~clock.setGlobalTempo(1);
Pdefn(\ixiWait, Pseq([0.5], inf));
Pdefn(\sinWait, Pseq([0.5], inf));
Pdefn(\sinMod1, Prand([0], inf));
Pdefn(\sinMod2, Pseq([0], inf));
)

// 23.  Stop the pstream
~sin.stop;
~ixibass.stop;





(
// 24.  Now set the individual pdefns for the granular synth
Pdefn(\granTarget, \rose, inf);
Pdefn(\granInstrument, \gran, inf);
Pdefn(\granOutBus, \reverb, inf);
Pdefn(\granNumChannels, 1, inf);
Pdefn(\granEnvBuf, -1, inf);
Pdefn(\granBufOffset, Prand([0,1,2,3,4,5,6,7,8,9], inf));
Pdefn(\granBufPos, Prand([0.1, 0.5, 0.75, 0.9], inf));
Pdefn(\granRate, Prand([1, 2, 5, 10, 15, 20, 25, 50, 100, 500], inf));
Pdefn(\granDurMin, Prand([0.2, 0.5, 0.75, 1, 2], inf));
Pdefn(\granDurMax, Prand([0.2, 0.5, 0.75, 1, 2], inf));
Pdefn(\granPlayRateMin, Prand([0.1, 0.5, 0.75, 1.0, 1.25, 1.5, 2, 4, 5, 10], inf));
Pdefn(\granPlayRateMax, Prand([0.1, 0.5, 0.75, 1.0, 1.25, 1.5, 2, 4, 5, 10], inf));
Pdefn(\granPan, Prand([0.0, -0.25, -0.5, -0.75, -1.0, 0.25, 0.5, 0.75, 1.0], inf));
Pdefn(\granAmp, Prand([0.1, 0.15, 0.25], inf));
Pdefn(\granNoteDuration, Prand([0.5, 1.0, 1.5, 2.0, 5.0, 10.0], inf));
Pdefn(\granWait, Prand([0.5, 1.0, 1.5, 2.0, 5.0], inf));
)

// Warning: make sure the clock isnt anything crazy
~clock.setGlobalTempo(1,10);

// Note: to see the buffers you have loaded
~buffers.postln


// 25. just play a single "note"
~granular.step;


// 26. start playing
~granular.play;

// 27. Stop the granular
~granular.stop;