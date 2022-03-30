/* This simple program demonstrates how a function is defined in ChucK */

// fun returnType funcName (params)
fun int multiply(int x, int y)
{
    <<<"I'm in multiply func">>>;
    return x*y;
}

// Values to be passed into function
2 => int x;
3 => int y;

// Function call: funcName (params)
<<<multiply(x,y)>>>;