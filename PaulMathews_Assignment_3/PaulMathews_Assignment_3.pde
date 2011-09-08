
triForce[] movers = new triForce[20];//array of things to move

import oscP5.*;
import netP5.*;//import libraries

OscP5 oscP5;
NetAddress myRemoteLocation;//osc things


void setup() {  
  size(400, 400);
  smooth();
  frameRate(30);//initialise things
  for (int i = 0; i < movers.length; i++) {
    movers[i] = new triForce();
  }//initialise moving things

  oscP5 = new OscP5(this, 12001);
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);//initialise osc and network things
}

void draw() {
  fill(255, 40);
  rect(0, 0, width, height);//draw a slightly transparent rectangle each time instead of a background so moving things leave a trail
  
  for (int i = 0; i < movers.length; i++) {
    movers[i].update();//update all the things
    movers[i].borderCheck();
    for(int j = 0; j < movers.length; j++){
      if(j != i){
       movers[i].edgeCheck(movers[j].location); //check all the edges
      }
    }        
  }
 oscSendVel();
  oscSendLoc();//send some messages
}


void mousePressed() {
  for (int i = 0; i < movers.length; i++) {
    movers[i].click();//make things go to mouse when clicked
  }
}

void mouseDragged() {
  for (int i = 0; i < movers.length; i++) {
    movers[i].click();//make things go to mouse when clicked and moved
  }
}
void oscSendVel() {
  OscMessage myMessage = new OscMessage("/velocity");//new message
  for (int i = 0; i < movers.length; i++) {
    myMessage.add(movers[i].velocity.mag());//fill message with velocities
  }
  oscP5.send(myMessage, myRemoteLocation);//send
}
void oscSendLoc() {
  OscMessage myMessage = new OscMessage("/location");//newer message
  for (int i = 0; i < movers.length; i++) {
    myMessage.add(movers[i].getLocationX());//fill message with x location
  }
  oscP5.send(myMessage, myRemoteLocation);//send
}

