"/git/sphnxr/sphincter.scd".loadPaths;

(


~granStream = PStream(
	Pbind(
	\target, Pdefn(\target, \river, inf),
	\oscpath, "/synthMsg",
	\instrument, \gran,
	\outBus, Pdefn(\outBus, 0, inf),
	\bufOffset, Pdefn(\bufOffset, 3, inf),
	\bufPos, Pdefn(\bufPos, 0.5, inf),
	\grainRate, Pdefn(\grainRate, 1.0),
	\grainDurMin, Pdefn(\grainDurMin, 0.15),
	\grainDurMax, Pdefn(\grainDurMax, 1.25),
	\playRateMin, Pdefn(\playRateMin, 1),
	\playRateMax, Pdefn(\playRateMax, 1),
	\grainDuration, Pdefn(\grainDuration, 0.5, inf),
	\grainAmp, Pdefn(\grainAmp, 0.25, inf),
	\grainPan, Pdefn(\grainPan, 0, inf)
), Pdefn(\grainWait, 0.25, inf), ~addrBook).play;

)

(
Pdefn(\grainWait, Prand([0.3,0.5,1,3,4],inf));
Pdefn(\outBus, Prand([0,4,6]), inf);
Pdefn(\bufOffset, 5, inf);
Pdefn(\bufOffset, Prand([0,1,2,3,4,5,6], inf));
Pdefn(\bufPos, Prand([0.1, 0.5, 0.75, 0.9], inf));
Pdefn(\grainRate, Prand([ 1, 2, 5], inf));
Pdefn(\grainDurMin, Prand([ 1, 2, 3], inf));
Pdefn(\grainDurMax, Prand([ 1, 2, 3], inf));
Pdefn(\playRateMin, Prand([0.1,0.5, 0.75], inf));
Pdefn(\playRateMax, Prand([0.1,0.5, 0.75], inf));
Pdefn(\grainDuration, Prand([1.5, 2.0], inf));
Pdefn(\grainAmp, Prand([0.15, 0.25, 0.35], inf));
Pdefn(\grainPan, Prand([0.0, -0.25, -0.5, -0.75, -1.0, 0.25, 0.5, 0.75, 1.0], inf));
)

(
~sinStream = PStream(
	Pbind(
	\target, Pdefn(\target, \river, inf),
	\oscpath, "/synthMsg",
	\instrument, Prand([\saw, \sin], inf),
	\outBus, Prand([0,4,6], inf),
	\freq, Prand([100, 200, 300, 440], inf),
	\duration, Prand([0.5, 1.0, 1.5, 1.75, 5.0, 10.0], inf),
	\amp, Prand([0.01, 0.025, 0.1], inf),
	\pan, Prand([0.0, -0.25, -0.5, -0.75, -1.0, 0.25, 0.5, 0.75, 1.0], inf),
	\att, Prand([0.01, 0.1, 0.25], inf),
	\mod1, Prand([1, 10, 100, 200, 440], inf),
	\mod2, Prand([1, 10, 100, 200, 440], inf),
), Pdefn(\grainWait, 0.25, inf), ~addrBook).play;


)


~distortIn.index.postln;
~freeverbIn.index.postln;

~freeverb.set(\mix, 0.95);
~freeverb.set(\room, 0.95);
~freeverb.set(\damp, 0.95);

~granStream.stop;
~sinStream.stop;