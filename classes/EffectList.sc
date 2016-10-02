EffectList {
	var <dict, <me;

	*new { ^super.new.init }

	init { dict = Dictionary.newFrom(List[
		\masterOut, List[Server.local.outputBus]])}

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

}