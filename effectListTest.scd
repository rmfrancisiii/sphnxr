("~/git/sphnxr/init.scd").loadPaths;

~me=~addrBook.me;


//fake another participant
~hail2 = Hail(me: Peer(\me2, NetAddr.localAddr));
~hail2 = Hail(me: Peer(\me3, NetAddr.localAddr));

/// This should create an env variable named for each peer in an address book that references the peer directly

~addrBook.names.do({ arg item, i;
	currentEnvironment.put(item.asSymbol, ~addrBook.at(item.asSymbol));
	item.postln });

~rose.postln;
~me2.postln;
~me2.postln;



~rose.listEffects;
~river.listEffects;

~river.addEffect(\reverb, \freeverb);
~river.addEffect(\distortion, \dist);
~rose.addEffect(\reverb, \freeverb);
~rose.addEffect(\distortion, \dist);

~rose.listEffects;
~me2.listEffects;
~me2.listEffects;

~river.listEffects;

~rose.effectBusIndex(\distortion);
~rose.effectBus(\distortion);

~rose.postln;

// shift+Command+T to dump node tree
~rose.effectSet(\distortion, \preGain, 12);
~rose.effectSet(\distortion, \postGain, 0.12);





// shift+Command+T to dump node tree

~rose.effectFree(\distortion);
~rose.listEffects;
~rose.effectFree(\reverb);
~rose.listEffects;
~river.listEffects;




// Try it all remotely:

~addrBook.send(\river, "/busListMsg");
~addrBook.send(\rose, "/busListMsg");
~addrBook.send(\river, "/addEffect", "reverb2", "freeverb");
~addrBook.send(\river, "/addEffect", "distortion2", "dist");
// shift+Command+T to dump node tree

~addrBook.send(\river, "/effectSet", \distortion, \preGain, 20);
// shift+Command+T to dump node tree
~addrBook.send(\rose, "/busListMsg");

OSCdef

s.queryAllNodes;