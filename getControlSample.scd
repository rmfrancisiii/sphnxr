
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
