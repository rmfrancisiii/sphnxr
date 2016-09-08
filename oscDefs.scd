"loading oscDefs.scd...".post;
OSCdef.newMatching(\synthMsg,
		{|msg, time, addr, recvPort |
			msg = Dictionary.newFrom(msg.drop(1));
			Synth.head(~synthGroup, msg[\instrument], msg.getPairs);
			// "message received".postln;
	}, "/synthMsg"); // path matching
"loaded".postln;
