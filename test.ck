/*
NOTES:

This program is going to be what gets inserted into the MiniAudicle
and gets played live. In this program, there are initialized parameters that
define the starting state of the oscillators and their features.

In the latter half of this program, there are helper functions that provoke
certain preset actions given specific parameters - this also aids in the 
live creation process.

This program was created by Hannah Larsen for MUSC 455
Inspired by Clint Hoagland (YouTube via Clint Hoagland)

THIS PROGRAM IS NOT COMPLETE, BUT MORESO AN EXPERIEMENTAL PROTOTYPE TO
DEMONSTRATE THE USE OF LIVECODING IN CHUCK.
*/



/*
SndBuf (Sound Buffer)
This section initializes all the values for the Sound Buffers including, but not limited to:

Type of oscillator (sin/tri/sqr), envelope it will be utilizing (envX), panning amount (panX), reverb (revX)
delay (delayX), and dac (which is what the sound gets outputted to -> Digital Audio Converter)
*/

// SndBuf crows => dac;    // ambient background wav file -> ununsed in MiniAudicle livecoding
// osc1: for if statements
SinOsc osc => ADSR env1 => Pan2 pan1 => dac;
// osc2: supporting osc for if statements               
SinOsc osc2 => ADSR env2 => Pan2 pan2 => dac;
// osc3: background osc (plays throughout)               
SinOsc osc3 => ADSR env3 => NRev rev3 => Pan2 pan3 => dac; 
// env/delay -> chaining various fx 
env3 => Delay delay3 => SndBuf crows => dac;
delay3 => delay3;

// Initializing for reading from a local wav file (this os unused in the livecoding)
me.dir() + "crows-edited.wav" => string filename;
filename => crows.read;
crows.samples() => crows.pos;
0 => crows.pos;

// Params for oscs (gain/pan)
0.2 => osc.gain;
0.2 => osc2.gain;
0.15 => osc3.gain;


/*
Paramater setting:
This section initializes more parameters, but instead of oscillator specific, it sets params
for other variables we may find useful during the livecoding process.

Offset is the initial starting pitch (this is set to ensure pitch is not too high or too low).
Position is initialized as an int and will be used to indicate what scale degree we start on 
        (e.g. starting on 1 indicates the tonic scale degree).
Beat defines the pace at which the notes are played (1::second == quarter note)
ADSR (attack, decay, sustain, release) and respective values for each param
*/

// General/MISC params
48 => int offset;       
int position;
1::second => dur beat;

// ADSR: (att, decay, sus, rel)
(beat/2, beat/2, 0, 1::ms) => env1.set;
(beat/2, beat/2, 0, 1::ms) => env2.set;
(100::ms, beat/4, 0.5, 10::ms) => env3.set;

// Defining delay params so Chuck can allocate space accordingly
beat => delay3.max;
beat/4 => delay3.delay;
0.5 => delay3.gain;

// Reverb
0.2 => rev3.mix;

//Defining what it means to be certain chords (for use later in function)
[0,4,7,12] @=> int major[];
[0,3,7,12] @=> int minor[];
[0,3,6,12] @=> int dim[];
[0,4,8,12] @=> int aug[];

// choice: specific choice int will determine diff sequence triggered
//0 => int choice;
// chord: type of chord played at position (maj/min/ug/dim)
0 => int chord;
// speed: how fast notes are played
2 => int speed;



/*
PlayChoice function:

PlayChoice takes the choice and chord types as params and plays them in various 
sequences as indicated by the user. Execution of function is provided within.
TLDR: used for the louder melody notes. User will input a list of 8 scale degree values
and program will output that note sequence.

In the latter half of this function, various "choice" if statements are present and will
get triggered when the user changes the choice integer value. These will differ the note values
and speed depending on which one is picked.
*/

fun void PlayChoice (int choice, int chord[]){
    // This for loop is responsible for the 'melody' of the piece (the louder more prominent notes)
    // h can only go up to 4 which will give us 4 rotations of 1 type of chord before switching to the next one
    // once the loop is done, we go back to the top of the while and choose new params
    
    //crows.length() => now;    //NEED TO GET THIS WORKING IN PARALLEL WITH OTHER STUFF

    for (0 => int h; h < 1; h++){
        
        // right now its doing the big note sequence thing for choice 1, but only doing the background stuff for choices 2/3 because of the way the for loop is laid out
        if (choice ==  1) {
            // list of numerical scale degrees that will be played
            /*
            these are the following note sequence changes
            (each list will have 8 elements)
            [2,4,6,8,7,6,5,4]
            [1,2,3,4,5,6,7,8]
            [1,8,6,4,5,2,3,4]
            [1,3,5,7,8,6,4,2]
            [3,5,7,6,8,4,6,3]
            */
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
                beat / 4 => now;
            }
        }

        // This for loop creates the 'background' loop that is softer in dynamics and texture
        // osc3 is responsible for the background noises, which is why we only call that osc here
        for (0 => int j; j < 4; j++){  
            Std.mtof(chord[j] + offset + position - 7) => osc3.freq;   
            1 => env3.keyOn;
            beat / 4 => now;
        }

        // have a slower option for choices 4/5 to pivot to
        if (choice == 4) {
            for (0 => int j; j < 4; j++){ 
            Std.mtof(chord[j] + offset + position - 7) => osc3.freq;   
            1 => env3.keyOn;
            beat / 1 => now;
            }
        } 

        if (choice == 5) {
            for (0 => int j; j < 4; j++){ 
                Std.mtof(offset + position +11) => osc.freq;
                1 => env1.keyOn;
                Std.mtof(offset + position + 8) => osc2.freq;
                2 => env2.keyOn;
                beat / 16 => now;
            }
        }
    }
}

/*
While True:

This section implements the print statements that help the user test for which chord was picked.
A print statement will execute every time a chord is picked.
*/

// The sounds will keep being randomly generated until the user stops the program (infinite loop until terminated)
while(true){

    //Generates a random number between (min, max) i.e. number of different choice branches
    // THIS CAN BE MANUALLY CHANGED BY USER BY TYPING IN AN INTEGER FOR CHOICE INSTEAD OF CHOOSING IT RANDOMLY
    // random:      Math.random2(1,5)
    1 => int choice;
    1 => int chordType;
    
    // If tree assigns the chord type based on random num selection
    if (chordType == 1){
        <<<"Fork", choice, "was picked. Major chord was picked.">>>;
        PlayChoice(choice, major);
    } else if (chordType == 2){
        <<<"Fork", choice, "was picked. Minor chord was picked.">>>;
        PlayChoice(choice, minor);
    } else if (chordType == 3){
        <<<"Fork", choice, "was picked. Augmented chord was picked.">>>;
        PlayChoice(choice, aug);
    } else {
        <<<"Fork", choice, "was picked. Diminished chord was picked.">>>;
        PlayChoice(choice, dim);
    }
}