
// create This Peer
//  + effectBank
//  + effectList

("~/git/sphnxr/init.scd").loadPaths;

//shortcut for Peer
~me=~addrBook.me;

~me.addEffect(\reverb, \freeverb);
~me.addEffect(\reverb2, \freeverb);
~me.addEffect(\distortion, \dist);

~me.effectsList;
~me.effectIndex(\reverb);
~me.effectIndex(\masterOut);
~me.effectIndex(\reverb2);
~me.freeEffect(\reverb2);
~me.freeEffect(\reverb);
~me.effectsList;

