//  get present working directory
("Finding present working directory:\n" + ~pwd=thisProcess.nowExecutingPath.dirname).postln;

"Loading Local Configuration file".postln;

(~pwd +/+ "/config.scd").loadPaths;
("Server Configuration Loaded. \nBooting server with new values:" + (~delim = "\n\n-----------\n")).postln;

s.reboot;

s.waitForBoot({
	(~delim + "\nServer booted Successfully").postln;

	"Joining Network".postln;
	(~pwd +/+ "/join_utopia.scd").loadPaths;
	("Joined Network: Success" + ~delim).postln;

	// Load OSC listeners
	(~pwd +/+ "/oscDefs.scd").loadPaths;
	s.sync;
	("Local OSC Listeners initialized: Success").postln;


	// groups
	~groups = Dictionary.newFrom(List[
		\synthGroup,  ~synthGroup = Group.tail(s),
		\effectGroup,  ~effectGroup = Group.tail(s)
	]);
	s.sync;
	("Local Groups initialized: Success").postln;



	// Busses
	~busses = Dictionary.newFrom(List[
		\masterOut,  ~masterOut = s.outputBus]);
	("Local Busses initialized: Success " + ~delim).postln;



	// Load Buffers
	~buffers = (~pwd +/+ "/granSamples/*").pathMatch.collect {
		|file|
		(file+"loaded").postln;
		Buffer.readChannel(s, file, channels:0);
	};

	("Local Buffers loaded: Success" + ~delim).postln;

	s.sync;

	// Synths
	"Loading Synths".postln;
	~synths = (~pwd +/+ "/synths/*").pathMatch.collect {
		|file|
			file.loadPaths;
		(file +/+ "  loaded").postln };
	("Synths initialized: Success " + ~delim).postln;


	// Effects
	"Loading Effects".postln;
	~effects = (~pwd +/+ "/effects/*").pathMatch.collect {
		|file|
			file.loadPaths;
		(file +/+ " loaded").postln };
	("Effects initialized: Success " + ~delim).postln;


		// Test Peers
	"Testing Utopia Peers:".postln;
	~addrBook.peers.do({arg item, i;
		("  Test Message sent to"+item.name).postln;
		~addrBook.send(item.name, "/testMsg")}
	);



	"Ready to Collide >>".postln;

});

	// synthdefs
	//granular
	//fm
	//sinsynth
	//polysynth
	//vocoder
