OSCdef.newMatching(\synthMsg,
	{|msg, time, addr, recvPort |
		msg = Dictionary.newFrom(msg.drop(1));
		Synth.head(~synthGroup, msg[\instrument], msg.getPairs);
}, "/synthMsg"); // path matching


OSCdef.newMatching(\testMsg,
	{|msg, time, addr, recvPort |
		"TEST message received from /".post;
		(~addrBook.peers.detect({
			arg item, i; (item.addr==addr)})).name.post;
		"  ...replying.".postln;
		addr.sendMsg("/testReply");
}, "/testMsg"); // path matching

OSCdef.newMatching(\testReply,
	{|msg, time, addr, recvPort |
		"Successful TEST reply message received from /".post;
		(~addrBook.peers.detect({
			arg item, i; (item.addr==addr)})).name.postln;
}, "/testReply"); // path matching

//audio test
OSCdef.newMatching(\testAudio,
	{|msg, time, addr, recvPort |
		"Audio Test message received from/".post;
		(~addrBook.peers.detect({
			arg item, i; (item.addr==addr)})).name.postln;
		msg.postln;
		~testTone = Synth.head(~synthGroup, \saw, [\freq, msg.at(1).midicps, \pan, -1, \dur, 5.0, \outBus, ~masterOut]);

		~testTone = Synth.head(~synthGroup, \saw, [\freq, msg.at(2).midicps, \pan, 1, \dur, 5.0, \outBus, ~masterOut]);

}, "/testAudio"); // path matching



//respond with list of effects busses
OSCdef.newMatching(\busListMsg,
	{|msg, time, addr, recvPort |
		("BUS message received from"+addr).postln;
}, "/busListMsg"); // path matching

