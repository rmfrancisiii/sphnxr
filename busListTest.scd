("~/git/sphnxr/init.scd").loadPaths;

~effectlist=EffectList.new;
~effectlist.addEffect("freeverb", "freeverb" );
~effectlist.addEffect("distortion", "dist" );
~effectlist.addEffect("distortion2", "dist" );
~effectlist.list;
~effectlist.names;

~effectlist.busIndex(\masterOut).postln;
~effectlist.busIndex(\distortion).postln;
~effectlist.busIndex(\distortion2).postln;
~effectlist.busIndex(\freeverb).postln;


// Free Effect
~effectlist.free(\freeverb);
