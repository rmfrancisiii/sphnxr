OSCdef.newMatching(\synthMsg,
	{|msg, time, addr, recvPort |
		msg = Dictionary.newFrom(msg.drop(1));
		Synth.head(~synthGroup, msg[\instrument], msg.getPairs);
		// ("SYNTH message received from"+addr).postln;

}, "/synthMsg"); // path matching


OSCdef.newMatching(\testMsg,
	{|msg, time, addr, recvPort |
		"TEST message received from /".post;
		(~addrBook.peers.detect({ arg item, i; (item.addr==addr) })).name.postln;

		addr.sendMsg("/testReply");
		//return message "connected!"
}, "/testMsg"); // path matching

OSCdef.newMatching(\testReply,
	{|msg, time, addr, recvPort |
		"Successful TEST reply message received from /".post;
		(~addrBook.peers.detect({ arg item, i; (item.addr==addr) })).name.postln;
		~addrBook.includesAddr(addr).postln;
}, "/testReply"); // path matching


//respond with list of effects busses
OSCdef.newMatching(\busListMsg,
	{|msg, time, addr, recvPort |
		("BUS message received from"+addr).postln;
}, "/busListMsg"); // path matching

