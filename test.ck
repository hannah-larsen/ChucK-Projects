SinOsc osc => ADSR env1 => Pan2 pan1 => dac;
SinOsc osc2 => ADSR env2 => NRev rev2 => Pan2 pan2 => dac;
env2 => Delay delay2 => dac;
delay2 => delay2;

// Params for oscs (gain/pan)
0.2 => osc.gain;
0.1 => osc2.gain;
0.8 => pan1.pan;
0.8 => pan2.pan;

// Defining what 'notes' makes a major vs minor chord, send them to a list

// Some starting positions/params
48 => int offset;       // how far out is our starting pitch
int position;           // what location our chord starts on (changes pitch)
1::second => dur beat;  // defining our 'beat' which will allow noise to output

// Params for ADSR envs
// att   decay  sus  rel
(beat/2, beat/2, 0, 1::ms) => env1.set;
(1::ms, beat/8, 0, 1::ms) => env2.set;

// Params for delay
// need to define these otherwise the chuck memory cannot
// hold onto space in memory for the delay
beat => delay2.max;
beat/4 => delay2.delay;
0.5 => delay2.gain;

// Params for reverb
0.2 => rev2.mix;

//Defining what it means to be certain chords (for use later in function)
[0,4,7,12] @=> int major[];
[0,3,7,12] @=> int minor[];
[0,3,6,12] @=> int dim[];
[0,4,8,12] @=> int aug[];

while(true){
    
    for(-1.0 => float j; j<1.0; 0.1 +=> j){
        beat / Math.random2(1,16) => env1.decayTime;
        Math.random2(0,3)*12 => position;
        Math.random2f(-1.0,1.0) => float panValue;
        1 => int note;
        Std.mtof(major[note] + offset + position) => osc.freq;
        1 => env1.keyOn;
        beat / 2 => now;

        for (0 => int j; j < 4; j++){    // This for loop gives us sound for our osc2
            Std.mtof(major[j] + offset + position - 12) => osc2.freq;   
            1 => env2.keyOn;
        }
    }
}