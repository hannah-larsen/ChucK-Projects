/* Experimenting with panning and randomization in ChucK */
<<< "Panning and Randomization" >>>;

// Initializing the osc
TriOsc osc => ADSR env1 => Pan2 pan => dac;

// Initializing pan value
-1.0 => pan.pan;

// Setting params for osc things
0.25::second => dur beat;
(1::ms, beat/8, 0, 1::ms) => env1.set;
0.25 => osc.gain;

// Defining what constitutes major v minor chord
[0,4,7] @=> int major[];
[0,3,7] @=> int minor[];

60 => int offset;
int position;

// Playing the music by repitition
for(0 => int i; i < 1; i++)
{
    for(-1.0 => float j; j < 1.0; 0.1 +=> j)
    {
        Math.random2f(-1.0, 1.0) => float panValue; // Choosing a random value between [-0.1 and 1.0)
        Math.random2(0, 3) * 12 => position;    // Choosing random note values to output
        Math.random2(0, minor.cap() -1) => int note;    // Sending randomnote values to std.mtof
        panValue => pan.pan;    // The random value achieved at line above distates where sound is panned
        <<<"Pan value:", panValue >>>;  // Printing out pan values to see what value is being picked each time
        Std.mtof(minor[note] + offset + position) => osc.freq; // Creating the chord notes based off chord type/offset/position
        1 => env1.keyOn;    // Sending the sound to ADSR env
        beat /2 => now;    // Playing (outputting) the sound
    }
}
