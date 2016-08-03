(

~sendStream = {|msg|
  var target = msg.removeAt(\target);
  var path = msg.removeAt(\oscpath);
  var sndMsg = msg.getPairs;
  target.sendMsg(path, *sndMsg);
};

~stream1 = Pbind(
	\target, ~addrBook.at(\river).addr,
	\oscpath, "/synthMsg",
	\instrument, Prand([\saw, \sin], inf),
	\outbus, Prand([1], inf),
	\freq, Prand([100, 200, 300, 440], inf),
	\duration, Prand([0.5, 1.0, 1.5, 1.75, 5.0, 10.0], inf),
	\amp, Prand([0.1, 0.2, 0.5], inf),
	\pan, Prand([0.0, -0.25, -0.5, -0.75, -1.0, 0.25, 0.5, 0.75, 1.0], inf),
	\att, Prand([0.01, 0.1, 0.25], inf),
	\mod1, Prand([1, 10, 100, 200, 440], inf),
	\mod2, Prand([1, 10, 100, 200, 440], inf),
).asStream;

~stream2 = Pbind(
	\target, ~addrBook.at(\river).addr,
	\oscpath, "/synthMsg",
	\instrument, Prand([\gran], inf),
	\outbus, Prand([0,1], inf),
	\bufOffset, Prand([0,1,2,3,4,5,6,7,8,9], inf),
	\bufPos, Prand([0.1, 0.5, 0.75, 0.9], inf),
	\grainRate, Prand([0.1, 10, 100, 500], inf),
	\grainDurMin, Prand([0.2, 0.5, 0.75, 1, 2], inf),
	\grainDurMax, Prand([0.2, 0.5, 0.75, 1, 2], inf),
	\playRateMin, Prand([0.1,0.5, 0.75, 1.0, 1.25, 1.5], inf),
	\playRateMax, Prand([0.1,0.5, 0.75, 1.0, 1.25, 1.5], inf),
	\duration, Prand([0.1,0.5,1,1.5,2,5,7,10], inf),
	\amp, Prand([0.1, 0.25, 0.5, 0.75], inf),
	\pan, Prand([0.0, -0.25, -0.5, -0.75, -1.0, 0.25, 0.5, 0.75, 1.0], inf)

).asStream;

~waitSeq = Prand([0.5, 0.25],inf).asStream;

)

(

~meRout = Routine({
	loop({
		~sendStream.(~stream1.next(()));
		~sendStream.(~stream2.next(()));
		~waitSeq.next.wait;
  })
}).play;

)

~meRout.stop;