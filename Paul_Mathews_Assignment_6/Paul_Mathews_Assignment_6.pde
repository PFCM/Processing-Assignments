/* Visualiser - Paul Mathews 300190240 */

// Import necessary libraries
import oscP5.*;
import netP5.*;

// To recieve info
OscP5 oscP5;
NetAddress myRemoteLocation;

// Objects to draw things
Mover[] m = new Mover[760];
Mover controller;
Mover[] m2 = new Mover[m.length];
Mover controller2;
Mover[] m3 = new Mover[m.length];
Mover controller3;
Mover[] m4 = new Mover[m.length];
Mover controller4;

// Global variables
float THETA_SPREAD;
float peak;
int[] pitch = new int[4];

// Setup
void setup()
{
  // Settings
  size(600, 600);
  frameRate(30);
  smooth();
  background(255, 255, 0);// Why not yellow? Will soon change…

  // Spread the m objects evenly around 360˚
  THETA_SPREAD = TWO_PI/m.length;

  // Initialise objects
  // Controllers first
  controller = new Mover(3, .5, width/2+30, height/2, "CIRCLE", 0, 0);
  controller2 = new Mover(3, .5, width/2-30, height/2, "CIRCLE", 1, 0);
  controller3 = new Mover(3, .5, width/2, height/2-30, "CIRCLE", 2, 0);
  controller4 = new Mover(3, .5, width/2, height/2, "CIRCLE", 3, 0);

  // Then moving lines
  for (int i = 0; i < m.length; i++)
  {
    m[i] = new Mover(8, .8, width/2, height/2, "LINE", 0, THETA_SPREAD*i);
    m2[i] = new Mover(8, .8, width/2, height/2, "LINE", 1, THETA_SPREAD*i);
    m3[i] = new Mover(8, .8, width/2, height/2, "LINE", 2, THETA_SPREAD*i);
    m4[i] = new Mover(8, .8, width/2, height/2, "LINE", 3, THETA_SPREAD*i);
  }

  // And finally OSC things
  oscP5 = new OscP5(this, 12001);
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);
}

// Loop some things
void draw()
{
  // Backgrond for a nice trail effect
  noStroke();
  fill(0, 25);
  rect(0, 0, width, height);

  // Update all the things
  update();

  // If we get a peak message
  if (peak > 1)
  {
    for (int i = 0; i < m.length; i++) 
    {
      m[i].bump(peak);
      m2[i].bump(peak); 
      m3[i].bump(peak);
      m4[i].bump(peak);
    }
    peak = 0;
  }
}

// Moving controllers with mouse
// on click
void mousePressed()
{
  // Check if mouse is over a controller
  controller.mouseCheck(mouseX, mouseY);
  controller2.mouseCheck(mouseX, mouseY);
  controller3.mouseCheck(mouseX, mouseY);
  controller4.mouseCheck(mouseX, mouseY);

  // If it is, set new direction...
  if (controller.mouseOver) controller.setDirection(mouseX, mouseY);
  else if (controller2.mouseOver) controller2.setDirection(mouseX, mouseY);
  else if (controller3.mouseOver) controller3.setDirection(mouseX, mouseY);
  else if (controller4.mouseOver) controller4.setDirection(mouseX, mouseY);
}

// ...and keep setting it when mouse is dragged
void mouseDragged()
{
  if (controller.mouseOver) controller.setDirection(mouseX, mouseY);
  else if (controller2.mouseOver) controller2.setDirection(mouseX, mouseY);
  else if (controller3.mouseOver) controller3.setDirection(mouseX, mouseY);
  else if (controller4.mouseOver) controller4.setDirection(mouseX, mouseY);
}

// Stop setting direction when mouse released
void mouseReleased()
{
  // All back to false
  controller.mouseOver = false;
  controller2.mouseOver = false;
  controller3.mouseOver = false;
  controller4.mouseOver = false;
  // Cursor back to normal
  cursor(ARROW);
}

// Just a little bit of human interaction
void keyPressed() 
{
  if (key == 32)// spacebar
  {
    // Give em a bump
    for (int i = 0; i < m.length; i++)
    {
      m[i].bump(1.7);
      m2[i].bump(1.7);
      m3[i].bump(1.7);
      m4[i].bump(1.7);
    }
  }
}

// Update the display objects
void update()
{
  // Controllers
  controller.update(pitch);
  controller2.update(pitch);
  controller3.update(pitch);
  controller4.update(pitch);

  // Moving lines - update direction also
  for (int i = 0; i < m.length; i++)
  {
    m[i].update(pitch);
    m[i].setDirection(controller.location.x, controller.location.y);
    m2[i].update(pitch);
    m2[i].setDirection(controller2.location.x, controller2.location.y);
    m3[i].update(pitch);
    m3[i].setDirection(controller3.location.x, controller3.location.y);
    m4[i].update(pitch);
    m4[i].setDirection(controller4.location.x, controller4.location.y);
  }
}

// Osc Receiver
void oscEvent(OscMessage msg)
{
  // If RMS peak message
  if (msg.checkAddrPattern("/RMS_Peak"))
  {
    if (msg.checkTypetag("f"))
    {
      peak = msg.get(0).floatValue()+4;// Peak goes up to give a good bump
    }
  }

  // If it comes from the pitch detector
  if (msg.checkAddrPattern("/pitches"))
  {
    if (msg.checkTypetag("iiii"))
    {
      // Fill pitch array with info
      for (int i = 0; i < 4; i++) 
      {
        pitch[i] = msg.get(i).intValue();
      }
    }
  }
}

