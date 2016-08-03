(
s.boot;

m = MultiLevelIdentityDictionary.new;
m.putTree(\peers,[
	\james,[
		\addr, NetAddr("127.0.0.1", NetAddr.langPort),
		\synth1,[
			\name, \SimpleSine,
			\status, true,
			\synthDef, SynthDef(\sin, {
				|freq=1000, dur=10, amp=0.5, pan=0, att=0.5, mod1=1, mod2=1|
				var env = Env([0.001, 0.99, 0.001], [att, 1.0-att], [\sin, \sin]);
				var envGen = EnvGen.kr(env, doneAction: 2, timeScale: dur);
				var sin = SinOsc.ar([freq, freq*4/3, freq*5/4], SinOsc.ar(XLine.kr(mod1, mod2, dur), 0, 2pi), amp);
				Out.ar(0, Pan2.ar(sin * envGen, pan));
			}).add,
			\parameters, [
				\freq, [
					\description, 'in herz, between 10 and 10,000',
					\min, 10,
					\max, 10000,
					\default, 440
				],
				\amp, [
					\description, 'between 0 and 1',
					\min, 0,
					\max, 1,
					\default, 0.25
				],
				\pan, [
					\description, 'between -1 and 1',
					\min, -1,
					\max, 1,
					\default, 0
				],
				\dur, [
					\description, 'in seconds',
					\min, -1,
					\max, 1,
					\default, 0
				],
				\att, [
					\description, 'between -1 and 1',
					\min, -1,
					\max, 1,
					\default, 0
				],
				\mod1, [
					\description, 'between -1 and 1',
					\min, -1,
					\max, 1,
					\default, 0
				],
				\mod2, [
					\description, 'between -1 and 1',
					\min, -1,
					\max, 1,
					\default, 0
				]
			]
		],
		\synth2,[
			\name, \SimpleSaw,
			\status, true,
			\synthDef, SynthDef(\SimpleSaw, {
				|freq = 440|
				Out.ar(0, Saw.ar(freq, 0.2))
			}).add,
			\parameters, [
				\freq, 'in herz, between 10 and 10,000',
				\amp, 'between 0 and 1',
				\pan, 'between -1 and 1'
			]
		]
	],

	\robert,[
		\addr, NetAddr("192.168.0.1", NetAddr.langPort),
		\synth1,[
			\name, \SimpleSine,
			\status, true,
			\synthDef, SynthDef(\SimpleSine, {
				|freq = 440|
				Out.ar(0, SinOsc.ar(freq, 0, 0.2))
			}).add,
			\parameters, [
				\freq, 'in herz, between 10 and 10,000',
				\amp, 'between 0 and 1',
				\pan, 'between -1 and 1'
			]
		],
		\synth2,[
			\name, \SimpleSaw,
			\status, true,
			\synthDef, SynthDef(\SimpleSaw, {
				|freq = 440|
				Out.ar(0, Saw.ar(freq, 0.2))
			}).add,
			\parameters, [
				\freq, 'in herz, between 10 and 10,000',
				\amp, 'between 0 and 1',
				\pan, 'between -1 and 1'
			]
		]
	]
]);
m.postTree;
)

Synth(\SimpleSaw);

Synth(\SimpleSine, [\freq, 660]);