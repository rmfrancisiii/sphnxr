(
Server.default = s = Server.local;
// thisThread.randSeed_(120);
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

	(".." +/+ ~pwd +/+ "/join_utopia.scd").loadPaths;
	(".." +/+ ~pwd +/+ "/sphincter.scd").loadPaths;

	s.sync;

	~distort = Synth.head(~effectGroup, \dist, [\outBus, ~masterOut]);
	~freeverb = Synth.head(~effectGroup, \freeverb, [\outBus, ~masterOut]);

}) // wait for boot
)

~aMinor[
	[45,47,48,50,52,53,55],
]


(
~sinRhythm = PStream(

	Pbind(
		\target, Pdefn(\target, \river, inf),
		\oscpath, "/synthMsg",
		\instrument, Pdefn(\instrument, \sin, inf),
		\sinsawOutBus, Pdefn(\sinsawOutBus, 6, inf),
		\sinsawFreq, Pdefn(\sinsawFreq, Pseq([
			Pshuf([45, 48, 50,52].midicps, 4),
			Pshuf([45,47,48,50,52,53,55].midicps, 2)],
				inf)),
		\sinsawDuration, Pdefn(\sinsawDuration, Pseq([0.5, 0.5, 0.25, 0.5, 0.25], inf)),
		\sinsawAmp, Pdefn(\sinsawAmp, Pseq([0.025], inf)),
		\sinsawPan, Pdefn(\sinsawPan,
			Prand([0.0, -0.25, -0.5, -0.75, -1.0, 0.25, 0.5, 0.75, 1.0], inf)),
		\sinsawAtt, Pdefn(\sinsawAtt, Pseq([0.01], inf)),
		\sinsawMod1, Pdefn(\sinsawMod1, 0, inf),
		\sinsawMod2, Pdefn(\sinsawMod2, 0, inf)
	), Pdefn(\sinsawWait, Pseq([0.5, 0.5, 0.25, 0.5, 0.25], inf)),
	~addrBook

).play;
)

(
Pdefn(\sinsawOutBus, 4, inf);
Pdefn(\sinsawFreq, Pshuf([60, 62, 62, 66].midicps, inf));
Pdefn(\sinsawDuration, Pshuf([0.5, 0.5, 0.25, 0.5, 0.25], inf));
Pdefn(\sinsawAmp, Pseq([0.025], inf));
Pdefn(\sinsawPan, Pseq([0.0, -0.25, -0.5, -0.75, -1.0, 0.25, 0.5, 0.75, 1.0], inf));
Pdefn(\sinsawAtt, Pseq([0.01], inf));
Pdefn(\sinsawMod1, 4, inf);
Pdefn(\sinsawMod2, 5, inf);
Pdefn(\sinsawWait, Pshuf([0.25, 0.25, 0.25, 0.5, 0.25], inf));

)


~arrayOfBuffers.do({|i,item| postf("%. % \n", i.bufnum, i.path)});
~distortIn.index.postln;
~freeverbIn.index.postln;

~freeverb.set(\mix, 0.95);
~freeverb.set(\room, 0.95);
~freeverb.set(\damp, 0.95);

~granStream.stop;
~sinRhythm.stop;
