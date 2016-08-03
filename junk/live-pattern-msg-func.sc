NetAddr.new(Pipe.new("ifconfig en1 | grep \"inet \" | awk '{print $2}'" , "r").getLine, NetAddr.langPort)
//~local.sendMsg("/msg", "Test from james");
//~robert.sendMsg("/impdef2", "Test from james");
//~jeff.sendMsg("/jeff", "Test from james");



(
s.boot;


NetAddr("127.0.0.1", NetAddr.langPort);
~local = NetAddr("127.0.0.1", NetAddr.langPort);
~robert = NetAddr("192.168.0.109", NetAddr.langPort);
~jeff = NetAddr("192.168.0.107", NetAddr.langPort);
~jason = NetAddr("192.168.0.105", NetAddr.langPort);

a = SynthDef(\drone1, {|amp=0.1, freq=1000, dur=10, pan=0, att=0.5 |
    var env = Env([0.001, 0.99, 0.001], [att, 1.0-att], [\sin, \sin]);
    var envGen = EnvGen.kr(env, doneAction: 2, timeScale: dur);
    var sin = SinOsc.ar(freq, 0, amp);
    Out.ar(0, Pan2.ar(sin * envGen, pan));
}).add;

b = SynthDef(\drone2, {|amp=0.5, freq=1000, dur=10, pan=0, att=0.5|
    var env = Env([0.001, 0.15, 0.001], [att, 1.0-att], [\sin, \sin]);
    var envGen = EnvGen.kr(env, doneAction: 2, timeScale: dur);

	var sin = Saw.ar([freq, freq*4/3, freq*5/4], amp);
	Out.ar(0, Pan2.ar(0.25*sin * envGen, pan));
}).add;





~msg = {|message|
    message[\target].sendMsg(
        message[\oscpath],
        message[\synth],
        message[\amp],
        message[\freq],
		message[\dur],
        message[\pan],
		message[\att])
};

~impmsg = {|message|
    message[\target].sendMsg(
        message[\oscpath],
        message[\synth],
        message[\freq],
		message[\harm],
		message[\width],
        message[\sustain],
        message[\amp],
		message[\pan])
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
	msg[1].postln}, "/msg"); // path matching


)

(

~sin = Pbind(
    \target, ~local,
    \oscpath, "/drone1",
    \synth, Prand([\drone1], inf),
    \freq, Pseq([200, 400, 800, 100, 140], inf),
    \dur, Pseq([0.5, 0.75, 1.0, 1.5 ], inf),
    \amp, Prand([0.05, 0.15, 0.25, 0.35, 0.45, 0.5, 0.75], inf),
	\pan, Prand([0.0, -0.25, -0.5, -0.75, -1.0, 0.25, 0.5, 0.75, 1.0], inf)
).asStream;


)
(
~saw = Pbind(
    \target, ~local,
    \oscpath, "/drone2",
    \synth, Prand([\drone2], inf),
    \freq, Pseq([50, 100, 200, 400], inf),
    \dur, Pseq([0.5, 0.75, 1.0, 1.5 ], inf),
    \amp, Prand([0.75, 0.75, 0.5, 0.75], inf),
    \pan, Prand([0.0, -0.25, -0.5, -0.75, -1.0, 0.25, 0.5, 0.75, 1.0], inf),
	\att, Prand([0.9, 0.5, 0.75], inf)
).asStream;
)

(
~imp = Pbind(
    \target, ~robert,
    \oscpath, "/impdef2",
    \synth, Prand([\impdef2], inf),
    \freq, Prand([500, 230, 100], inf),
	\harm, Prand([6/4, 5/4, 2/3, 3/2], inf),
	\width, Prand([0.5, 0.23, 0.1, 0.9], inf),
    \sustain, Prand([2.5, 25.0, 10.0, 15.0 ], inf),
    \amp, Prand([0.05, 0.15, 0.125, 0.135, 0.145, 0.115], inf),
	\pan, Prand([0.0, -0.25, -0.5, -0.75, -1.0, 0.25, 0.5, 0.75, 1.0], inf)
).asStream;
)

(
~jeffDrone = Pbind(
    \target, ~jeff,
    \oscpath, "/drone",
    \synth, Prand([\drone], inf),
    \freq, Pseq([200, 400, 800, 100, 140], inf),
    \dur, Prand([0.15, 0.25, 0.10, 0.05, 0, 0 ], inf),
    \amp, Prand([0.05, 0.15, 0.25, 0.135, 0.145, 0.115, 0.175], inf),
    \pan, Prand([0.0, -0.25, -0.5, -0.75, -1.0, 0.25, 0.5, 0.75, 1.0], inf),
	\att, Prand([0.9, 0.75, 0.5], inf)
).asStream;
)


~waitSeq = Pseq([0.5, 0.25, 0.5, 0.25, 0.5],inf).asStream;
~impWait = Pseq([1.0, 0.5, 0.25, 0.15],inf).asStream;

)



~jeffRout = Routine({
	loop({
		~msg.(~jeffDrone.next(()));
		~waitSeq.next.wait;
    })
}).play;


~impRout = Routine({
	loop({
		~impmsg.(~imp.next(()));
		~impWait.next.wait;
    })
}).play;

~sawRout = Routine({
	loop({
		~msg.(~saw.next(()));
		~waitSeq.next.wait;
    })
}).play;

~sinRout = Routine({
	loop({
		~msg.(~sin.next(()));
		~waitSeq.next.wait;
    })
}).play;



(
~sinRout.stop;
~impRout.stop;
~sawRout.stop;
~sinRout.stop;
)