/* ChucK program that emulates the sound of a 'rainfall' using arpeggios */
SinOsc osc => dac;
0.5 => osc.gain;

[0,4,7] @=> int major[];
[0,3,7] @=> int minor[];

48 => int offset;
int position;

100::ms => dur eighth;

for(0 => int x; x < 1; x++)
{
    -3 => position;
    for (48 => int i; i > 0; i--)
    {
        i => position;
        for (0 => int j; j < 3; j++)
        {
            Std.mtof(major[j] + offset + position) => osc.freq;
            eighth => now;
        }
    }

}