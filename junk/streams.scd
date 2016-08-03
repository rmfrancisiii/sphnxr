(

// Make this a method of something
// eg PStream.send
~sendStream = {|msg|
  var target = ~addrBook.at(msg.removeAt(\target)).addr;
  var path = msg.removeAt(\oscpath);
  var sndMsg = msg.getPairs;
  target.sendMsg(path, *sndMsg);
};
)
(
~granStream = Pbind(
	\target, Pdefn(\target, \river),
	\oscpath, "/synthMsg",
	\instrument, \gran,
	\outBus, Pdefn(\outBus, 0),
	\bufOffset, Pdefn(\bufOffset, 8),
	\bufPos, Pdefn(\bufPos, 0.5),
	\grainRate, Pdefn(\grainRate, 1.0),
	\grainDurMin, Pdefn(\grainDurMin, 0.15),
	\grainDurMax, Pdefn(\grainDurMax, 1.25),
	\playRateMin, Pdefn(\playRateMin, 1),
	\playRateMax, Pdefn(\playRateMax, 1),
	\grainDuration, Pdefn(\grainDuration, 0.5),
	\grainAmp, Pdefn(\grainAmp, 0.25),
	\grainPan, Pdefn(\grainPan, 0)
).asStream;
)

(
~granWaitSeq = Prand([0.3,0.5,1],inf).asStream;

~granRout = Routine({


	loop({
		~sendStream.(~granStream.next(()));
		~granWaitSeq.next.wait;
	})
}).play;
)




Pdefn(\outBus, Prand([0], inf))
Pdefn(\bufOffset, 0)
Pdefn(\bufOffset, Prand([0,1,2,3,4,5,6], inf))
Pdefn(\bufPos, Prand([0.1, 0.5, 0.75, 0.9], inf))
Pdefn(\grainRate, Prand([ 100, 500], inf))
Pdefn(\grainDurMin, Prand([ 1, 2, 3], inf))
Pdefn(\grainDurMax, Prand([ 1, 2, 3], inf))
Pdefn(\playRateMin, Prand([0.1,0.5, 0.75], inf))
Pdefn(\playRateMax, Prand([0.1,0.5, 0.75], inf))
Pdefn(\grainDuration, Prand([1.5, 2.0], inf))
Pdefn(\grainAmp, Prand([0.1, 0.15, 0.25], inf))
Pdefn(\grainPan, Prand([0.0, -0.25, -0.5, -0.75, -1.0, 0.25, 0.5, 0.75, 1.0], inf))



//1 increasing tempo
~granWaitSeq = Prand([0.3,0.5,1,3,4],inf).asStream
//1.b
~granWaitSeq = Prand([0.1,0.3,0.5,1,3],inf).asStream
//1.c
~granWaitSeq = Prand([0.5,0.3,0.5],inf).asStream

//1.d
~granWaitSeq = Prand([0.25,0.3],inf).asStream

Pdefn(\grainDuration, Prand([0.1, 0.2, 0.3, 0.5], inf))


//1.e
~granWaitSeq = Prand([0.15,0.1],inf).asStream

~granWaitSeq = Prand([0.1,0.05],inf).asStream

~granWaitSeq = Prand([0.01,0.05],inf).asStream;

Pdefn(\grainDuration, Prand([0.05,0.1, 0.15, 0.2], inf))
~granWaitSeq = Prand([0.01,0.005],inf).asStream;


//breaks!!

Pdefn(\grainDuration, Prand([0.05,0.1, 0.15], inf))
~granWaitSeq = Prand([0.001,0.005],inf).asStream;



~distortIn.index.postln;
~freeverbIn.index.postln;

~freeverb.set(\mix, 0.25);
~freeverb.set(\room, 0.25);
~freeverb.set(\damp, 0.25);



~granRout.stop;


~meRout.stop;