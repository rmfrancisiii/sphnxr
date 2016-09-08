"loading join_utopia.scd...".post;

//set up display of network peers
	~win = Window("AdHocSociety").front;
	~win.layout = VLayout.new.add(~listView = ListView.new);
	//~win.alwaysOnTop = true;

	~addrBook = AddrBook.new;
	// to get updates, just add a dependant
	~addrBook.addDependant({|addrBook, what, who|
		{~listView.items = addrBook.peers.collectAs({|peer|
			peer.name ++ " | " ++ peer.addr.ip ++ " | " ++ if(peer.online, "online", "offline");
		}, Array)}.defer;
	});

	~addrBook.addMe("hostname".unixCmdGetStdOut.split($.)[0];); // add this machine
	~hail = Hail(~addrBook);

"loaded".postln;
