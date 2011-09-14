// Particle emitter, Paul Mathews

import oscP5.*;  // Import OSC and net libraries
import netP5.*;

ParticleSystem particleController; // Instance of the system


void setup() {
  size(640, 360);    // Size
  smooth();          // Anti-aliasing
  frameRate(25);     // Sensible frame rate

  particleController = new ParticleSystem();// All systems are go
}



// Actually loop
void draw() {
  background(0); // Background

  /* This way the function loops when the mouse is clicked but not dragged.
  The other option is to use mousePressed() and mouseDragged(), but unless you
  drag that way only adds particles once. 
           - this way the repeller and attractor mouseOver is constantly set 
             reset, but I think it's more important to have the particles
             drawing well */
  if (mousePressed) {
    click(mouseX, mouseY);
  }

  update();// Make sure things update
}

// Function to update and draw
void update() {
  particleController.update();
  particleController.draw();
}

// Funtion to deal with mouse input
void click(int x, int y) {
  PVector mouse = new PVector(mouseX, mouseY); // save some typing
  
  // If a key is pressed and mouse is clicked
  if (keyPressed) {
    switch(key) { // easier than a lot of ifs
    case 'a':
    // Move the attractor if the mouse is over
      if (particleController.att.mouseCheck(mouseX, mouseY)) {
        particleController.att.direct(mouseX, mouseY);
      }
      break;
    case 'r':
    // Move the repeller if the mouse is over
      if (particleController.rep.mouseCheck(mouseX, mouseY)) {
        particleController.rep.direct(mouseX, mouseY);
      }
      break;
    // Add standard particles
    case 'p':
      particleController.addParticles(2, new PVector(x, y), 0);
      break;
    // Add fast particles
    case 'f':
      particleController.addParticles(2, new PVector(x, y), 1);
      break;
    // Add triangle particles
    case 't':
      particleController.addParticles(2, new PVector(x, y), 2);
      break;
    // Add sine wave modulated square particles
    case 's':
      particleController.addParticles(2, new PVector(x, y), 3);
      break;
    // Add circle moulated square particles
    case 'c':
      particleController.addParticles(2, new PVector(x, y), 4);
      break;

    // In case a different key pushed
    default:
      particleController.addParticles(2, new PVector(x, y), frameCount%5);
      break;
    }
  } 
  // If no key
  else if (!keyPressed) {
    // Run through all the types of particles, one type per frame
    int type = frameCount%5;  // Modulo with the number of particle
    particleController.addParticles(2, new PVector(x, y), type);// And make some more
  }
}

// Reset the interactor mouseOvers just in case
void mouseReleased() {
  particleController.att.mouseOver = false;
  particleController.rep.mouseOver = false;
}


