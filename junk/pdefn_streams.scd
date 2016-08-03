(

// Make this a method of something
// eg Stream.send
~sendStream = {|msg|
	var target = ~addrBook.at(msg.removeAt(\target)).addr;
	var path = msg.removeAt(\oscpath);
	var sndMsg = msg.getPairs;
	target.sendMsg(path, *sndMsg);
};

)

(

~granStream = Pbind(
	\target, \river,
	\oscpath, "/synthMsg",
	\instrument, \gran,
	\outBus, Pdefn(\outBus, 0),
	\bufOffset, Pdefn(\bufOffset, 3),
	\bufPos, Pdefn(\bufPos, 0.7),
	\grainRate, Pdefn(\grainRate, 100),
	\grainDurMin, Pdefn(\grainDurMin, 0.01),
	\grainDurMax, Pdefn(\grainDurMax, 0.5),
	\playRateMin, Pdefn(\playRateMin, 0.9),
	\playRateMax, Pdefn(\playRateMax, 1.1),
	\grainDuration, Pdefn(\grainDuration, 3),
	\grainAmp, Pdefn(\grainAmp, 0.25),
	\grainPan, Pdefn(\grainPan, 0)
).asStream;

)

~arrayOfBuffers.do({|i,item| i.bufnum.postln});

~arrayOfBuffers[0].postln.play;

(

~granWaitSeq = Prand([0.5],inf).asStream;

~granRout = Routine({


	loop({
		~sendStream.(~granStream.next(()));
		~granWaitSeq.next.wait;
	})
}).play;

)

Pdefn(\outBus, Prand([0], inf))
Pdefn(\outBus, Prand([4], inf))
Pdefn(\outBus, Prand([6], inf))
Pdefn(\outBus, Prand([0, 6], inf))

Pdefn(\bufOffset, Prand([0,1,2,3,4,5,6,7,8,9], inf))
Pdefn(\bufPos, Prand([0.1, 0.5, 0.75, 0.9], inf)),
Pdefn(\grainRate, Prand([1, 2, 5, 10,15, 20,25, 50, 100, 500], inf)),
Pdefn(\grainDurMin, Prand([0.2, 0.5, 0.75, 1, 2], inf)),
Pdefn(\grainDurMax, Prand([0.2, 0.5, 0.75, 1, 2], inf)),
Pdefn(\playRateMin, Prand([0.1,0.5, 0.75, 1.0, 1.25, 1.5, 2, 4, 5, 10], inf)),
Pdefn(\playRateMax, Prand([0.1,0.5, 0.75, 1.0, 1.25, 1.5, 2, 4, 5, 10], inf)),
Pdefn(\grainDuration, Prand([0.5, 1.0, 1.5, 2.0], inf)),
Pdefn(\grainAmp, Prand([0.1, 0.15, 0.25], inf)),
Pdefn(\grainPan, Prand([0.0, -0.25, -0.5, -0.75, -1.0, 0.25, 0.5, 0.75, 1.0], inf))



~granRout.stop;