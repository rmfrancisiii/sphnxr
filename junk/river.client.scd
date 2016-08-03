// RUN THIS FIRST

// Choose soundcard and environment variables
// Join the network
// Setup osc Def (listener)
// create synthdefs
// Load

(
thisThread.randSeed_(120);
//Server.default = s = Server.internal;
//s.options.maxNodes_(4096);
//s.options.memSize_(32768);
//s.options.device="Jack Router";
s.boot;

s.waitForBoot({


	//set up display of network peers
	~win = Window("AdHocSociety").front;
	~win.layout = VLayout.new.add(~listView = ListView.new);
	~win.alwaysOnTop = true;

	~addrBook = AddrBook.new;
	// to get updates, just add a dependant
	~addrBook.addDependant({|addrBook, what, who|
		{~listView.items = addrBook.peers.collectAs({|peer|
			peer.name ++ " | " ++ peer.addr.ip ++ " | " ++ if(peer.online, "online", "offline");
		}, Array)}.defer;
	});

	~addrBook.addMe("hostname".unixCmdGetStdOut.split($.)[0];); // add this machine
	~hail = Hail(~addrBook);

	OSCdef.newMatching(\synthMsg,
		{|msg, time, addr, recvPort |
			msg= Dictionary.newFrom(msg.drop(1));
			Synth(msg[\instrument], msg.getPairs);
			// "message received".postln;
	}, "/synthMsg"); // path matching

	SynthDef(\sin, {|freq=1000, duration=1, amp=0.5, pan=0, att=0.5, mod1=10, mod2=10 |
		var env = Env([0.001, 0.99, 0.001], [att, 1.0-att], [\sin, \sin]);
		var envGen = EnvGen.kr(env, doneAction: 2, timeScale: duration);
		var sin = SinOsc.ar(freq, SinOsc.ar(XLine.kr(mod1, mod2, duration), 0, 2pi), amp);
		Out.ar(0, Pan2.ar(sin * envGen, pan));
	}).add;

	SynthDef(\saw, {|freq=1000, duration=1, amp=0.7, pan=0, att=0.5|
		var env = Env([0.001, 0.15, 0.001], [att, 1.0-att], [\sin, \sin]);
		var envGen = EnvGen.kr(env, doneAction: 2, timeScale: duration);
		var saw = Saw.ar(freq, amp);
		Out.ar(0, Pan2.ar(saw * envGen, pan));
	}).add;


	// Load buffers from folder into an array
	~arrayOfBuffers = "/git/sphnxr/granSamples/*".pathMatch.collect {|file| Buffer.read(s, file);};
	~arrayOfBuffers.do({|i,item| i.bufnum.postln});
	// arg: numChannels: 1, trigger: 0, dur: 1,
	//      sndbuf, rate: 1, pos: 0, interp: 2,
	//      pan: 0, envbufnum: -1, maxGrains: 512,
	//      mul: 1, add: 0

	SynthDef(\gran, {|numChannels=1, bufOffset=0, bufPos=0.1,
		grainRate=10.0, grainDurMin=0.1, grainDurMax=0.1,
		playRateMin=0.5, playRateMax=2, envBuf=(-1.0),
		envLevels = #[0,1,0], envTimes = #[1,1],
		pan=0, amp=0.85, duration=1.0 |
		var bufferNum=~arrayOfBuffers[0].bufnum+bufOffset;
		var env = EnvGen.kr(
			Env(envLevels, envTimes, \sin),
			timeScale: duration,
			levelScale: amp,
			doneAction: 2);
		Out.ar(0,
			GrainBuf.ar(2, Impulse.kr(grainRate), LFNoise1.kr.range(grainDurMin, grainDurMax), bufferNum, LFNoise1.kr.range(playRateMin, playRateMax), LFNoise2.kr(bufPos).range(0, 1), 2, pan, envBuf) * env)
	}).add;



		SynthDef(\freeverb, {
		|outBus = 0, mix = 0.25, room = 0.15, damp = 0.5|
		var input = In.ar(~freeverbIn, 2);
		Out.ar(outBus,
			FreeVerb.ar(
				input,
				mix, // mix 0-1
				room, // room 0-1
				damp // damp 0-1
			)
		);
	}).add;
}) // wait for boot

)

x = Synth.new(\freeverb, [\inBus, b, \mix, 0.01,\room, 0.25, \damp, 0.05]);

LFNoise1.ar.range(200, 1400).play;

//test granbuf
x = Synth(\gran, [\bufOffset, 7, \duration, 20, \grainRate, 2, \playRateMin, 0.5, \playRateMax, 1, \grainDurMin, 0.1,\grainDurMax, 2.0, \pan, 0, \bufPos, 0.25, \envLevels, [0,1,0], \envTimes, [0.05, 0.95]]);

x = Synth(\gran);
y = Synth(\sin);
z = Synth(\saw);

OSCdef.all;