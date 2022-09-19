/*
Generating random theory related queries as requested by user

user inputs:
- key

- scale
- chord
- arpeggio
- triad
*/


// Initializing Oscillators
SinOsc osc1 => ASDR env1 => dac;
0.2 => osc1.gain;

// Defining what 'notes' makes a major vs minor chord, send them to a list
[0,4,7,12] @=> int major[];
[0,3,7,12] @=> int minor[];

48 => int offset;       // how far out is our starting pitch
int position;           // what location our chord starts on (changes pitch)
1::second => dur beat;  // defining our 'beat' which will allow noise to output

// Params for ADSR envs
// att   decay  sus  rel
(beat/2, beat/2, 0, 1::ms) => env1.set;

//Figuring out what position the key is for melodic purposes later on
/*
if key is c maj
chord = major
position = 0 (48)



// This function plays a chord
fun void playAChord(int position, int chord[]){
    Std.mtof(chord[0] + offset + position) => osc.freq;
}
