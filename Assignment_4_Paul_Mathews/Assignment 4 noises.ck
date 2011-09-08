KeyStation p;
p.initPoller(0);//init send and recieve

int count,index;
float width;//variablesa

TriOsc s[127];//an oscillator for each key
ADSR e[s.cap()];//an envelope for each oscillator

for (0 => int i; i < s.cap(); i++)
{
    s[i] => e[i] => dac;
    e[i].set(10::ms, 40::ms, .4, 300::ms);
    e[i].keyOff();
    Std.mtof(i) => s[i].freq;//set up oscillators and envelopes
}

fun void play(int key)//play
{
   
   e[key].keyOn();
   while (p.Keys[key] > 0)
   {
       p.slider/127.0 => s[key].width;//change tone with slider
       1::ms => now;//loop until key off
   } 
   e[key].keyOff();
   e[key].releaseTime() => now;//let it release properly
}

while (true)
{
   p.keypressed => now;
   
   spork ~ play(p.lastkey);//make things go 
}