/* 
Used to initialize the playing of base files for live coding.
Created by: Hannah Larsen
Inspired by Clint Hoagland
*/

me.dir() + "synths.ck" => string voiceFile;
me.dir() + "use.ck" => string loopFile;

Machine.add(voiceFile);
Machine.add(loopFile);