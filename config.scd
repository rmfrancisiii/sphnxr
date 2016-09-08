"loading config.scd...".postln;
Server.default = s = Server.local;
// thisThread.randSeed_(120);
s.options.maxNodes_(4096);
s.options.memSize_(32768);
s.options.device="JackRouter";
s.options.outDevice = "JackRouter";
s.options.inDevice = "JackRouter";
"loaded".postln;

