public class KeyStation{
    MidiIn min;
    MidiMsg msg;//set up the midi
    
    int Keys[127];
    Event keypressed, keyreleased;
    int lastkey,slider;//variables to store info
    
    "localhost" => string hostname;
    12001 => int port;
    OscSend xmit;
    xmit.setHost(hostname,port);//aim the Osc send
    
    fun void OscKey(string msg, int i, int i2)
    {
        xmit.startMsg("/key","ii");
        i => xmit.addInt;
        i2 => xmit.addInt;// send key data over OSC
    }
    
    fun void OscSlider(string msg, int i)
    {
        xmit.startMsg("/slider", "i");
        i => xmit.addInt;//send slider over OSC
    }
    
    fun void initPoller(int p)
    {
        if (!min.open(p))//open port
        {
         <<<"KeyStation: Error : ",p>>>;  //if no open 
        }
        spork ~ poller();//spork poller
    }
    
    fun void poller()
    {
        while (true)
        {
            min => now;
            while (min.recv(msg))
            {
                if (msg.data1 == 144)//if note on channel one
                {
                    //store velocity in keys[] by pitch number
                    msg.data3 => Keys[msg.data2];//store incoming midi data in variables
                    msg.data2 => lastkey;
                    if (msg.data3 > 0)//if not the off
                    {   
                        OscKey("/key",lastkey,Keys[lastkey]);//send key
                        keypressed.broadcast();//event on keypress(any)
                    }
                }
                if (msg.data1 == 176)//if CC
                {
                   msg.data3 => slider;//store data
                   OscSlider("/slider",slider); //send slider
                }
            }
        }
    }    
}