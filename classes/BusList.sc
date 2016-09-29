
BusList {
	var dict, <me;

	*new { ^super.new.init }

	init { dict = Dictionary.newFrom(List[\masterOut, Bus.audio(Server.local,2)])}


	addBus {|name|
		dict.add(name -> Bus.audio(Server.local,2));
	}

	listBusses {
		^dict;

	}

	names { ^dict.keys }

	getIndex {|key| ^dict[key].index }

}