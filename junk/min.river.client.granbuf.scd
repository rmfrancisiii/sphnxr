(
s.options.device="Jack Router";
s.boot;

s.waitForBoot({
~samples = List.new(3);
~samples.add(Buffer.read(s, "/git/sphnxr/granSamples/dinosr.wav".standardizePath));
~samples.add(Buffer.read(s, "/git/sphnxr/granSamples/ferry.aiff".standardizePath));
~samples.add(Buffer.read(s, "/git/sphnxr/granSamples/regulator.wav".standardizePath));
})

)
~samples[2].play;

(

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
		// "message received".postln;
}, "/synthMsg"); // path matching



SynthDef(\gran, {|amp=0.85, duration=1.0, granrate=10.0, sndbuf=(~samples[0]), envbuf=(-1.0)|
	var pan = 0;
	var env = EnvGen.kr(
		Env([0, 1, 0], [1, 1], \sin),
		timeScale: duration,
		levelScale: amp,
		doneAction: 2);
	Out.ar(0,
		GrainBuf.ar(2, Impulse.kr(granrate), 0.1, sndbuf, LFNoise1.kr.range(0.5, 2),
			LFNoise2.kr(0.1).range(0, 1), 2, pan, envbuf) * env)
}).add;


)

x = Synth(\gran, [\sndbuf, ~samples[0], \duration, 5, \granrate, 100]);

x = Synth(\gran, [\sndbuf, ~samples[2]]);


OSCdef.all;
~meRout.stop;