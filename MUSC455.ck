/*
This is the file for creating a generative piece using ChucK for
MUSC 455 2022-23

Created by: Hannah Larsen
Inspired by: Clint Hoagland

Ideas:
- create different types of chords as list values
- play chords solid/arpeggiated at random
- have background ambient sounds randomly triggered by different events (have multiple sounds to pick)
- play around with volume

-> this piece should be generative which means it will keep going until the user prompts its end position.
   try and make the number seeding random this time

*/

// Defining oscillators and their paths
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
[0,4,7,12] @=> int major[];
[0,3,7,12] @=> int minor[];
[0,3,6,12] @=> int dim[];
[0,4,8,12] @=> int aug[];

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

fun void playTypeChord (int position, int chord[]){
    for (0 => int i; i < 4; i++){
        Std.mtof(chord[0] + offset + position) => osc.freq;
        1 => env1.keyOn;    // This allows us to hear the env1 ASDR
        beat / 2 => now;
    }
}