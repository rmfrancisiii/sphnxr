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
		~addrBook.me.effectList.addEffect(msg[1].asSymbol, msg[2]);
}, "/addEffect"); // path matching


//request to set effect bus
OSCdef.newMatching(\effectSet,
	{|msg, time, addr, recvPort |
		~addrBook.me.effectSet(msg[1].asSymbol, msg[2], msg[3]);
}, "/effectSet"); // path matching

// **** not set up yet
//request to GET effect bus control values
OSCdef.newMatching(\effectGet,
	{|msg, time, addr, recvPort |
//		~addrBook.me.effectSet(msg[1].asSymbol, msg[2], msg[3]);
}, "/effectGet"); // path matching

//request to free an effect bus
OSCdef.newMatching(\effectFree,
	{|msg, time, addr, recvPort |
		~addrBook.me.effectFree(msg[1].asSymbol, msg[2]);
}, "/effectFree"); // path matching


//request for list of effects busses

// change from \listEffects to \effectUpdate
OSCdef.newMatching(\effectUpdate,   //\busListMsg,
	{|msg, time, addr, recvPort |
		var reply=List.new;
		~addrBook.me.effectList.dict.keysValuesDo({|key, value|
			reply.add(key);
			reply.add(value[0].index);
		});
		addr.sendMsg("/busReply", *reply);
}, "/effectUpdate"); //"/busListMsg"); // path matching

//display response containing list of effects busses

// *** instead of displaying, use this to repopulate Peer.effectList
//     with index (not bus)
// *** ONLY if its not peers.me
//

OSCdef.newMatching(\effectUpdateReply,
	{|msg, time, addr, recvPort |
		"Bus list for \\".post;
		//(~addrBook.findname(addr)).postln;
		//msg = Dictionary.newFrom(msg.drop(1)).postln
		(~addrBook.findname(addr)).effectList=Dictionary.newFrom(msg.drop(1))
}, "/effectUpdateReply"); // path matching
