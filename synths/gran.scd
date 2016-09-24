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
	var bufferNum=~buffers[0].bufnum+granBufOffset;
	var env = EnvGen.kr(
		Env(granEnvLevels, granEnvTimes, \sin),
		timeScale: granDuration,
		levelScale: granAmp,
		doneAction: 2);
	Out.ar(granOutBus,
		GrainBuf.ar(2, Impulse.kr(granRate), LFNoise1.kr.range(granDurMin, granDurMax), bufferNum, LFNoise1.kr.range(granPlayRateMin, granPlayRateMax), LFNoise2.kr(granBufPos).range(0, 1), 2, granPan, granEnvBuf) * env)
}).add;