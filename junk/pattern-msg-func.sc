
(
s.boot;

//NetAddr.new(Pipe.new("ifconfig en1 | grep \"inet \" | awk '{print $2}'" , "r").getLine, NetAddr.langPort)

NetAddr("127.0.0.1", NetAddr.langPort);
~local = NetAddr("127.0.0.1", NetAddr.langPort);
~robert = NetAddr("192.168.0.104", NetAddr.langPort);
~jeff = NetAddr("192.168.0.101", NetAddr.langPort);



~robert.sendMsg("/robert", "Test from james");
~jeff.sendMsg("/jeff", "Test from james");


a = SynthDef(\drone1, {|amp=0.1, freq=1000, dur=10, pan=0, att=0.5 |
    var env = Env([0.001, 0.99, 0.001], [att, 1.0-att], [\sin, \sin]);
    var envGen = EnvGen.kr(env, doneAction: 2, timeScale: dur);
    var sin = SinOsc.ar(freq, 0, amp);
    Out.ar(0, Pan2.ar(sin * envGen, pan));
}).add;

b = SynthDef(\drone2, {|amp=0.1, freq=1000, dur=10, pan=0, att=0.5|
    var env = Env([0.001, 0.99, 0.001], [att, 1.0-att], [\sin, \sin]);
    var envGen = EnvGen.kr(env, doneAction: 2, timeScale: dur);
    var sin = Saw.ar(freq, amp);
    Out.ar(0, Pan2.ar(sin * envGen, pan));
}).add;


~msg = {|message|
    message[\target].sendMsg(
        message[\oscpath],
        message[\synth],
        message[\amp],
        message[\freq],
        message[\dur],
        message[\pan],
        message[\att]);
};

~oscDrone1 = OSCFunc.newMatching({|msg, time, addr, recvPort |
	var synth=msg[1], amp=msg[2], freq=msg[3], dur=msg[4], pan=msg[5], att=msg[6];
    Synth(synth, [\freq, freq, \dur, dur, \amp, amp, \pan, pan, \att, att]);
}, "/drone1"); // path matching

~oscDrone2 = OSCFunc.newMatching({|msg, time, addr, recvPort |
    var synth=msg[1], amp=msg[2], freq=msg[3], dur=msg[4], pan=msg[5], att=msg[6];
    Synth(synth, [\freq, freq, \dur, dur, \amp, amp, \pan, pan, \att, att]);
}, "/drone2"); // path matching

~oscMsg = OSCFunc.newMatching({|msg, time, addr, recvPort |
	msg[1].postln}, "/message"); // path matching


)

(

var p = Pbind(
    \target, ~local,
    \oscpath, "/drone2",
    \synth, Prand([\drone2], inf),
    \freq, Prand([500, 230, 1040], inf),
    \dur, Prand([0.5, 0.75, 1.0, 1.5 ], inf),
    \amp, Prand([0.05, 0.15, 0.25, 0.35, 0.45, 0.5, 0.75], inf),
    \pan, Prand([0.0, -0.25, -0.5, -0.75, -1.0, 0.25, 0.5, 0.75, 1.0], inf),
	\att, Prand([0.01, 0.15], inf)
).asStream;

var q = Pbind(
    \target, ~local,
    \oscpath, "/drone1",
    \synth, Prand([\drone1], inf),
    \freq, Prand([400, 800, 100, 140], inf),
    \dur, Prand([0.5, 0.75, 1.0, 1.5, 0, 0 ], inf),
    \amp, Prand([0.05, 0.15, 0.25, 0.35, 0.45, 0.5, 0.75], inf),
    \pan, Prand([0.0, -0.25, -0.5, -0.75, -1.0, 0.25, 0.5, 0.75, 1.0], inf),
	\att, Prand([0.01, 0.25, 0.75], inf)
).asStream;
)

(
r = Routine({
    loop({
        ~msg.(p.next(()));
		~msg.(q.next(()));
        0.5.wait;
    })
}).play;
)

r.stop