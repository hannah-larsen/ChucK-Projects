SinOsc osc => ASDR env1 => NRev rev => Pan2 pan => dac;

0.05 => rev.mix;
-1.0 => pan.pan;
0.5::second => dur beat;
beat - (now % beat) => now;
(1::ms, beat/8, 0, 1::ms) = env1.set;
0.1 => osc.gain;

//Defining what it means to be certain chords (for use later in function)
[0,4,7,12] @=> int major[];
[0,3,7,12] @=> int minor[];
[0,3,6,12] @=> int dim[];
[0,4,8,12] @=> int aug[];

48 => int offset;
int position;

while(true){
    for(-1.0 => float j; j < 1.0; 0.1 +=> j){
        beat / Math.random2(1,16) => anv1.decayTime;
        Math.random2(0,3) * 12 => position;
        Math.random2f(-1.0, 1.0) => float panvalue;
        Math.random2(0,major.cap() -1) => int note;
        panValue => pan.pan;
        Std.mtof(major[note] + offset + position) => osc.freq;
        1 => env.keyOn;
        beat => now;
    }
}
