"loading synthdef \ixibass...".post;
SynthDef(\ixibass, {arg out=0, amp=0.3, t_trig=1, freq=100, rq=0.004;
// An example, using a nice Bass synth posted by Thor Magnusson in the sc-users list:
	var env, signal;
	var rho, theta, b1, b2;
	b1 = 1.98 * 0.989999999 * cos(0.09);
	b2 = 0.998057.neg;
	signal = SOS.ar(K2A.ar(t_trig), 0.123, 0.0, 0.0, b1, b2);
	signal = RHPF.ar(signal, freq, rq) + RHPF.ar(signal, freq*0.5, rq);
	signal = Decay2.ar(signal, 0.4, 0.3, signal);
	DetectSilence.ar(signal, 0.01, doneAction:2);
	Out.ar(out, signal*(amp*0.45)!2);
}).add;
"loaded.".postln;


"loading synthdef \gran...".post;
SynthDef(\gran, {|
	granOutBus=(~masterOut),
	granNumChannels=1,
	granBufOffset=0,
	granBufPos=0.1,
	granRate=10.0,
	granDurMin=0.1,
	granDurMax=0.1,
	granPlayRateMin=0.5,
	granPlayRateMax=2,
	granEnvBuf=(-1.0),
	granEnvLevels = #[0,1,0],
	granEnvTimes = #[1,1],
	granPan=0,
	granAmp=0.85,
	granDuration=1.0|
	var bufferNum=~arrayOfBuffers[0].bufnum+granBufOffset;
	var env = EnvGen.kr(
		Env(granEnvLevels, granEnvTimes, \sin),
		timeScale: granDuration,
		levelScale: granAmp,
		doneAction: 2);
	Out.ar(granOutBus,
		GrainBuf.ar(2, Impulse.kr(granRate), LFNoise1.kr.range(granDurMin, granDurMax), bufferNum, LFNoise1.kr.range(granPlayRateMin, granPlayRateMax), LFNoise2.kr(granBufPos).range(0, 1), 2, granPan, granEnvBuf) * env)
}).add;
"loaded.".postln;



"loading synthdef \freeverb...".post;
~busses.add(\freeverbIn -> ~freeverbIn = Bus.audio(s,2));
SynthDef(\freeverb, {|
	outBus=(~masterOut),
	mix = 0.25,
	room = 0.15,
	damp = 0.5|
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
"loaded.".postln;

"loading synthdef \dist...".post;
~busses.add(\distortIn -> ~distortIn = Bus.audio(s,2));

SynthDef(\dist, {|
	outBus=(~masterOut),
	preGain=8,
	postGain=0.6|
	var input = In.ar(~distortIn, 2);
	var sig = (input * preGain).distort;
	Out.ar(outBus, sig * postGain);
}).add;
"loaded.".postln;
