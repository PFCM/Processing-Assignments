OSC_Animate a;
a.init();//ready to recieve



fun void play()
{
   SinOsc m => SinOsc c => ADSR e => dac;//if we do this here we can have polyphony
c.sync(2);

e.set(30::ms, 150::ms, .3, 200::ms);//set the envelope
    a.collisionVelocity*400 => m.gain;//modulation index is controlled by velocity at impact
    220*a.collisionVelocity => c.freq;//and so are the frequencies
    220/a.collisionVelocity => m.freq;
    e.keyOn();//go!!
    200::ms => now;
    e.keyOff();//stop!!
    200::ms => now; 
}


while(true)
{
    a.collision => now;//when they collide
    spork ~ play();//make noise
    1::ms => now;//wait and check again
}