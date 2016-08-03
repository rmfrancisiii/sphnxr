// extension of stream for purposes of sending over network

PStream {
    var <>bind, <>interval, <>addrBook, <>clock, <>quant, <>routine;

    *new {|bind, interval, addrBook, clock, quant|
        ^super.newCopyArgs(bind, interval, addrBook, clock, quant);
    }

    send {|msg|
        var target, path, sndMsg;
		target = (addrBook.at(msg.removeAt(\target))).addr;
        path = msg.removeAt(\oscpath);
        sndMsg = msg.getPairs;
        target.sendMsg(path, *sndMsg);
    }

    stop { routine.stop;}

    play{
		var bindStream = bind.asStream;
		var intervalStream = interval.asStream;
        routine = {
            loop({
                this.send(bindStream.next(()));
				intervalStream.next(()).wait
            })
        }.fork(clock, quant: quant)
    }
}