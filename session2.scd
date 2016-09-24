//session file

("~/git/sphnxr/init.scd").loadPaths;


(
Pdefn(\sinsawTarget, \rose,  inf);
Pdefn(\sinsawOutBus, 0, inf);
Pdefn(\sinsawInstrument, \saw, inf);
Pdefn(\sinsawFreq, Pshuf([44, 46, 48, 48, 50, 52].midicps, inf));
Pdefn(\sinsawDuration, Pshuf([1.5, 20.5, 100.25, 10.5, 5.25], inf));
Pdefn(\sinsawAmp, Pseq([0.25], inf));
Pdefn(\sinsawPan, Pseq([0,1,-1,0.5,-0.5], inf));
Pdefn(\sinsawAtt, Pseq([0.9], inf));
Pdefn(\sinsawMod1, 0, inf);
Pdefn(\sinsawMod2, 1, inf);
Pdefn(\sinsawWait, Pshuf([0.125, 0.125, 0.25, 0.25, 0.5, 0.25], inf));
)

~sinRhythm.play;

(
Pdefn(\sinsawFreq, Pshuf([40, 42, 44, 44, 48, 50].midicps, inf));
Pdefn(\sinsawDuration, Pshuf([0.5, 0.5, 0.25, 0.5, 0.25], inf));
Pdefn(\sinsawWait, Pseq([0.15, 0.25, 1.25, 10.25, 5, 1.25], inf));
)

(
Pdefn(\sinsawFreq, Pshuf([4, 4, 6, 4, 8, 10, 6, 5, 4, 6].midicps, inf));
Pdefn(\sinsawDuration, Prand([0.5, 0.5, 0.25, 0.5, 0.25], inf));
Pdefn(\sinsawWait, Prand([5], inf));
)

~sinRhythm.stop;


