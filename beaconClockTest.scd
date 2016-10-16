

("~/git/sphnxr/init.scd").loadPaths;
("~/git/sphnxr/tests.scd").loadPaths;

(
// test with a click
Pbind(\instrument, \click, \freq, Pfunc({"beats: % tempo:
%\n".postf(~clock.beats, ~clock.tempo); rrand(440, 1200)
})).play(~clock, quant: 1/32);
)

Pbind(\freq, Pfunc({"beats: % tempo: %\n".postf(~clock.beats, ~clock.tempo); rrand(440, 1200) })).play(~clock, quant: 2);


(
Pbind(\instrument, \sin, \freq, Pfunc({"beats: % tempo:
%\n".postf(~clock.beats, ~clock.tempo); rrand(440, 1200)
})).play(quant: 1/8);
)

t = TempoClock.new(2, 5);
"current beats:" + t.beats;

~clock.tempo = 5
~clock.setGlobalTempo(3, 90)
~clock.setGlobalTempo(1.25);
~clock.setGlobalTempo(1);

~clock.fadeTempo(10, 3)

~clock.warpTempo(2, 30)

Pbind(\freq, rrand(440, 880)).play(~clock, quant: 1);
