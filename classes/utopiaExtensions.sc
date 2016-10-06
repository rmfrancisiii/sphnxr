+ Peer {

	//effect handlers:
	// . Add Effect
	//    . take defaults for args
	//    . set different output bus
	// . Update List on local machine
	// . output list
	// . return bus.index
	// . delete effect
	// . get control value
	// . set control value

	addEffect {|key, effect|
		//this.effectList.addEffect(key, effect)
		this.sendMsg("/addEffect", key, effect)
	}

	listEffects {
		// this is the local copy
		^this.effectList.list
	}

	effectUpdate{
		// this requests an update for the local copy,
		// for the receiver, see \effectUpdateReply in oscDefs
		this.sendMsg("/effectUpdate");
		"sending update request".postln;
	}

	effectNames { ^this.effectList.names }

	effectBusIndex {|key| ^this.effectList.busIndex(key)}

	effectBus {|key| ^this.effectList.bus(key)}

	effectFree {|key| ^this.effectList.effectFree(key)}

	effectSet {|key, control, value| this.effectList.effectSet(key, control, value)}

	//NOT done
	// effectGet {|key, control, value| this.effectList.effectGet();}

}

+ AddrBook {
    testAudio {|peer|
		this.send(peer, "/testAudio", 50, 60 )
    }

	testAllAudio {
		"Testing peers audio:".postln;
		this.peers.do({arg item, i; this.send(item.name, "/testAudio", 50+(2*i), 60+(3*i) )});
    }

	testMsg{|peer|
		("  Test Message sent to \\"+peer).postln;
		this.send(peer, "/testMsg")
	}

	testAllMsg {
		"Testing peers messaging:".postln;
		this.peers.do({arg item, i;
			this.testMsg(item.name)})
	}

	findname{|addr|
		^(this.peers.detect({arg item, i; (item.addr==addr)})).name;
	}

}