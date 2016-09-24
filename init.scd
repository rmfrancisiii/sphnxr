// INIT: load deps

"initializing".postln;
"loading dependencies...".postln;

~pwd=thisProcess.nowExecutingPath.dirname;
("present directory:" +/+ ~pwd).postln;

(~pwd +/+ "/config.scd").loadPaths;

"rebooting server".postln;

s.reboot;

"waiting for boot".postln;

s.waitForBoot({
	"booted".postln;

	(~pwd +/+ "/join_utopia.scd").loadPaths;

	"initializing groups...".postln;
	// groups

	~groups = Dictionary.newFrom(List[
		\synthGroup,  ~synthGroup = Group.tail(s),
		\effectGroup,  ~effectGroup = Group.tail(s)
	]);

	//s.queryAllNodes;

	~groups.keys.postln;

	"initialized.".postln;



	// buffers
	"loading buffers".postln;

	~arrayOfBuffers = (~pwd +/+ "/granSamples/*").pathMatch.collect {
		|file|
		Buffer.readChannel(s, file, channels:0);

	};

	"loaded.".postln;

	// busses
	~busses = Dictionary.newFrom(List[
		\masterOut,  ~masterOut = s.outputBus
	]);

	(~pwd +/+ "/oscDefs.scd").loadPaths;
	(~pwd +/+ "synthdefs/sin.scd").loadPaths;
	(~pwd +/+ "synthdefs/saw.scd").loadPaths;

});

	// synthdefs
	//granular
	//fm
	//sinsynth
	//polysynth
	//vocoder

	// environment







	// instantiate synths

	~synths = [
	];


	// instantiate effects
	~effects = [
		~distort = Synth.head(~effectGroup, \dist, [\outBus, ~masterOut]);
		~freeverb = Synth.head(~effectGroup, \freeverb, [\outBus, ~masterOut]);
	];


	// pdefn's


	// test network and audio setup/sync



	"inititialization complete".postln;
	