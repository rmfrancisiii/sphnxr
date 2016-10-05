EffectList {
	var <dict, <me;

	*new { ^super.new.init }

	init {

		// if its the local machine, ie AddrBook.me
		dict = Dictionary.newFrom(List[
		\masterOut, List[Server.local.outputBus]])

		// if its on a remote Peer
		// it should be different


	}

	printOn {|stream|
		this.dict.keysValuesDo{|key, value|
			stream << key <<":   " << value[0].index << "\n"}
	}

	list { ^dict.getPairs }

	names { ^dict.keys }

	bus {|key|
		this.dict.atFail(key.asSymbol, {"effect not found".postln; ^nil});
		^(this.dict[key.asSymbol]).at(0);
	}

	busIndex {|key|
		this.dict.atFail(key.asSymbol, {"effect not found".postln; ^nil});
		^((this.dict[key.asSymbol]).at(0)).index
	}


	addEffect {|key, effect|
		var newBus = Bus.audio(Server.local,2);
		var newSynth = Synth.head(~effectGroup, effect.asSymbol, [\outBus, this.busIndex("masterOut"), \inBus, newBus]);
		dict.add(key.asSymbol -> List[newBus, newSynth])
	}

	effectFree {|key|
		this.dict.atFail(key.asSymbol, {"effect not found".postln; ^nil});
		if (key==\masterOut, {"cannot free masterOut".postln; ^nil});
		this.dict[key.asSymbol].at(1).free;
		this.dict.removeAt(key.asSymbol);
		(key + "Effect removed").postln;
	}

	effectSet {|key, control, value|
		this.dict.atFail(key.asSymbol, {"effect not found".postln; ^nil});
		this.dict[key.asSymbol].at(1).set(control.asSymbol, value);
	}

	// get effect control values
	effectGet { |key|

		/// NOT done:
		/*	f = { |synth|
			var x = (), d = SynthDescLib.global[synth.defName.asSymbol];
			d.notNil.if { d.controls.do { |c| x.put(c.name, c.defaultValue) } };
			x
		};

		// asynchronous !

		g = { |synth|
			var x = (), d = SynthDescLib.global[synth.defName.asSymbol];
			d.notNil.if { d.controls.do { |c|  synth.get(c.name,  { |y|
				x.put(c.name, y) }) } };
			x
		}*/


	}
}