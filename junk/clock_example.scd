(
~win = Window("AdHocSociety").front;
~win.layout = VLayout.new.add(~listView = ListView.new);

~addrBook = AddrBook.new;
// to get updates, just add a dependant
~addrBook.addDependant({|addrBook, what, who|
    {~listView.items = addrBook.peers.collectAs({|peer|
        peer.name ++ " | " ++ peer.addr.ip ++ " | " ++ if(peer.online,
"online", "offline");
    }, Array)}.defer;
});

~addrBook.addMe; // will automatically add you using your user name
//~addrBook.addMe(\adcxyz); // or specify one

~hail = Hail(~addrBook);

)

s.boot

~clock = BeaconClock(~addrBook).permanent_(true);
// this use a default name (osc path) for this clock, so it will be the same clock
// for each participant


// test with a click
(
SynthDef(\click, {
    var click;
    click = Impulse.ar(0);
    DetectSilence.ar(click,doneAction:2);
    OffsetOut.ar(0, click * 0.5);
}).add;
)

Pbind(\instrument, \click, \freq, Pfunc({"beats: % tempo:
%\n".postf(~clock.beats, ~clock.tempo); rrand(440,880, 1200)
})).play(~clock, quant: 1);


// set as default clock to not have to write ~clock for each pattern

TempoClock.default = ~clock

Pbind(\instrument, \click, \freq, Pfunc({"beats: % tempo:
%\n".postf(~clock.beats, ~clock.tempo); rrand(440, 1200)
})).play(quant: 1);