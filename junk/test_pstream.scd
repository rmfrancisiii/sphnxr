(

~win = Window("AdHocSociety").front;
~win.layout = VLayout.new.add(~listView = ListView.new);
~win.alwaysOnTop = true;

~addrBook = AddrBook.new;
// to get updates, just add a dependant
~addrBook.addDependant({|addrBook, what, who|
	{~listView.items = addrBook.peers.collectAs({|peer|
		peer.name ++ " | " ++ peer.addr.ip ++ " | " ++ if(peer.online, "online", "offline");
	}, Array)}.defer;
});

~addrBook.addMe("hostname".unixCmdGetStdOut.split($.)[0];); // add this machine
~hail = Hail(~addrBook);


)



(

~pstr = PStream(

	Pbind(
		\target, Pdefn(\target, \river),
		\oscpath, "/synthMsg",
		\instrument, \gran,
		\outBus, Pdefn(\outBus, 1),
		\bufOffset, Pdefn(\bufOffset, 8),
		\bufPos, Pdefn(\bufPos, 0.5),
		\grainRate, Pdefn(\grainRate, 1.0),
		\grainDurMin, Pdefn(\grainDurMin, 0.15),
		\grainDurMax, Pdefn(\grainDurMax, 1.25),
		\playRateMin, Pdefn(\playRateMin, 1),
		\playRateMax, Pdefn(\playRateMax, 1),
		\grainDuration, Pdefn(\grainDuration, 0.5),
		\grainAmp, Pdefn(\grainAmp, 0.25),
		\grainPan, Pdefn(\grainPan, 0)
	),
	0.5,
	~addrBook);

)
~pstr.send;

~pstr.play;
~pstr.stop;

~pstr.postln;

~pstr.routine().postln;
~pstr.addrBook();