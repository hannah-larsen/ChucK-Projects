/*
This is the file for creating a generative piece using ChucK for
MUSC 455 2022-23

Created by: Hannah Larsen
Inspired by: Clint Hoagland


Progress:
have function working right now that plays chords based on their types and starting values
have 2 oscs working atm:
    - first one is the melody - plays the arpeggiated notes based on chord type
    - second one acts as the background (more echoey and distant)

Goals:
want to have some sort of live aspect, whether this be directly coding the params in the terminal or pre-setting what i want it to transition to

the playTypeChord function takes the chord type and position as params
but i want to eventually add more params like adjusting the gain/pan/rev/etc... and passing these values into the function
    - could try overloading function and have multiple instances where not all params are necessary to input and some values could just be
    defualted if not specified otherwise

maybe include some sort of ambient backtrack that could change based on diff triggers in randomized sequences (?)

*USE MINIAUDICLE FOR LIVE CODING - DO BASE PRPGRAMMING IN VSCODE AND TRANSFER STUFF**

*/

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

// Function takes in position (starting freq) and type of chord and plays both oscillators
// first osc is like an arpeggio (acts as the melody)
// second osc is a background echo-y osc that adds depth & is slightly delayed
fun void playTypeChord (int position, int chord[]){
    for (0 => int i; i < 4; i++){
        Std.mtof(chord[0] + offset + position) => osc.freq;
        1 => env1.keyOn;    // This allows us to hear the env1 ASDR
        beat / 2 => now;

        for (0 => int j; j < 4; j++)    // This for loop gives us sound for our osc2
        {
            Std.mtof(chord[j] + offset + position) => osc2.freq;   // Moving it up by 12 because thats 1 octave to sound diff
            1 => env2.keyOn;
        }
    }
}

// could do live coding with these?
// ignore this and figure out sequence of shreds i want in miniaudicle and call accordingly ****
playTypeChord(1, major);
playTypeChord(2, major);
playTypeChord(1, major);
playTypeChord(-5, major);