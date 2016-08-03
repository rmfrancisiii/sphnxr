(
s.options.device="Jack Router";
s.boot;


s.waitForBoot({
	var sampfolder = "/git/sphnxr/granSamples/*";
	~arrayOfBuffers = sampfolder.pathMatch.collect {|file| Buffer.read(s, file);};

	//set up display of network peers

	~win = Window("AdHocSociety").minimize;
	~win.layout = VLayout.new.add(~listView = ListView.new);
	~addrBook = AddrBook.new;
	// to get updates, just add a dependant
	~addrBook.addDependant({|addrBook, what, who|
		{~listView.items = addrBook.peers.collectAs({|peer|
			peer.name ++ " | " ++ peer.addr.ip ++ " | " ++ if(peer.online, "online", "offline");
		}, Array)}.defer;
	});

	// **** set hostname here ****
	// make this dynamic?
	~addrBook.addMe("river"); // add this machine
	~hail = Hail(~addrBook);

	OSCdef.newMatching(\synthMsg,
		{|msg, time, addr, recvPort |
			msg= Dictionary.newFrom(msg.drop(1));
			Synth(msg[\instrument], msg.getPairs);
			"message received".postln;
	}, "/synthMsg"); // path matching


	SynthDef(\gran, {|numChannels=1, bufOffset=0, bufPos=0, grainrate=10.0, graindur1=0.1, graindur2=0.1, pan=0, amp=0.85, duration=1.0,  playrate1=0.5, playrate2=1.5, envbuf=(-1.0), envA = #[0,1,0], envB = #[1,1]|
	var bufferNum=~arrayOfBuffers[0].bufnum+bufOffset;
	var env = EnvGen.kr(
		Env(envA, envB, \sin),
		timeScale: duration,
		levelScale: amp,
		doneAction: 2);
	Out.ar(0,
		GrainBuf.ar(2, Impulse.kr(grainrate), LFNoise1.kr.range(graindur1, graindur2), bufferNum, LFNoise1.kr.range(playrate1, playrate2),
			LFNoise2.kr(0.1).range(0, 1), 2, pan, envbuf) * env)
	}).add;
});

)

x = Synth(\gran, [\bufOffset, 1, \duration, 15, \grainrate, 10, \playrate1, 0.5, \playrate2, 1.5, \graindur1, 0.1, \graindur2, 0.5, \pan, 0, \envA, [0,1,0], \envB, [0.95, 0.5]]);



OSCdef.all;
~meRout.stop;