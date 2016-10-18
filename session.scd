("~/git/sphnxr/init.scd").loadPaths;
//session file

("~/Documents/SuperCollider Files/SCMC Files/sphnxr-master/sphnxr/init.scd").loadPaths;



(
Pdefn(\target, \nadsac,  inf);
Pdefn(\sinsawTarget, \nadsac,  inf);
Pdefn(\sinsawOutBus, 0, inf);
Pdefn(\instrument, \saw, inf);
Pdefn(\sinsawInstrument, \sin, inf);
//Pdefn(\sinsawFreq, Pshuf([22, 23, 24, 25, 26].midicps, inf));
Pdefn(\sinsawFreq, Pshuf([44, 46, 48, 48, 50, 52].midicps, inf));
//Pdefn(\sinsawDuration, Pshuf([4, 2, 1, 3, 6], inf));
Pdefn(\sinsawDuration, Pshuf([0.5, 0.5, 0.25, 0.5, 0.25], inf));
Pdefn(\sinsawAmp, Pseq([0.015], inf));
Pdefn(\sinsawAmp, Pseq([0.25], inf));
Pdefn(\sinsawPan, Pseq([0.0, -0.25, -0.5, -0.75, -1.0, 0.25, 0.5, 0.75, 1.0], inf));
Pdefn(\sinsawAtt, Pseq([0.001], inf));
Pdefn(\sinsawMod1, 5, inf);
Pdefn(\sinsawMod2, 10, inf);
Pdefn(\sinsawAtt, Pseq([0.01], inf));
Pdefn(\sinsawMod1, Prand([2, 20, 0.1, 32], inf));
//Pdefn(\sinsawMod1, 2, inf);
//Pdefn(\sinsawMod1, 5, inf);
	Pdefn(\sinsawMod2, Prand([0.5, 12, 10, 50], inf));
//Pdefn(\sinsawMod2, 4, inf);
//Pdefn(\sinsawMod2, 10, inf);
Pdefn(\sinsawWait, Pshuf([0.125, 0.125, 0.25, 0.25, 0.5, 0.25], inf));

) 
)


(
Pdefn(\sinsawTarget, \nadsac,  inf);
Pdefn(\sinsawOutBus, 0, inf);
Pdefn(\sinsawInstrument, \sin, inf);
Pdefn(\sinsawFreq, Pshuf([112, 113].midicps, inf));
//Pdefn(\sinsawFreq, Pshuf([68, 69].midicps, inf));
//Pdefn(\sinsawFreq, Pshuf([44, 46, 48, 48, 50, 52].midicps, inf));
//Pdefn(\sinsawDuration, Pshuf([4, 2, 1, 3, 6], inf));
//Pdefn(\sinsawDuration, Pshuf([0.5, 0.5, 0.25, 0.5, 0.25], inf));
Pdefn(\sinsawDuration, Pn([0.05], inf));
//Pdefn(\sinsawDuration, Pshuf([0.05, 0.1, 0.075], inf));
Pdefn(\sinsawAmp, Pseq([0.25], inf));
Pdefn(\sinsawPan, Pseq([0.0, -0.25, -0.5, -0.75, -1.0, 0.25, 0.5, 0.75, 1.0], inf));
Pdefn(\sinsawAtt, Pseq([0.01], inf));
Pdefn(\sinsawMod1, Prand([2, 20, 0.1, -21], inf));
//Pdefn(\sinsawMod1, 2, inf);
//Pdefn(\sinsawMod1, 5, inf);
	Pdefn(\sinsawMod2, Prand([0.5, 1.2, 10, -12], inf));
//Pdefn(\sinsawMod2, 4, inf);
//Pdefn(\sinsawMod2, 10, inf);
Pdefn(\sinsawWait, Pshuf([0.125, 0.125, 0.25, 0.25, 0.5, 0.25], inf));

)
