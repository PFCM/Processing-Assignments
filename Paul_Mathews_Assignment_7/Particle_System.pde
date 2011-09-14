/* A class to manage our particles */
class ParticleSystem {
  ArrayList<Particle> particleList = new ArrayList<Particle >(); // Arraylist for the particles
  Interactor att, rep; // Some interaction
  PVector gravity;  // Unavoidable really

  // Will send osc from here as want direct access to the particles
  OscP5 oscP5;  // Set up osc
  NetAddress myRemoteLocation;
  
  ParticleSystem() {
    // Construct the interactors, one with a positive force one with a negative
    att = new Interactor(new PVector(width/2+100, height/2), 100, 0, 0, 255);
    rep = new Interactor(new PVector(width/2-100, height/2), -100, 0, 255, 0);

    oscP5 = new OscP5(this, 12001); // Initialise OSC, give it a listen port
    myRemoteLocation = new NetAddress("127.0.0.1", 12000); // Init send

    // Gravity
    gravity = new PVector(0, .1);
  }

  void update() {
    // Run through the particles, update and check the edges
    Iterator<Particle> p = particleList.iterator(); // To count for us

    while (p.hasNext ()) { // and we're off
      Particle part = p.next();// set up the next

        if (part.isDead) { // No point keeping the dead around
        p.remove();
      } 
      // But for the living
      else {
        // Add up the forces to act on this particle
        PVector aggregate = PVector.add(att.influence(part.loc), rep.influence(part.loc));
        // Update it
        part.update(PVector.add(aggregate, gravity));

        // Finally, check if we need to reflect
        if (part.loc.x > width) {      // Check boundary, right
          part.loc.x = width-1;  // Reset, helps avoid bugs at high velocities
          part.vel.x *= -random(0.7, 1);// damp on reflection for realism
        } 
        if (part.loc.x < 0) {          // Check boundary, left
          part.loc.x = 1;
          part.vel.x *= -random(0.7, 1);
        }
        if (part.loc.y > height) {     // Check boundary, bottom
          part.loc.y = height-1;
          part.vel.y *= -random(0.7, 1);
          oscSendCol(part.version);
        }
        if (part.loc.y < 0) {          // Check boundary, top
          part.loc.y = 1;
          part.vel.y *= -random(0.7, 1);
        }
      }
    }
    // Update interactors, outside the loops, we only need it to happen once per call
    att.update();
    rep.update();
  }

  // Actually draw the system
  void draw() {
    att.draw(); // Start with the interactors, then the particles 
    rep.draw(); // will be drawn over the top
    Iterator<Particle> p = particleList.iterator();  // Another iterator, to iterate throught the list
    while (p.hasNext ()) { // Run through list
      p.next().draw();     // and draw this time
    }
  }

  // Function to add particles to the list
  //        takes amount, starting location and type of particle (as an int)
  void addParticles(int amt, PVector startPos, int type) {
    // Do it the amount of times specified
    for (int i = 0; i < amt; i++) {
      // store a random offset for each one
      PVector rand = new PVector(random(10), random(10));

      // Easier than a lot of if else
      switch(type) {
        // Standard particles
      case 0:
        particleList.add(new Particle(PVector.add(startPos, rand)));
        break;
        // Fast Particles  
      case 1:
        particleList.add(new FastParticle(PVector.add(startPos, rand)));
        break;
        // Triangles
      case 2:
        particleList.add(new TriParticle(PVector.add(startPos, rand)));
        break;
        // Wavy Squares
      case 3:
        particleList.add(new SineParticle(PVector.add(startPos, rand)));
        break;
        // Fluttery Squares
      case 4:
        particleList.add(new SineCosParticle(PVector.add(startPos, rand)));
        break;
        // In case something goes wrong, just add basic ones
      default:
        particleList.add(new Particle(PVector.add(startPos, rand)));
        break;
      }
    }
  }

  void oscSendCol(int i) {
    OscMessage myMessage = new OscMessage("/collision"); // New message and address pattern
    myMessage.add(i); // Add input, just sending one int at time on bottom collision
    oscP5.send(myMessage, myRemoteLocation); // Sendprintln("sent");
  }
}

