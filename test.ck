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

SinOsc osc => ADSR env1 => Pan2 pan1 => dac;    // osc1: for if statements
SinOsc osc2 => ADSR env2 => Pan2 pan2 => dac;   // osc2: supporting osc for if statements
SinOsc osc3 => ADSR env3 => NRev rev3 => Pan2 pan3 => dac;  // osc3: background osc (plays throughout)
env3 => Delay delay3 => dac;
delay3 => delay3;

// Params for oscs (gain/pan)
0.2 => osc.gain;
0.2 => osc2.gain;
0.15 => osc3.gain;

// Some starting positions/params
48 => int offset;       // how far out is our starting pitch
int position;           // what location our chord starts on (changes pitch)
1::second => dur beat;  // defining our 'beat' which will allow noise to output

// Params for ADSR envs
// att   decay  sus  rel
(beat/2, beat/2, 0, 1::ms) => env1.set;
(beat/2, beat/2, 0, 1::ms) => env2.set;
(100::ms, beat/4, 0.5, 10::ms) => env3.set;

// Params for delay
// need to define these otherwise the chuck memory cannot
// hold onto space in memory for the delay
beat => delay3.max;
beat/4 => delay3.delay;
0.5 => delay3.gain;

// Params for reverb
0.2 => rev3.mix;

//Defining what it means to be certain chords (for use later in function)
[0,4,7,12] @=> int major[];
[0,3,7,12] @=> int minor[];
[0,3,6,12] @=> int dim[];
[0,4,8,12] @=> int aug[];

0 => int choice;    // random choice number for generating music
0 => int chord;     // type of chord played at position
2 => int speed;     // how fast the notes are played

fun void PlayChoice (int choice, int chord[]){
    // This for loop is responsible for the 'melody' of the piece (the louder more prominent notes)
    // h can only go up to 4 which will give us 4 rotations of 1 type of chord before switching to the next one
    // once the loop is done, we go back to the top of the while and choose new params
    for (0 => int h; h < 4; h++){
        
        if (choice ==  1) {
            // list of numerical scale degrees that will be played
            [1, 3, 4, 5, 6, 5, 4, 3] @=> int noteSequence[]; 

            // for loop executes 8 times, 1 time for each note, 8 note sequence
            for(0 => int i; i < 8; i++){

                // this is what we are telling the machine to play
                // offset is the predefined freq value that will let us actually hear it midrange
                // noteSequence is the list of scale degrees that will be played based on the choice num
                // we put -1 because all the scale degrees are 1 more than the actual value that will be played
                Std.mtof(offset + noteSequence[i] +11) => osc.freq;
                1 => env1.keyOn;
                Std.mtof(offset + noteSequence[i] +18) => osc2.freq;
                2 => env2.keyOn;
                beat / 8 => now;
            }
        }

        // This for loop creates the 'background' loop that is softer in dynamics and texture
        // osc3 is responsible for the background noises, which is why we only call that osc here
        for (0 => int j; j < 4; j++){  
            Std.mtof(chord[j] + offset + position - 12) => osc3.freq;   
            1 => env3.keyOn;
            beat / 8 => now;
        } 
    }
}


// The sounds will keep being randomly generated until the user stops the program (infinite loop until terminated)
while(true){

    1 => int choice;    // CHANGE LATER FOR RANDOM NUM GENERATION

    PlayChoice(choice, major);  //manually change chord type here or have a random gen and variable alias
}