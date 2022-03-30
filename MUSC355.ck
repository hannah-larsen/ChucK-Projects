/* 

MAIN FILE FOR MUSC 355 COMPOSITION

CURRENT PROGRESS:
- Created basic chords using frequencies and midi notes
- Optimized runtime by creating loops to run our musical output
- Experiemented with adding multiple oscillators
- Added reverb and delay

NEXT UP:
- Implement randomization
    - randomize gaps in noise (lack of osc)
    - randomize chords based off a preset bank of chords
- Implement another osc of a different type
    - maybe randomize types of oscs
- Implement back track (ambient sounds) that could be triggered

- PROBABILISTIC PLAYING OF SOUNDS (chain something ??? ask colin)
 */


/*  This is where we define all the things for use later on in the program */

// Defining our oscillators
SinOsc osc => ADSR env1 => Pan2 pan1 => dac;
SinOsc osc2 => ADSR env2 => NRev rev2 => Pan2 pan2 => dac;
env2 => Delay delay2 => dac;
delay2 => delay2;

// Params for oscs
0.2 => osc.gain;
0.1 => osc2.gain;

0.8 => pan1.pan;
0.8 => pan2.pan;

// Defining what 'notes' makes a major vs minor chord, send them to a list
[0,4,7,12] @=> int major[];
[0,3,7,12] @=> int minor[];

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



/* This is where we program the actual sound patterns */

// Creating a function that will play a chord and background osc
// given a position for the chord to start on and a chord type (maj/min)
fun void playTwoBars(int position, int chord[])
{
   for (0 => int i; i < 4; i++) // This repeats 4 times, 1 time for each note in the chord. Gives us sound for osc1
    {
        Std.mtof(chord[0] + offset + position) => osc.freq;
        1 => env1.keyOn;    // This allows us to hear the env1 ASDR
        for (0 => int j; j < 4; j++)    // This for loop gives us sound for our osc2
        {
            Std.mtof(chord[j] + offset + position + 12) => osc2.freq;   // Moving it up by 12 because thats 1 octave to sound diff
            1 => env2.keyOn;
            beat / 8 => now;
        }
    } 
}

// This loop calls the different chords to be played and the user
// can change the starting freq position/chord type in the params
for (1 => int x; x > 0; x--)
{
    playTwoBars(0, minor);
    playTwoBars(-4, major);
    playTwoBars(-2, major);
    playTwoBars(5, minor);

    playTwoBars(0, minor);
    playTwoBars(3, major);
    playTwoBars(5, minor);
    playTwoBars(-1, major);
}