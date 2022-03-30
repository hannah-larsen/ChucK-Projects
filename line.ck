<<<"Testing for Chuck">>>;

TriOsc osc => dac;
0.25 => osc.gain;

[110, 220, 330, 440, 660, 880, 990, 1320, 100, 200, 300, 400, 600, 800, 900, 1200] @=> int frequencies[];

for(0 => int i; i < frequencies.cap(); i++)
{
    frequencies[i] => osc.freq;
    200::ms => now;
}