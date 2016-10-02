("~/git/sphnxr/init.scd").loadPaths;

~rose=~addrBook.at(\rose);
~me=~addrBook.me;

~rose.addEffect(\reverb, \freeverb);
~rose.addEffect(\distortion, \dist);
~rose.listEffects;
~rose.effectNames;
~rose.effectBusIndex(\distortion);
~rose.effectBus(\distortion);

~rose.effectSet(\distortion, );

~rose.effectFree(\distortion);
~rose.listEffects;
~rose.effectFree(\reverb);
~rose.listEffects;

~addrBook.at(\rose).effectList.addEffect(\distortion, \dist);
~addrBook.at(\rose).effectList.busIndex(\distortion);

~addrBook.peers;
~addrBook.names;
~addrBook.at(\rose).postln;


~addrBook.send(\rose, "/busListMsg");

~addrBook.send(\rose, "/addEffect", "reverb", "freeverb");
~addrBook.send(\rose, "/addEffect", "distortion1", "dist");

~addrBook.send(\rose, "/busListMsg");

