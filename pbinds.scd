"creating ~sinRhythm".post;


~sinRhythm = PStream(

	Pbind(
		\target, Pdefn(\sinsawTarget, ~hostname, inf),
		\oscpath, "/synthMsg",
		\instrument, Pdefn(\sinsawInstrument, \sin, inf),
		\outBus, Pdefn(\sinsawOutBus, 0, inf),
		\freq, Pdefn(\sinsawFreq),
		\dur, Pdefn(\sinsawDuration, 0.1, inf),
		\amp, Pdefn(\sinsawAmp, 0, inf),
		\pan, Pdefn(\sinsawPan, 0, inf),
		\att, Pdefn(\sinsawAtt),
		\mod1, Pdefn(\sinsawMod1),
		\mod2, Pdefn(\sinsawMod2)
	), Pdefn(\sinsawWait, 0.1, inf),
	~addrBook
);
