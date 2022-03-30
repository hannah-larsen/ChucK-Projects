<<<"Some Major/Minor Arpeggio Stuff">>>;

SinOsc osc => dac;
0.5 => osc.gain;

[0,4,7] @=> int major[];
[0,3,7] @=> int minor[];

67 => int offset;
int position;

140::ms => dur eighth;

// Iterate once
// this emulates a basic 1-4-5-7 chord progression
for(0 => int x; x < 1; x++)
{
    // Major arpeggio
    0 => position;
    for (0 => int i; i < 4; i++)
    {
        for (0 => int j; j < 3; j++)
        {
            Std.mtof(major[j] + offset + position) => osc.freq;
            eighth => now;
        }
    }

    // Minor arpeggio
    -3 => position;
    for (0 => int i; i < 4; i++)
    {
        for (0 => int j; j < 3; j++)
        {
            Std.mtof(minor[j] + offset + position) => osc.freq;
            eighth => now;
        }
    }

    // Major arpeggio
    5 => position;
    for (0 => int i; i < 4; i++)
    {
        for (0 => int j; j < 3; j++)
        {
            Std.mtof(major[j] + offset + position) => osc.freq;
            eighth => now;
        }
    }

    // Major arpeggio
    7 => position;
    for (0 => int i; i < 4; i++)
    {
        for (0 => int j; j < 3; j++)
        {
            Std.mtof(major[j] + offset + position) => osc.freq;
            eighth => now;
        }
    }
}