# ChucK-Projects
A collection of my small ChucK projects that I am currently working on.

## Language Background
ChucK is a language developed by students at Princeton University based around the Java and C languages. 
This language aims to combine traditional coding styles with music-based elements to generate audio.

## Installation
To run the following ChucK files, the user needs to have MiniAudicle installed. 
A useful tutorial for installing this is located here: http://audicle.cs.princeton.edu/miniAudicle/mac/doc/
*Note: The user must have the MiniAudicle installed in the same file path as the .ck file in order for it to recognize its whereabouts.

## Helpful Resources
Clint Hoagland (on YouTube) is a master at ChucK and this series of projects could not have been possible without him. 
Link to his Chuck YouTube playlist: https://www.youtube.com/watch?v=toFvb6uqiDc&list=PL-9SSIBe1phI_r3JsylOZXZyAXuEKRJOS
<br /><br /><br />

# Project Files
## MUSC355.ck
This program is a project for my MUSC 355 class, completed in Winter 2022. This project uses Markov chains to generate randomly produced sequences of arpeggios.
Because this is generative, the program essentially runs until the user prompts it to stop playing.
This program randomly manipulates chord type (major/minor), key of the chord (starting pitch), gain, reverb, and panning.
=> chucksong.wav is a rendered WAV file of what this program outputs when run.

## rainfall.ck
This was a short experimental file to play with the concepts of descending arpeggios.

## music1.ck
Playing around with randomization concepts; used this as a building block for MUSC355.ck.

## scale-generator
WORK IN PROGRESS. This program intends to ask the user for parameters (such as type of scale/chord/etc...) and program will output the users request.
<br /><br /><br />

# Learning Files
## func.ck
Experiementing with how functions work in ChucK.

## sndbuf.ck
Experimenting with SndBuf (sound buff) which essentially takes a sound from an external WAV file and manipulates it into the program dfor usage.

## randomize.ck
More playing around with randomizing parameters.

## line.ck
Building block program; outputting frequencies with oscillators.
