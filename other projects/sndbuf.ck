/* Program that helps us experiment with the sound buffer ugen 
   which will allow us to import sound files and play them via ChucK 
   - you can manually specify a start time to a sample by chucking a
   number to [sample].pos */

SndBuf uke => dac;
me.dir() + "Ukulele_Chill.wav" => string filename;
filename => uke.read;

<<<uke.samples()>>>; // Prints out how many samples are in clip
uke.samples()/6 => float ukeTime; //Setting the play time to the duration of the full sample

ukeTime::second => now; // Playing the sample