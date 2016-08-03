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
	~clock2 = TempoClock(2);
	TempoClock.default = ~clock;


}) // wait for boot
)





(
~sinRhythm = PStream(

	Pbind(
		\target, Pdefn(\target, \river, inf),
		\oscpath, "/synthMsg",
		\instrument, Pdefn(\instrument, \sin, inf),
		\sinsawOutBus, Pdefn(\sinsawOutBus, 6, inf),
		\sinsawFreq, Pdefn(\sinsawFreq, Pseq([
			Pshuf([45,     48, 50, 52].midicps, 6),
			Pshuf([45, 45, 48, 50, 52, 57, 57].midicps, 2)
		],inf)),
		\sinsawDuration, Pdefn(\sinsawDuration, Pseq([0.5, 0.5, 0.25, 0.5, 0.25], inf)),
		\sinsawAmp, Pdefn(\sinsawAmp, Pseq([0.15], inf)),
		\sinsawPan, Pdefn(\sinsawPan, Prand([0.0, -0.25,0.25], inf)),
		\sinsawAtt, Pdefn(\sinsawAtt, Pseq([0.01], inf)),
		\sinsawMod1, Pdefn(\sinsawMod1, 0, inf),
		\sinsawMod2, Pdefn(\sinsawMod2, 0, inf)
	), Pdefn(\sinsawWait, Pseq([0.5, 0.5, 0.25, 0.5, 0.25], inf)),
	~addrBook,
	~clock, 1

).play;


~sinRhythm2 = PStream(

	Pbind(
		\target, Pdefn(\target2, \river, inf),
		\oscpath, "/synthMsg",
		\instrument, Pdefn(\instrument2, \saw, inf),
		\sinsawOutBus, Pdefn(\sinsaw2OutBus, 6, inf),
		\sinsawFreq, Pdefn(\sinsaw2Freq, Pseq([
			Pshuf([45,     48, 50, 52].midicps, 6),
			Pshuf([45, 45, 48, 50, 52, 57, 57].midicps, 2)],
				inf)),
		\sinsawDuration, Pdefn(\sinsaw2Duration, Pseq([0.5, 0.5, 0.25, 0.5, 0.25], inf)),
		\sinsawAmp, Pdefn(\sinsaw2Amp, Pseq([0.15], inf)),
		\sinsawPan, Pdefn(\sinsaw2Pan,
			Prand([0.0, -0.25, 0.25], inf)),
		\sinsawAtt, Pdefn(\sinsaw2Att, Pseq([0.01], inf)),
		\sinsawMod1, Pdefn(\sinsaw2Mod1, 0, inf),
		\sinsawMod2, Pdefn(\sinsaw2Mod2, 0, inf)
	), Pdefn(\sinsaw2Wait, Pseq([0.5, 0.5, 0.25, 0.5, 0.25], inf)),
	~addrBook,
	~clock, 1

).play;

~rhythmLoop = {
	loop({
		16.wait;
		Pdefn(\sinsawWait, Pshuf([0.5, 0.5, 0.25, 0.5, 0.25], inf));
		Pdefn(\sinsaw2Wait, Pshuf([0.5, 0.5, 0.25, 0.5, 0.25], inf));
		"section".postln;
		16.wait;
		Pdefn(\sinsawWait, Pshuf([0.5, 0.5, 0.25, 0.5, 0.25], inf));
		Pdefn(\sinsaw2Wait, Pshuf([0.5, 0.5, 0.25, 0.5, 0.25], inf));
		"section".postln;
		4.wait;
		Pdefn(\sinsawWait, Pshuf([0.5, 0.75, 0.25, 0.25, 0.25], inf));
		Pdefn(\sinsaw2Wait, Pshuf([0.5, 0.75, 0.25, 0.25, 0.25], inf));		"section".postln;
	})
}.fork(~clock, quant: 1);

)


Pdefn(\sinsawAmp, Pseq([0.15], inf));


~clock.tempo = 1;


~sinRhythm.stop;
~sinRhythm2.stop;


~arrayOfBuffers.do({|i,item| postf("%. % \n", i.bufnum, i.path)});
~distortIn.index.postln;
~freeverbIn.index.postln;

~freeverb.set(\mix, 0.95);
~freeverb.set(\room, 0.95);
~freeverb.set(\damp, 0.95);

~granStream.stop;
