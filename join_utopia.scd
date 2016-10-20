<<<<<<< HEAD
"loading join_utopia.scd...".post;
"loading join_utopia.scd...".postln;
=======
>>>>>>> wtkns/master

//set up display of network peers

<<<<<<< HEAD
	~addrBook = AddrBook.new;
	// to get updates, just add a dependant
	~addrBook.addDependant({|addrBook, what, who|
		{~listView.items = addrBook.peers.collectAs({|peer|
			peer.name ++ " | " ++ peer.addr.ip ++ " | " ++ if(peer.online, "online", "offline");
		}, Array)}.defer;
	});
~win.layout = VLayout.new.add(~listView = ListView.new);

	~addrBook.addMe("hostname".unixCmdGetStdOut.split($.)[0];); // add this machine
	~hail = Hail(~addrBook);
~addrBook = AddrBook.new;
// to get updates, just add a dependant
~addrBook.addDependant({|addrBook, what, who|
	{~listView.items = addrBook.peers.collectAs({|peer|
		peer.name ++ " | " ++ peer.addr.ip ++ " | " ++ if(peer.online, "online", "offline");
	}, Array)}.defer;
});

"creating address book".postln;

~addrBook.addMe(~hostname); // add this machine
~hail = Hail(~addrBook);

"loaded".postln;
=======
// ~win.layout = VLayout.new.add(~listView = ListView.new);
//
 ~addrBook = AddrBook.new;
// // to get updates, just add a dependant
// ~addrBook.addDependant({|addrBook, what, who|
// 	{~listView.items = addrBook.peers.collectAs({|peer|
// 		peer.name ++ " | " ++ peer.addr.ip ++ " | " ++ if(peer.online, "online", "offline");
// 	}, Array)}.defer;
// });

"creating address book".postln;
~addrBook.addMe(~hostname); // add this machine
~hail = Hail(~addrBook);
~me=~addrBook.me;


>>>>>>> wtkns/master
