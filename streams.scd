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
		~vocCarIn = Bus.audio(s,1),
		~vocModIn = Bus.audio(s,1)
	];

	p = "/git/manly.wav";
	~manlyBuf = Buffer.readChannel(s, p, channels:0);


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

}) // wait for boot
)


(


~granStream = PStream(
	Pbind(
		\target, Pdefn(\target, \river, inf),
		\oscpath, "/synthMsg",
		\instrument, \gran,
		\granOutBus, Pdefn(\granOutBus, 0, inf),
		\granBufOffset, Pdefn(\granBufOffset, 0, inf),
		\granBufPos, Pdefn(\granBufPos, 0.5, inf),
		\granRate, Pdefn(\granRate, 1.0),
		\granDurMin, Pdefn(\granDurMin, 0.15),
		\granDurMax, Pdefn(\granDurMax, 1.25),
		\granPlayRateMin, Pdefn(\granPlayRateMin, 1),
		\granPlayRateMax, Pdefn(\granPlayRateMax, 1),
		\granDuration, Pdefn(\granDuration, 0.5, inf),
		\granAmp, Pdefn(\granAmp, 0.25, inf),
		\granPan, Pdefn(\granPan, 0, inf)
	), Pdefn(\granWait, 0.25, inf),
	~addrBook

).play;
)

(
Pdefn(\granWait, 0.15, inf)
Pdefn(\granWait, Prand([0.1250, 0.2],inf));
Pdefn(\granOutBus, Prand([0,4,6]), inf);
Pdefn(\granBufOffset, 5, inf);
Pdefn(\granBufOffset, Prand([1,2,3,4,5,6,7,8,9,10,11], inf));
Pdefn(\granBufPos, Prand([0.1, 0.5, 0.75, 0.9], inf));
Pdefn(\granRate, Prand([ 1, 4, 20, 50, 100,500], inf));
Pdefn(\granDurMin, Prand([0.1], inf));
Pdefn(\granDurMax, Prand([0.25], inf));
Pdefn(\granPlayRateMin, Prand([0.15, 0.5], inf));
Pdefn(\granPlayRateMax, Prand([0.025, 0.25], inf));
Pdefn(\granDuration, Prand([0.25, 0.5, 1.0, 2.0], inf));
Pdefn(\granAmp, Prand([0.15, 0.1], inf));
Pdefn(\granPan, Prand([0.0, -0.25, -0.5, -0.75, -1.0, 0.25, 0.5, 0.75, 1.0], inf));
)


(
~sinRhythm = PStream(

	Pbind(
		\target, Pdefn(\target, \river, inf),
		\oscpath, "/synthMsg",
		\instrument, Pdefn(\instrument, \sin, inf),
		\sinsawOutBus, Pdefn(\sinsawOutBus, 6, inf),
		\sinsawFreq, Pdefn(\sinsawFreq, Pseq([60, 62, 62, 66].midicps, inf)),
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
Pdefn(\sinsawOutBus, 0, inf);
Pdefn(\sinsawFreq, Pshuf([60, 62, 62, 66].midicps, inf));
Pdefn(\sinsawDuration, Pshuf([0.5, 0.5, 0.25, 0.5, 0.25], inf));
Pdefn(\sinsawAmp, Pseq([0.25], inf));
Pdefn(\sinsawPan, Pseq([0.0, -0.25, -0.5, -0.75, -1.0, 0.25, 0.5, 0.75, 1.0], inf));
Pdefn(\sinsawAtt, Pseq([0.01], inf));
Pdefn(\sinsawMod1, 4, inf);
Pdefn(\sinsawMod2, 5, inf);
Pdefn(\sinsawWait, Pshuf([0.25, 0.25, 0.25, 0.5, 0.25], inf));

)


~car = PStream(

	Pbind(
		\target, Pdefn(\target, \river, inf),
		\oscpath, "/synthMsg",
		\instrument, Pdefn(\instrument, \saw, inf),
		\sinsawOutBus, Pdefn(\sinsawOutBus, 0, inf),
		\sinsawFreq, Pdefn(\sinsawFreq, Pseq([60, 62, 62, 66].midicps, inf)),
		\sinsawDuration, Pdefn(\sinsawDuration, Pseq([0.5, 0.5, 0.25, 0.5, 0.25], inf)),
		\sinsawAmp, Pdefn(\sinsawAmp, Pseq([0.5], inf)),
		\sinsawPan, Pdefn(\sinsawPan,
			Prand([0.0, -0.25, -0.5, -0.75, -1.0, 0.25, 0.5, 0.75, 1.0], inf)),
		\sinsawAtt, Pdefn(\sinsawAtt, Pseq([0.01], inf)),
		\sinsawMod1, Pdefn(\sinsawMod1, 0, inf),
		\sinsawMod2, Pdefn(\sinsawMod2, 0, inf)
	), Pdefn(\sinsawWait, Pseq([0.5, 0.5, 0.25, 0.5, 0.25], inf)),
	~addrBook

).play;
(
~car = Synth.head(~synthGroup,
	\saw, [
		\sinsawOutBus, ~vocModIn,
		\sinsawFreq, 60.midicps,
		\sinsawDuration, 60.0,
		\sinsawAmp, 5.0,
		\sinsawAtt, 0.01

]);
)
~mod = Synth.head(~synthGroup,
	\playBuffer, [
		\outBus, ~vocCarIn,
		\buffer, ~manlyBuf

]);


~voc = Synth.head(~effectGroup,
	\vocoder, [
		\outBus, ~masterOut,
		\carIn, ~vocCarIn,
		\modIn, ~vocModIn,
		\carAmp, 4,
		\numBands, 5
]);

~vocCarIn.postln;


~voc.free;

~arrayOfBuffers.do({|i,item| postf("%. % \n", i.bufnum, i.path)});
~distortIn.index.postln;
~freeverbIn.index.postln;

~freeverb.set(\mix, 0.95);
~freeverb.set(\room, 0.95);
~freeverb.set(\damp, 0.95);

~granStream.stop;
~sinRhythm.stop;
