import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;//set up OSC

int[] keys = new int [4];
int velocity, slider,count;//global variables

triForce[] t = new triForce[4];//array of objects

void setup()
{
  size(400, 400); 
  frameRate(30);
  velocity = 127;
  slider = 30;
  for (int i = 0; i < t.length; i++)
  {
     t[i] = new triForce(); 
  }//intialise values and objects

  oscP5 = new OscP5(this, 12001);//recieve
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);//send
}

void draw()
{
  background(255);//refresh the background
  for (int i = 0; i < t.length; i++)
  {
      t[i].update(keys[i],slider);
      t[i].borderCheck();//update all the things
      for (int j = 0; j < t.length; j++)
      {
          if (j != i)
         {
            t[i].edgeCheck(t[j].location);//check collisions
         } 
      }
  }
}

void oscEvent (OscMessage msg)
{
  //incoming key message
  if (msg.checkAddrPattern("/key") == true)
  {
    if (msg.checkTypetag("ii"))
    {
      
      keys[count%keys.length] = msg.get(0).intValue();
      velocity = msg.get(1).intValue();//set to values
      setPos(count%keys.length);//set position of one of the movers
      count++;//increment count to change which objects move on a key press
    }
  }
  //incoming slider
  if (msg.checkAddrPattern("/slider") == true)
  {
    if (msg.checkTypetag("i"))
    {
      slider = msg.get(0).intValue();//store value
    }
  }
}

void setPos(int index)
{//set destination
   t[index].click(map(velocity,0,127,0,width),map(keys[index],0,127,0,height)); 
}

void keyPressed()
{
   if (key == 32){
      for (int i = 0; i < keys.length; i++)
      {
          keys[i] = 0;//reset with spacebar
      }
   } 
}

