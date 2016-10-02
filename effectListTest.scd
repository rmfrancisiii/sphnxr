("~/git/sphnxr/init.scd").loadPaths;

~rose=~addrBook.at(\rose);
~rose.effectList.addEffect(\reverb, \freeverb);
~rose.effectList.list.postln;
~rose.effectList;



~addrBook.at(\rose).effectList.addEffect(\distortion, \dist);
~addrBook.at(\rose).effectList.busIndex(\distortion);

~addrBook.peers;
~addrBook.names;
~addrBook.at(\rose).postln;


~addrBook.send(\rose, "/busListMsg");

~addrBook.send(\rose, "/addEffect", "reverb", "freeverb");
~addrBook.send(\rose, "/addEffect", "distortion1", "dist");

~addrBook.send(\rose, "/busListMsg");

