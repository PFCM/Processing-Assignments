public class OSC_Animate
{
    OscRecv recv;
    12000 => recv.port;
    recv.listen();//set up OSC
    
    recv.event("/collision, f") @=> OscEvent collisionEvent;
    recv.event("/location, ffffffffffffffffffff") @=> OscEvent xEvent;
    recv.event("/velocity, ffffffffffffffffffff") @=> OscEvent vEvent;//get ready to recieve
    
    float locationX[20];
    float velocities[20];
    float collisionVelocity;
    Event collision;//variables for the data and an event when something cool happens
    
    fun void init()//make things go
    {
        spork ~ collisionPoller();
        //spork ~ xPoller();// commented out because I didn't end up using it
        spork ~ vPoller();
    }
    
    fun void collisionPoller()
    {
        while (true)
        {
            collisionEvent => now;//wait for collision messages
            if (collisionEvent.nextMsg() !=0)
            {
                collisionEvent.getFloat() => collisionVelocity;//when they come store the value of the velocity
                collision.broadcast();//broadcast the event
            }
            10::ms => now;//check frequently
        }
    }
    
    fun void xPoller()//gets location info
    {
        while(true)
        {
        xEvent => now;
        if (xEvent.nextMsg() != 0)
        {
            for (0 => int i; i < locationX.cap(); i++)
            {
                xEvent.getFloat() => locationX[i];
            }
        }
        (1/60)::second => now;
    }
    }
    
    fun void vPoller()//gets velocity info
    {
        while(true)
        {
            vEvent => now;
            if (vEvent.nextMsg() != 0)
            {
                for (0 => int i; i < velocities.cap(); i++)
                {
                    vEvent.getFloat() => velocities[i];
                }
            }
            (1/60)::second => now;
        }
    }
}