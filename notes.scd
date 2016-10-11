// dev notes

// After that, set up PStream.send  to use that Peer.EffectList bus information so that
// instead of: Pdefn(\Peer, 6, inf);
// it's: Pdefn(\Peer, \reverb, inf)
//
// After that, need to set up a way to use SynthDescLib to get control values from remote machines.
//
// * LIES:  oh, and currently you can change those control values locally with:
//          ~me.effectSet(\distortion, \postGain, 0.12);
//
//          or on a remote peer with:
//          ~addrBook.send(\river, "/effectSet", \distortion, \postGain, 0.12);



// *** other notes for later:
// Dump Node Tree with Controls in the SC Language menu
/// ***get a list of available synths and/or controls

SynthDescLib.global.read;
SynthDescLib.global.browse;
SynthDescLib.global.at(\ixibass);
SynthDescLib.global.at(\freeverb);


f = { |synth|
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
}
)


a = Synth(\default);


x = f.(a)

-> ( 'out': 0, 'gate': 1, 'freq': 440, 'amp': 0.10000000149012,
   'pan': 0 )


a.set(\freq, 300);

y = g.(a)

-> ()

// empty as asynchronous, eval y, got it meanwhile

y

-> ( 'out': 0, 'gate': 1, 'freq': 300, 'amp': 0.10000000149012,
   'pan': 0 )


a.release;



