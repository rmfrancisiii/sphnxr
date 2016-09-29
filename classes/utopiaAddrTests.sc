+ AddrBook {
    testAudio {|peer|
		this.send(peer, "/testAudio", 50, 60 )
    }

	testAllAudio {
		this.peers.do({arg item, i; this.send(item.name, "/testAudio", 50+(2*i), 60+(3*i) )});
    }

	testMsg{|peer|
		("  Test Message sent to \\"+peer).postln;
		this.send(peer, "/testMsg")
	}

	testAllMsg {
		"Testing peers".postln;
		this.peers.do({arg item, i;
			this.testMsg(item.name)})
	}

	findname{|addr|
		^(this.peers.detect({arg item, i; (item.addr==addr)})).name;
	}

}