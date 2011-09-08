/* If I use this again I'll probably put most of it into a parent class
and have a couple of children for the different shapes and behaviours, but
for now this works fine. */

class Mover
{
  // Global Variables
  float topSpeed, topAcceleration, theta, rad;
  PVector  centre, destination, direction, acceleration, velocity, location;
  String type;
  int colourMode;
  boolean mouseOver;

  // Constructor
  Mover (float speedLimit, float accelLimit, float initX, float initY, String typeInput, int colourModeIn, float thetaIn)
  {
    // Motion constants
    topSpeed = speedLimit;
    topAcceleration = accelLimit;

    // Motion vectors
    destination = new PVector(initX, initY);
    direction = new PVector(initX, initY);
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    location = new PVector(initX, initY);
    centre = new PVector(0, 0);
    
    // Misc variables
    type = typeInput;
    theta = thetaIn;
    colourMode = colourModeIn;
    rad = 15;// Constructor already too big and I don't really want to change this
  }
  
  // Update function to call every frame
  void update(int[] input)
  {
    // Movement
    direction = PVector.sub(destination, location);// Get direction
    acceleration = direction;// Set direction of acceleration
    acceleration.normalize();// Set acceleration to 1 for scaling
    acceleration.x *= (random(topAcceleration/2, topAcceleration));// Scale
    acceleration.y *= (random(topAcceleration/2, topAcceleration));// Scale
                          // Random gives more organic movement               

    velocity.add(acceleration);// Advance velocity by acceleration
    velocity.limit(topSpeed);// Constrain velocity
    if (type.equals("CIRCLE")) velocity.mult(.9);// Damp velocity (friction)
    else if (type.equals("LINE")) velocity.mult(.99);// Less so for lines

    location.add(velocity);// Advance location by velocity

    edgeCheck();// Check if reflection is necessary
    render(input);// Draw
  }

  // Drawing
  void render(int[] input)
  {
    // Lines
    if (type.equals("LINE"))// .equals rather than == for string comparison because == wil compare memory addresses not contents according to processing reference
    {
      // Set colour depending on colourMode 
      // Colour changes if close enough to centre
      // Have input array determine distance from centre color changes
      if (colourMode == 0)
      { 
        if (sqrt(sq(centre.x-location.x) + sq(centre.y-location.y)) < random(input[0]))
        {
          stroke(0, 255, 255, 127);
        } 
        else
        {
          stroke(0, 100, 255, 25);
        }
      }
      else if (colourMode == 1)
      {
        if (sqrt(sq(centre.x-location.x) + sq(centre.y-location.y)) < random(input[1]))
        {
          stroke(0, 100, 255, 127);
        }
        else
        {
          stroke(255, 255, 255, 25);
        }
      }
       else if (colourMode == 2)
      {
        if (sqrt(sq(centre.x-location.x) + sq(centre.y-location.y)) < random(input[2]))
        {
          stroke (255, 255, 255, 127);
        }
        else
        {
          stroke(0, 255, 255, 25);
        }
      }
        else if (colourMode == 3)
      {
        if (sqrt(sq(centre.x-location.x) + sq(centre.y-location.y)) < random(input[3]))
        {
          stroke (255, 255,0, 127);
        }
        else
        {
          stroke(255, 0, 0, 25);
        }
      }
      // Draw
      line(location.x, location.y, destination.x, destination.y);
     } 
     // Set colour for circles
    else if (type.equals("CIRCLE"))
    {
      noStroke();
      if (colourMode == 0) fill(255, 0, 0, 50);
      else if (colourMode == 1) fill (255, 255, 0, 50);
      else if (colourMode == 2) fill (0,255,0,50);
      else if (colourMode == 3) fill (0,0,255,50);
      ellipse(location.x, location.y, rad, rad);//draw
    }
  } 

  // Check edges
  void edgeCheck()
  {
    if (location.x > width)
    {
      location.x = width-1;// Set location to inside view or can get stuck if speed is too high
      velocity.x *= -1;// Reverse relevant component of velocity vector
    } 

    if (location.x < 0)
    {
      location.x = 1;
      velocity.x *= -1;
    }

    if (location.y > height)
    {
      location.y = height-1;
      velocity.y *= -1;
    }

    if (location.y < 0)
    {
      location.y = 1;
      velocity.y *= -1;
    }
  }

  // Set direction for movement
  void setDirection(float x, float y)
  {
    // Fill in centre vector
    centre.x = x;
    centre.y = y;
    
    // Make shapes depending on the colourMode
    if (colourMode == 0)
    {
      destination.x = x+(width/8*(sin(11*theta) * cos(theta)));
      destination.y = y+(height/8*(sin(7*theta) * sin(theta)));
    } 
    else if (colourMode == 1) 
    {
      destination.x = x+(width/8*(sin(7*theta) * cos(theta)));
      destination.y = y+(height/8*(sin(5*theta) * sin(theta)));
    } 
    else if (colourMode == 2)
    {
      destination.x = x+(width/8*(sin(5*theta) * cos(theta)));
      destination.y = y+(height/8*(sin(9*theta) * sin(theta)));
    } 
    else if (colourMode == 3)
    {
      destination.x = x+(width/8*(sin(5*theta) * cos(theta)));
      destination.y = y+(height/8*(sin(13*theta) * sin(theta)));
    }
  }

  // Bump
  void bump(float value)
  {
    velocity.mult(value);
  }
  
  // Check for mouseover
  void mouseCheck(float x, float y)
  {
     if (sqrt(sq(x-location.x) + sq(y - location.y)) < rad) // If distance from location is less that the radius, mouse is over
    {
       mouseOver = true;
       cursor(CROSS);// May as well
    } else
    {
       mouseOver = false; 
    }
  }
}

