
class triForce {

  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector dir;//PVectors are super useful
  float topspeed, banana, high;//variables
  float mousePos[] = new float[2];//to store the last mouse position
  int big, R, G, B;//some variables for the drawing

  triForce() {


    R = 117;
    G = 121;
    B = 0;//gold, as the triforce should be

    big = 8;
    high = big*sin(radians(60));//for drawing triangles

    location = new PVector(random(big+1, width-(big+1)), random(high+1,height+high*2));
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    dir = new PVector(0, 0);//initialise PVectors so object is stationary and at a random point halfway down
    topspeed = 6;
    banana = .5;//set speed and acceleration
    mousePos[0] = location.x;
    mousePos[1] = location.y;//ensure they begin stationary and not moving to 0,0
  }

  void update(int keypress, int sizein) {
    if (keypress > 0)
    {
      display(sizein);//make pictures happen

        PVector goal = new PVector(mousePos[0], mousePos[1]);    
      dir = PVector.sub(goal, location); //get direction

        acceleration = dir;//accelerate to direction
      acceleration.normalize();//set accel to 1
      acceleration.mult(random(banana));//scale 

      velocity.add(acceleration);//a = change in velocity over time
      velocity.limit(topspeed);//limit velocity 
      location.add(velocity);//v = change in location (distance) over time
      velocity.mult(.94);//damp velocity so they eventually converge
    }
  }

  void display(int sizeinput) {
    big = sizeinput;//this will let the slder value determine how big the triangles are
    high = big*sin(radians(60));//this keeps the proportions
    fill(R, G, B, 50);//fill with our colours
    float x = location.x;
    float y = location.y;//trying to get my edge collisions to work. Still doesn't.
    pushMatrix();//store current matrix pos
    triangle(x, y, x-(big/2), y+high, x+(big/2), y+high);  //draw top triangle

    translate((-big/2), high);//move matrix left and down
    triangle(x, y, x-(big/2), y+high, x+(big/2), y+high); //draw new triangle
    popMatrix();//restore matrix

      pushMatrix();//for some reason it gets unhappy without this
    translate((big/2), high);//move down and right
    triangle(x, y, x-(big/2), y+high, x+(big/2), y+high); //last triangle
    popMatrix();//back to normal
  }

  void edgeCheck(PVector check) {
    PVector checkV;

    checkV = PVector.sub(check, location);
    //check agains another object, still not quite perfect
    float x = checkV.x;
    float y = checkV.y+(1.5*high);//move to centre of shape

    if (sqrt(sq(x)) + sq(y) < big) {//if they collide with a circle around the centre
      velocity.mult(-1); //invert velocity
    }
  }
  void borderCheck() {
    //border checks & reflection
    if (location.x+big > width || location.x-big < 0) {//if too wide, invert x velocity
      velocity.x *=  -1;
    }    
    if (location.y+(2*high) > height || location.y < 0) {
      velocity.y *= -1;
    }
  }

  void click(float x, float y) {
    mousePos[0] = x;
    mousePos[1] = y;//set target location into the array
  }

  float getLocationX() {
    return(location.x);//fairly apparent
  }
  float getLocationY() {
    return(location.y);
  }
  float getVelocity() {
    return(velocity.mag());
  }
  PVector getLocationV() {
    return(location);
  }
}

