(
s.boot;

~local = NetAddr("127.0.0.1", NetAddr.langPort);
~sndBuffer = CtkBuffer.playbuf("~/ferry.aiff".standardizePath, channels: 0);
~sndBuffer.load;

SynthDef(\gliss, {|duration, buffer=~sndBuffer, grainFreq, grainPeriod, grainAmp, env = 1|
	var trigger = Impulse.ar(grainFreq);
	var rate = LFNoise2.kr(0.1).range(0.707, 1.3);
	var pos = LFNoise1.kr(2).range(0, 0.1);
	var pan = WhiteNoise.ar * EnvGen.kr(Env([0, 1, 0], [0.5, 0.5], [5, -5]), timeScale: duration);
	var grains = GrainBuf.ar(2, trigger, grainPeriod, buffer, rate, pos, 4, pan);
	var out = grains;
	Out.ar(0, out* grainAmp*env);
});

~msg = {|msg|
  var target = msg.removeAt(\target);
  var path = msg.removeAt(\oscpath);
  var sndMsg = msg.getPairs;
  target.sendMsg(path, *sndMsg);
};

OSCdef.newMatching(\synthMsg,
  {|msg, time, addr, recvPort |
      msg= Dictionary.newFrom(msg.drop(1));
      Synth(msg[\instrument], msg.getPairs);
}, "/synthMsg"); // path matching


~me = Pbind(
	\target, ~local,
	\oscpath, "/synthMsg",
	\instrument, Prand([\gliss], inf),
	\duration, 60.0,
	\grainFreq, 500.0,
	\grainPeriod, 0.01,
	\grainAmp, 0.5
).asStream;

)

      ~msg.(~me.next(()));




(
~waitSeq = Prand([0.5, 0.25, 0.1],inf).asStream;

~meRout = Routine({
  loop({
      ~msg.(~me.next(()));
      ~waitSeq.next.wait;
  })
}).play;

)


OSCdef.all;
~meRout.stop;