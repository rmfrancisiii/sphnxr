OSCdef.newMatching(\synthMsg,
	{|msg, time, addr, recvPort |
		msg = Dictionary.newFrom(msg.drop(1));
		Synth.head(~synthGroup, msg[\instrument], msg.getPairs);
}, "/synthMsg"); // path matching


OSCdef.newMatching(\testMsg,
	{|msg, time, addr, recvPort |
		addr.sendMsg("/testReply");

}, "/testMsg"); // path matching

OSCdef.newMatching(\testReply,
	{|msg, time, addr, recvPort |
		"Successful messaging test reply received from \\".post;
		(~addrBook.findname(addr)).postln;
}, "/testReply"); // path matching

//audio test
OSCdef.newMatching(\testAudio,
	{|msg, time, addr, recvPort |
		(~addrBook.findname(addr)).postln;
		~testTone = Synth.head(~synthGroup, \saw,
			[\freq, msg.at(1).midicps, \pan, -1, \dur, 5.0, \outBus, ~masterOut]);
		~testTone = Synth.head(~synthGroup, \saw,
			[\freq, msg.at(2).midicps, \pan, 1, \dur, 5.0, \outBus, ~masterOut]);
}, "/testAudio"); // path matching

//request for new effects bus
OSCdef.newMatching(\addEffect,
	{|msg, time, addr, recvPort |

		~effectList.addEffect(msg[1].asSymbol, msg[2]);


		//var reply=List.new;
		//~effectList.dict.keysValuesDo({|key, value|
		//	reply.add(key);
		//	reply.add(value[0].index);
		//});
		//addr.sendMsg("/busReply", *reply);
}, "/addEffect"); // path matching


//request for list of effects busses
OSCdef.newMatching(\busListMsg,
	{|msg, time, addr, recvPort |
		var reply=List.new;
		~effectList.dict.keysValuesDo({|key, value|
			reply.add(key);
			reply.add(value[0].index);
		});
		addr.sendMsg("/busReply", *reply);
}, "/busListMsg"); // path matching

//display response containing list of effects busses
OSCdef.newMatching(\busReply,
	{|msg, time, addr, recvPort |
		"Bus list for \\".post;
		(~addrBook.findname(addr)).postln;
		msg = Dictionary.newFrom(msg.drop(1)).postln
}, "/busReply"); // path matching
