OSC_Animate a;
a.init();//set up an instance of our reciever and get started
JCRev r => dac;
.1 => r.mix;//bit of a reverb

SinOsc s[20];//need many sines

for (0 => int i; i < s.cap(); i++)
{
    s[i] => r;
}//sines to reverb

fun void setGain()
{
    for (0 => int i; i < s.cap(); i++)
    {
        a.velocities[i]/16 => s[i].gain;
    }//speed of each moving object controls the gain of one oscillator
}
fun void setFreq()
{
    for (0 => int i; i < s.cap(); i++)
    {
        220*(2*i+1) => s[i].freq;
    }//all the odd harmonics, makes a square wave except for the variable roll-off
}

while (true)
{
    setGain();
    setFreq();
    1::ms => now;
}//make things happen, and happen often