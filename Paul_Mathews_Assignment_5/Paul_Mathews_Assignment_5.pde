import oscP5.*;
import netP5.*;//import librais

OscP5 oscP5;
NetAddress myRemoteLocation;//set up OSC

beziers b;
pulsingEllipses p;//shapes (most of)

//global variables
PVector centroidCurve;
float roff, cent, flux, rms, t;
int gateCross, count;

void setup()
{
  size(400, 400);
  smooth();
  frameRate(30);
  rectMode(CENTER);//nitialise look

  b = new beziers(30, 2);
  p = new pulsingEllipses(width, height);//initialise classes

  centroidCurve = new PVector(width/2, height/2);

  oscP5 = new OscP5(this, 12001);//recieve
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);//send
}
void draw()
{
  fill(0, 25);
  rect(width/2, height/2, width, height);//fade out with a tail

  p.update(flux, rms);//update ellipses

  if (gateCross == 1)
  {
    fill (255, 180, 0, 127);
    ellipse(width/2, height/2, width, height);//draw big circle if peak reached
  }

  t += cent/5;//advance t at a rate dependant on the centroid

  centroidCurve = polarConvert(t, cos(5*t));//equation for curve
  centroidCurve.x *= 130;
  centroidCurve.y *= 130;//scale
  centroidCurve.x += width/2;
  centroidCurve.y += height/2;//move to centre
  
  noStroke();
  fill(200, 200);
  ellipse(centroidCurve.x, centroidCurve.y, 10, 10);//draw circle going round curve
  
  b.directionSet(centroidCurve);
  b.bend(cent*20, centroidCurve.x, centroidCurve.y);
  b.update(map(roff, 0, 1, 0, 255));//make curves work with shape etc

  count++;//increment counter
}

PVector polarConvert(float theta, float radius)
{
  float x, y;
  y = radius*(sin(theta));
  x = radius*(cos(theta));//convert polar coords (r and theta) to x and y

  PVector result = new PVector(x, y);

  return result;//return 
}

void oscEvent (OscMessage msg)//called when OSC in
{
  if (msg.checkAddrPattern("/things") == true)//if it is all the data
  {
    if (msg.checkTypetag("ffff"))
    {
      roff = msg.get(0).floatValue();
      cent = msg.get(1).floatValue();
      flux = msg.get(2).floatValue();
      rms = msg.get(3).floatValue();//set all the things
    }
  }
  if (msg.checkAddrPattern("/trigger") == true)//if threshold passed (either way)
  {
    if (msg.checkTypetag("i"))
    {
      gateCross = msg.get(0).intValue();//set variable
    }
  }
}

