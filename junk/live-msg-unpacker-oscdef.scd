(
// connect

NetAddr("127.0.0.1", NetAddr.langPort);
~local = NetAddr("127.0.0.1", NetAddr.langPort);


// boot local server

s=Server.local;
s.options.outDevice = "JackRouter";
s.options.inDevice = "JackRouter";
s.boot;
)

(
// define synths

x = SynthDef(\sin, {|freq=1000, dur=10, amp=0.5, pan=0, att=0.5, mod1=10, mod2=10 |
    var env = Env([0.001, 0.5, 0.001], [att, 1.0-att], [\sin, \sin]);
    var envGen = EnvGen.kr(env, doneAction: 2, timeScale: dur);
	var sin = SinOsc.ar(freq, SinOsc.ar(XLine.kr(mod1, mod2, dur), 0, 2pi), amp);
    Out.ar(0, Pan2.ar(sin * envGen, pan));
}).add;

y = SynthDef(\saw, {|amp=0.5, freq=1000, dur=10, pan=0, att=0.5|
    var env = Env([0.001, 0.45, 0.001], [att, 1.0-att], [\sin, \sin]);
    var envGen = EnvGen.kr(env, doneAction: 2, timeScale: dur);
    var sin = Saw.ar([freq, freq*4/3, freq*5/4], amp);
    Out.ar(0, Pan2.ar(0.25*sin * envGen, pan));
}).add;
)

(
// Define sender and Listener
~msg = {|msg|
    var target = msg.removeAt(\target);
    var path = msg.removeAt(\oscpath);
    var sndMsg = msg.getPairs;
    target.sendMsg(path, *sndMsg);
};

~oscDef = OSCdef.newMatching(\synthMsg,
    {|msg, time, addr, recvPort |
        msg= Dictionary.newFrom(msg.drop(1));
        Synth(msg[\instrument], msg.getPairs);
 }, "/synthMsg"); // path matching
)

(

// initialize pattern defaults
~waitSeq = Pseq([1.0], inf).asStream;
~freqSeq = Pseq([200], inf).asStream;
~durSeq = Pseq([ 0.15], inf);
~ampSeq = Pseq([0.25], inf);
~panSeq = Pseq([0.0], inf).asStream;
~attSeq = Pseq([0.5], inf).asStream;
~mod1Seq = Pseq([1], inf).asStream;
~mod2Seq = Pseq([1], inf).asStream;
//~mod1Seq = Pseq([1,2,3,12], inf).asStream;
//~mod2Seq = Prand([1,2,3], inf).asStream;


~waitSeq = Pseq([0.5], inf).asStream;
~waitSeq = Pseq([0.25], inf).asStream;
~waitSeq = Pseq([0.15], inf).asStream;
~freqSeq = Pseq([200,100], inf).asStream;

~freqSeq = Pseq([200,100, 50, 220], inf).asStream;
~durSeq = Pseq([ 0.15, 0.05, 0.1], inf);

~freqSeq = Pseq([200,100, 50, 220, 600,2000], inf).asStream;

~waitSeq = Pseq([0.5, 0.25, 1.0, 0.75], inf).asStream;
~durSeq = Pseq([ 0.15, 0.25, 0.1], inf);

~freqSeq = Prand([200,100, 400], inf).asStream;

~waitSeq = Pseq([0.5, 0.25, 1.0, 0.75], inf).asStream;
~durSeq = Pseq([ 0.15, 0.25, 0.1], inf);

~freqSeq = Prand([200,100, 260, 320, 400], inf).asStream;
~durSeq = Pseq([ 0.15, 0.25, 0.1], inf);
~attSeq = Pseq([0.5, 0.25, 0.75], inf).asStream;

~freqSeq = Prand([[100,1000,500,750],200,100, 260, 320, 400], inf).asStream;
~durSeq = Pseq([ 0.15, 0.25, 0.1], inf);
~attSeq = Pseq([0.5, 0.25, 0.75], inf).asStream;
~panSeq = Pexprand(-0.75, 0.75, inf).asStream;

~attSeq = Pexprand(0.01, 0.15, inf).asStream;
~durSeq = Prand([ 0.15, 0.025, 0.1], inf);

~attSeq = Pexprand(0.01, 0.15, inf).asStream;
~durSeq = Pexprand(0.01, 0.025, inf);

~waitSeq = Prand([1.5, 1.0, 0.75], inf).asStream;

~durSeq = Pexprand(0.1, 0.05, inf);

~durSeq = Pexprand(0.1, 0.15, inf);

~durSeq = Pexprand(0.1, 0.2, inf);

~durSeq = Pexprand(0.25, 0.5, inf);

~waitSeq = Pexprand(0.5, 0.25, inf).asStream;

~freqSeq = Pexprand(100, 4400, inf).asStream;

~freqSeq = Pexprand(50, 2400, inf).asStream;

~waitSeq = Pexprand(1.5, 1.25, inf).asStream;

~freqSeq = Pseq([50, 60, 80, 100,200, 400, 600,1200 ], inf).asStream;

~attSeq = Pseq([0.1, 0.2, 0.5], inf).asStream;
~durSeq = Pexprand(1, 1.5, inf);
~waitSeq = Pexprand(2.25, 2.5, inf).asStream;

~freqSeq = Pseq([50, 60, 80, 100,200, 400, 600,1200 ], inf).asStream;
~durSeq = Pexprand(0.1, 0.5, inf);
~waitSeq = Pexprand(2.25, 3.5, inf).asStream;



~attSeq = Pexprand(0.01, 0.25, inf);
~durSeq = Pexprand(0.1, 0.5, inf);


~mod1Seq = Pseq([1,2,4], inf).asStream;
~mod2Seq = Prand([1,2,4], inf).asStream;

~freqSeq = Pseq([50, 60, 80, 100,200], inf).asStream;
~durSeq = Pseq([0.25, 0.25, 0.25, 0.5], inf);
~waitSeq = Pseq([0.5, 0.75, 0.25, 0.5], inf);

~me = Pbind(
    \target, ~local,
    \oscpath, "/synthMsg",
    \instrument, \sin,
    \freq, ~freqSeq,
    \dur, ~durSeq,
    \amp, ~ampSeq,
    \pan, ~panSeq,
    \att, ~attSeq,
	\mod1, ~mod1Seq,
	\mod2, ~mod2Seq
).asStream;

// Start pattern
~meRout = Routine({
    loop({
        ~msg.(~me.next(()));
        ~waitSeq.next.wait;
    })
}).play;
)





(// Cleanup

~meRout.stop;
OSCdef.freeAll;
s.quit;
)