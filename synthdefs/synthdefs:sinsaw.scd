@@ -36,12 +36,13 @@ s.sync;

"creating ~sinRhythm".post;


~sinRhythm = PStream(

	Pbind(
		\target, Pdefn(\target, \temper, inf),
		\target, Pdefn(\sinsawTarget, ~hostname, inf),
		\oscpath, "/synthMsg",
		\instrument, Pdefn(\instrument, \sin, inf),
		\instrument, Pdefn(\sinsawInstrument, \sin, inf),
		\sinsawOutBus, Pdefn(\sinsawOutBus, 0, inf),
		\sinsawFreq, Pdefn(\sinsawFreq),
		\sinsawDuration, Pdefn(\sinsawDuration, 0.1, inf),