("~/git/sphnxr/init.scd").loadPaths;

~busses.add(\freeverbIn -> ~freeverbIn = Bus.audio(s,2));
~busses.add(\Distortionin -> ~freeverbOut = Bus.audio(s,2));
~addrBook.send(\rose, "/busListMsg");
