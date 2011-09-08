class beziers {
  //global variables 
  int num, weight, spread;
  float c1x, c1y, c2x, c2y;
  PVector acceleration, velocity, location, direction;

  //constructor
  beziers(int number, int weightIn)
  {
    weight = weightIn;
    num = number;
    spread = height/number;//automatically spreads them out
    
    //intialise variables
    c1x = width/2;
    c1y = height/2;
    c2x = width/2;
    c2y = height/2;

    acceleration = new PVector (0, 0);
    velocity = new PVector (0, 0);
    location = new PVector (c1x, c1y);
    direction = new PVector(location.x, location.y);
  }

  void update(float colour)//actually draw the shapes
  {
    ellipse(c1x, c1y, 10, 10);//shape
    noFill();//no fill
    stroke(colour,colour,0, 40);//set colour
    strokeWeight(weight);//width
    for (int i = 0; i < num+1; i++)
    {
      bezier(0, spread*i, c1x, c1y, c2x, c2y, width, height-spread*i );
      bezier(spread*i, 0, c2x, c2y, c1x, c1y, width-spread*i , height);
    }//draw shapes and spread them out
  }
 
  //to move control points
  void bend(float accelMax, float c2xIn, float c2yIn)
  {
    
    acceleration = direction;//set direction of acceleration vector
    acceleration.normalize();//set acceleration to 1
    acceleration.mult(random(accelMax));//scale to an input value

    velocity.add(acceleration);//a = v/t
    velocity.limit(4);//topspeed
    location.add(velocity);//v = d/t

    c1x = location.x;
    c1y = location.y;//control point 1 chases the input
    c2x = c2xIn;
    c2y = c2yIn;//control point 2 is the input
    
    if (c1x > width || c1x < 0)
    {
       velocity.x *= -1; 
    }
    if (c1y > height || c1y < 0)
    {
       velocity.y *= -1; 
    }//edge detection and reflection
  }
  
  void directionSet(PVector input)
  {
      direction.x = input.x-location.x;
      direction.y = input.y-location.y;
  }//set direction of the acceleration control point
}

