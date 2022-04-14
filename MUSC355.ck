/* 

MUSC 355 CHUCK COMPOSITION

CURRENT PROGRESS:
- Created basic chords using frequencies and midi notes
- Optimized runtime by creating loops to run our musical output
- Experiemented with adding multiple oscillators
- Added reverb and delay
- PROBABILISTIC PLAYING OF SOUNDS
    - Markov chain: out of 100, if a number is between 50-100 (50% chance) play sound
- RANZOMIZED BEAT CHANGES 
- randomized mutes (they dont sound good tho)

NEXT UP:

- Implement back track - ***might do this in reaper instead***

 */


/*  This is where we define all the things for use later on in the program */

// Defining our oscillators
// REMOVE "WvOut waveOut => blackhole;" after each dac output to prevent recording
SinOsc osc => ADSR env1 => Pan2 pan1 => dac => WvOut waveOut => blackhole;
SinOsc osc2 => ADSR env2 => NRev rev2 => Pan2 pan2 => dac => WvOut waveOut2 => blackhole;
env2 => Delay delay2 => dac => WvOut waveOut3 => blackhole;
delay2 => delay2;

// REMOVE these three lines in addition to above to prevent recording
"chucksong.wav" => waveOut.wavFilename;
"chucksong.wav" => waveOut2.wavFilename;
"chucksong.wav" => waveOut3.wavFilename;

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

        // Generating a random value that will determine duration of final note in 4-chord sequence
        // We will also re-use this variable for sampling probability later
        Math.random2f (1, 100) => float randNoteDur;

        for (0 => int j; j < 4; j++)    // This for loop gives us sound for our osc2
        {
            Std.mtof(chord[j] + offset + position + 12) => osc2.freq;   // Moving it up by 12 because thats 1 octave to sound diff
            1 => env2.keyOn;

            // 10% chance of generating slower note duration
            if (randNoteDur < 10){
                beat / 2 => now;
                <<<"Slow note sequence generated">>>;
                <<<"-------------------------------------">>>;

            } else {
                beat / 8 => now;
            }
        }
    } 
}




/*
MARKOV CHAIN: PROBABILITY BASED ON RAND NUMBER

RAND range: 1-100

MAJOR CHORD: 70% (between 1 - 69)
MINOR CHORD: 30% (between 70 - 100)


POSITIONS 1 - 11 covers a full octave
RAND2 range: 1 - 90

if rand > 0 && rand < 20: position 1
if rand >= 20 && rand < 30: position 2
if rand >= 30 && rand < 40: position 3
if rand >= 40 && rand < 47: position 4
if rand >= 47 && rand < 55: position 5

if rand >= 55 && rand < 60: position 6
if rand >= 60 && rand < 65: position 7
if rand >= 65 && rand < 70: position 8
if rand >= 70 && rand < 75: position 9
if rand >= 75 && rand < 80: position 10
if rand >= 80 && rand < 90: position 11
*/

while (true)   // change the 5 in a < 5 to simulate more/less loops
{
    0 => int x;     // Var for turning on/off gain
    0 => int pos;   // Var for randomizing starting position

    // Picking a random num between 1 and 100: major/minor decision
    Math.random2f(1, 100) => float rand;
    // Picking a random num between 1 and 90: starting position (chord) decision
    Math.random2f(1, 90) => float rand2;
    // Random number between 0 and 1 that will determine gain value
    Math.random2f(0, 1) => float rand3;


    // Figuring out starting position (chord for arpeggio)
    if (rand2 > 0 && rand2 < 20){
        1 => pos;
    } else if (rand2 >= 20 && rand2 < 30){
        2 => pos;
    } else if (rand2 >= 30 && rand2 < 40){
        3 => pos;
    } else if (rand2 >= 40 && rand2 < 47){
        4 => pos;
    } else if (rand2 >= 47 && rand2 < 55){
        5 => pos;
    } else if (rand2 >= 55 && rand2 < 60){
        6 => pos;
    } else if (rand2 >= 60 && rand2 < 65){
        7 => pos;
    } else if (rand2 >= 65 && rand2 < 70){
        8 => pos;
    } else if (rand2 >= 70 && rand2 < 75){
        9 => pos;
    } else if (rand2 >= 75 && rand2 < 80){
        10 => pos;
    } else if (rand2 >= 80 && rand2 < 90){
        11 => pos;
    } else {
        12 => pos;
    }

    
    // Mess around with panning
    rand3 => pan1.pan;
    rand3 => pan2.pan;
    <<<"Rand3: ", rand3, "pan value">>>;


    // 70% chance of a major chord
    if (rand <= 70 && rand > 0)
    {
        <<<"Rand: ", rand, "Major chord picked">>>;
        <<<"Rand2: ", rand2, "Position: ", pos>>>;
        <<<"-------------------------------------">>>;
        // Call the playTwoBars function
        playTwoBars(pos, major);
    }


    // 30% chance of a minor chord
    else if (rand <= 100 && rand > 70)
    {
        <<<"Rand: ", rand, "Minor chord picked">>>;
        <<<"Rand2: ", rand2, "Position: ", pos>>>;
        <<<"-------------------------------------">>>;
        // Call the playTwoBars function
        playTwoBars(pos, minor);
    }
}


