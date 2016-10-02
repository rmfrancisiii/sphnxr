("~/git/sphnxr/init.scd").loadPaths;

~addrBook.peers;
~rose=~addrBook.at(\rose);
~river=~addrBook.at(\river);
~me=~addrBook.me;

~rose.addEffect(\reverb, \freeverb);
~rose.addEffect(\distortion, \dist);
~rose.listEffects;
~rose.effectNames;
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




// Try it all remotely:

~addrBook.send(\river, "/busListMsg");
~addrBook.send(\rose, "/busListMsg");
~addrBook.send(\river, "/addEffect", "reverb", "freeverb");
~addrBook.send(\river, "/addEffect", "distortion", "dist");
// shift+Command+T to dump node tree

~addrBook.send(\river, "/effectSet", \distortion, \preGain, 20);
// shift+Command+T to dump node tree
~addrBook.send(\rose, "/busListMsg");

s.queryAllNodes;
s.dumpTree;

~addrBook.send(\rose, "/busListMsg");

~addrBook.send(\river, "/busListMsg");
