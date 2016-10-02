EffectList {
	var <dict, <me;

	*new { ^super.new.init }

	init { dict = Dictionary.newFrom(List[
		\masterOut, List[Server.local.outputBus]])}

	printOn {
		this.dict.keysValuesDo{|key, value|
			(key++":   ").post;
			value[0].index.postln;}
	}


	//	printOn { |stream|
		//	stream << this.class.name << "(" <<* [name, addr, online, effectList.list] << ")"
	//	}

	list { ^dict.getPairs }

	names { ^dict.keys }

	busIndex {|key|
		this.dict.atFail(key.asSymbol, {"effect not found".postln; ^nil});
		^((this.dict[key.asSymbol]).at(0)).index
	}


	addEffect {|key, effect|
		var newBus = Bus.audio(Server.local,2);
		var newSynth = Synth.head(~effectGroup, effect.asSymbol, [\outBus, this.busIndex("masterOut"), \inBus, newBus]);
		dict.add(key.asSymbol -> List[newBus, newSynth])
	}

	free {|key|
		this.dict.atFail(key.asSymbol, {"effect not found".postln; ^nil});
		if (key==\masterOut, {"cannot free masterOut".postln; ^nil});
		this.dict[key.asSymbol].at(1).free;
		this.dict.removeAt(key.asSymbol);
		(key + "Effect removed").postln;
	}

	set {|key, control, value|
		this.dict.atFail(key.asSymbol, {"effect not found".postln; ^nil});
		this.dict[key.asSymbol].at(1).set(control.asSymbol, value);
	}

}