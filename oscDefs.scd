OSCdef.newMatching(\synthMsg,
	{|msg, time, addr, recvPort |
		msg = Dictionary.newFrom(msg.drop(1));
		Synth.head(~synthGroup, msg[\instrument], msg.getPairs);
		("message received from"+addr).postln;

}, "/synthMsg"); // path matching


OSCdef.newMatching(\testMsg,
	{|msg, time, addr, recvPort |
		("message received from"+addr).postln;
		//return message "connected!"
}, "/testMsg"); // path matching


//respond with list of effects busses
OSCdef.newMatching(\busListMsg,
	{|msg, time, addr, recvPort |
		("message received from"+addr).postln;
}, "/busListMsg"); // path matching

