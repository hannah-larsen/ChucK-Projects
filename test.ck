/*
This program is going to be what gets inserted into the MiniAudicle
and gets played live. In this program, there are initialized parameters that
define the starting state of the oscillators and their features.

Further down, there are various methods with new preset values that the program 
will switch to and assume the new parameters to change the aural components of the piece.

This program was created by Hannah Larsen
Inspired by Clint Hoagland 



TO DO:
- figure out some sort of melodic stuff so that it doesnt sound as bad: play around in reaper with
basic synth and find a sound pattern to duplicate
- add another osc that can be muted and unmuted as needed
- add audio file for a beat (simple snare or something idk)
- either get a clock working or be ready to add shreds perfectly on queue
- backtrack (ambient audio) that matches vibe of piece
*/

SinOsc osc => ADSR env1 => Pan2 pan1 => dac;
SinOsc osc2 => ADSR env2 => NRev rev2 => Pan2 pan2 => dac;
env2 => Delay delay2 => dac;
delay2 => delay2;

// Params for oscs (gain/pan)
0.2 => osc.gain;
0.15 => osc2.gain;
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
(100::ms, beat/4, 0.5, 10::ms) => env2.set;

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

// variable for randomly picking next shred
0 => int choice;
0 => int chord;
2 => int speed; // how fast the notes are played

while(true){
    // this for loop is responsible for the 'melody' of the piece (the louder more prominent notes)
    for (0 => int h; h < 16; h++){
        

        for(0 => int i; i < 4; i++){

            major[i] => chord;

            // want to have chords
            Std.mtof(chord + offset + 12) => osc.freq;
            1 => env1.keyOn;
            beat / speed => now;
            beat / speed => now;

            // this for loop creates the 'background' loop that is softer in dynamics and texture
            for (0 => int j; j < 16; j++){    // This for loop gives us sound for our osc2
                Std.mtof(chord + offset + position - 12) => osc2.freq;   
                1 => env2.keyOn;
            }

        }
    }
}