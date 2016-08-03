(
Server.default = s = Server.local;
thisThread.randSeed_(120);
s.options.maxNodes_(4096);
s.options.memSize_(32768);
s.options.device="JackRouter";
s.options.outDevice = "JackRouter";
s.options.inDevice = "JackRouter";
s = Server.local.reboot;
~pwd=thisProcess.nowExecutingPath.dirname;

s.waitForBoot({

	~groups = [
		// put these groups in order, synths >> effects
		~synthGroup = Group.tail(s),
		~effectGroup = Group.tail(s)
	];

	~busses = [
		~masterOut = s.outputBus;
		~freeverbIn = Bus.audio(s,2),
		~distortIn = Bus.audio(s,2),
	];

	// Load buffers from folder into an array
	~arrayOfBuffers = (~pwd +/+ "/granSamples/*").pathMatch.collect {
		|file|
		Buffer.readChannel(s, file, channels:0);

	};

	(~pwd +/+ "/join_utopia.scd").loadPaths;
	(~pwd +/+ "/sphincter.scd").loadPaths;

	s.sync;

	~distort = Synth.head(~effectGroup, \dist, [\outBus, ~masterOut]);
	~freeverb = Synth.head(~effectGroup, \freeverb, [\outBus, ~masterOut]);

	~clock = BeaconClock(~addrBook).permanent_(true);
	~clock.tempo = 1;
	TempoClock.default = ~clock;


}) // wait for boot

)
(

~sinRhythm = PStream(

	Pbind(
		\target, Pdefn(\target, \river, inf),
		\oscpath, "/synthMsg",
		\instrument, Pdefn(\instrument, \saw, inf),
		\sinsawOutBus, Pdefn(\sinsawOutBus, 0, inf),
		\sinsawFreq, Pdefn(\sinsawFreq, Pseq([
			Pshuf([[65,68,70],     68, 70, 72].midicps, 6),
			Pshuf([65, 65, 68, 70, 72, 77, 77].midicps, 2)
		],inf)),
		\sinsawDuration, Pdefn(\sinsawDuration, Prand([0.25], inf)),
		\sinsawAmp, Pdefn(\sinsawAmp, Pseq([0.15], inf)),
		\sinsawPan, Pdefn(\sinsawPan, Prand([0.0, -0.25, 0.25], inf)),
		\sinsawAtt, Pdefn(\sinsawAtt, Pseq([0.05], inf)),
		\sinsawMod1, Pdefn(\sinsawMod1, Prand([0.0, 1, 2.5, 5], inf), inf),
		\sinsawMod2, Pdefn(\sinsawMod2, Prand([0.0, 1, 2.5, 5], inf), inf)
	), Pdefn(\sinsawWait, Pseq([0.2], inf)),
	~addrBook,
	~clock, 1

).play;

)

~rhythmLoop = {
	loop({
		16.wait;
		Pdefn(\sinsawWait, Pshuf([0.5, 0.5, 0.25, 0.5, 0.25], inf));
		"section".postln;
		16.wait;
		Pdefn(\sinsawWait, Pshuf([0.5, 0.5, 0.25, 0.5, 0.25], inf));
		"section".postln;
		4.wait;
		Pdefn(\sinsawWait, Pshuf([0.5, 0.75, 0.25, 0.25, 0.25], inf));
		"section".postln;
	})
}.fork(~clock, quant: 1);

)

Pdefn(\sinsawMod1, 1, inf);
Pdefn(\sinsawMod2, 1, inf);
Pdefn(\sinsawOutBus, 6, inf);
~sinRhythm.stop;
~sinRhythm2.stop;


~arrayOfBuffers.do({|i,item| postf("%. % \n", i.bufnum, i.path)});
~distortIn.index.postln;
~freeverbIn.index.postln;

~freeverb.set(\mix, 0.75);
~freeverb.set(\room, 0.50);
~freeverb.set(\damp, 0.50);

~granStream.stop;
