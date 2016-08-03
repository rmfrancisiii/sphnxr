(
~win = Window("AdHocSociety").front;
~win.layout = VLayout.new.add(~listView = ListView.new);

~addrBook = AddrBook.new;
// to get updates, just add a dependant
~addrBook.addDependant({|addrBook, what, who|
    {~listView.items = addrBook.peers.collectAs({|peer|
        peer.name ++ " | " ++ peer.addr.ip ++ " | " ++ if(peer.online, "online", "offline");
    }, Array)}.defer;
});

~addrBook.addMe; // will automatically add you using your user name

~hail = Hail(~addrBook);

)
(

s.boot;

~local = NetAddr("127.0.0.1", NetAddr.langPort);

SynthDef(\sin, {|freq=1000, dur=10, amp=0.5, pan=0, att=0.5, mod1=10, mod2=10 |
  var env = Env([0.001, 0.99, 0.001], [att, 1.0-att], [\sin, \sin]);
  var envGen = EnvGen.kr(env, doneAction: 2, timeScale: dur);
   var sin = SinOsc.ar([freq, freq*4/3, freq*5/4], SinOsc.ar(XLine.kr(mod1, mod2, dur), 0, 2pi), amp);
  Out.ar(0, Pan2.ar(sin * envGen, pan));
}).add;

SynthDef(\saw, {|amp=0.5, freq=1000, dur=10, pan=0, att=0.5|
  var env = Env([0.001, 0.15, 0.001], [att, 1.0-att], [\sin, \sin]);
  var envGen = EnvGen.kr(env, doneAction: 2, timeScale: dur);
  var sin = Saw.ar([freq, freq*4/3, freq*5/4], amp);
  Out.ar(0, Pan2.ar(0.25*sin * envGen, pan));
}).add;

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
  \target, ~addrBook.at(\james).addr,
  \oscpath, "/synthMsg",
  \instrument, Prand([\saw, \sin], inf),
  \freq, Prand([100, 200, 300, 440], inf),
  \dur, Prand([1.5, 1.75], inf),
  \amp, Prand([0.05, 0.01, 0.1], inf),
  \pan, Prand([0.0, -0.25, -0.5, -0.75, -1.0, 0.25, 0.5, 0.75, 1.0], inf),
  \att, Prand([0.01, 0.1, 0.25], inf),
   \mod1, Prand([1, 10, 100, 200, 440], inf),
   \mod2, Prand([1, 10, 100, 200, 440], inf),
).asStream;

)

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