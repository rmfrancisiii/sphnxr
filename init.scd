"loading dependencies...".postln;

~pwd=thisProcess.nowExecutingPath.dirname;
("present directory:" +/+ ~pwd).postln;

(~pwd +/+ "/config.scd").loadPaths;

@@ -51,21 +52,12 @@ s.waitForBoot({
	]);

	(~pwd +/+ "/oscDefs.scd").loadPaths;

	(~pwd +/+ "synthdefs/sphincter.scd").loadPaths;
	(~pwd +/+ "synthdefs/sinsaw.scd").loadPaths;


});

	// config
	//file paths
	//server options

	// join_utopia

	// OSC_defs

	// synthdefs
	//granular
	//fm

	// pdefn's


	// test network and audio setup/sync



	"inititialization complete".postln;
	