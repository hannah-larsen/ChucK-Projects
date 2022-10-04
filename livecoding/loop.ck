/*
Starter code used for looping shreds every 16 bars.
What this program does is it takes the stuff we want removed
and removes it after 16 bars, and similarily replaces the stuff we
want in the synth/pan and adds it in after that 16 bar count.

Created by: Clint Hoagland
Source: https://www.youtube.com/watch?v=xRaD_1UK0bQ&t=324s
*/

0 => int removeSynth;
0 => int removePanning;
me.dir() + "live.ck" => string synthFile;
me.dir() + "panning.ck" => string panFile;

1::second / 2 => dur beat;

while(true){
    // Removing anything from the machine with synth/pan id's
    Machine.remove(removeSynth);
    Machine.remove(removePanning);
    // Adding anything to machine with synth/pan id's
    Machine.add(synthFile) => removeSynth;
    Machine.add(panFile) => removePanning;
    // This is saying that this will repeat every 16 bars instead of every note
    // to add some form of structure/consistency 
    beat * 16 => now;
}