OscRecv recv;
12000 => recv.port;
recv.listen();//set up reciever

recv.event("/velocity, ffffffffff") @=> OscEvent velocityEvent;//create events
recv.event("/location, ffffffffff") @=> OscEvent locationEvent;
recv.event("/collision, i") @=> OscEvent collisionEvent;

float velocityValues[10];
float locationValues[10];//arrays to store values
TriOsc s[10];//some oscillators
for (0 => int i; i < s.cap(); i++){
    s[i] => dac;
    .2 => s[i].gain;//set gain
}

fun void velPoller()
{
    while (true)
    {
        velocityEvent => now;//waiting for a velocity event
        if (velocityEvent.nextMsg() != 0)//JIC
        {
            for (0 => int i; i < velocityValues.cap(); i++)
            {
                velocityEvent.getFloat() => velocityValues[i];//store values in array
                velocityValues[i]/5 => s[i].width;//normalise values and set to symmetricity of the triangles
            }
            
            
        }
        1::second/60 => now;//refresh
    }
}

fun void locPoller()
{
    while (true)
    {
        locationEvent => now;
        if (locationEvent.nextMsg() != 0)//as above
        {
            for (0 => int i; i < locationValues.cap(); i++)
            {
                locationEvent.getFloat() => locationValues[i];//store x position values
                locationValues[i] => s[i].freq;//set x position to frequency
            }
            
            
        }
        1::second/60 => now;
    }
}

fun void collisionPoller()
{
    while(true)
        {
            collisionEvent => now;
            if (collisionEvent.nextMsg() != 0)
            {
                spork ~ collision(collisionEvent.getInt());//send off collision function(for polyphony)
            }
            1::second/60 => now;
        }
    }
 
fun void collision(int input)
{
    SqrOsc sq => ADSR e => dac;//new oscillator each time it is sporked allows several at the same time
    .05 => sq.gain;//gain
    e.set(10::ms,10::ms,1,200::ms);//pretty much just a release time
    for (input+75 => int i; i > 50; i--)
    {
        e.keyOn(1);
        i => sq.freq;
        1::ms => now;//frequency goes down        
    }
}
    
spork ~ collisionPoller();
spork ~ velPoller();
spork ~ locPoller();//spork pollers

while(true){//make sure it keeps going
    1::second => now;
}