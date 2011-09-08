
class triForce {

  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector dir;//PVectors are super useful
  float topspeed, banana,high;//variables
  float mousePos[] = new float[2];//to store the last mouse position
  int big,R,G,B;//some variables for the drawing

  triForce() {
    location = new PVector(random(width/2), height/2);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    dir = new PVector(0, 0);//initialise PVectors so object is stationary and at a random point halfway down
    topspeed = 5;
    banana = .5;//set speed and acceleration
    mousePos[0] = location.x;
    mousePos[1] = location.y;//ensure they begin stationary and not moving to 0,0
    
    R = int(random(255));
    G = int(random(255));
    B = int(random(255));//random colours
    
    big = 12;
    high = big*sin(radians(60));//for drawing triangles
  }

  void update() {
    
    display();//make pictures happen

    PVector goal = new PVector(mousePos[0], mousePos[1]);    
    dir = PVector.sub(goal, location); //get direction

    acceleration = dir;//accelerate to direction
    acceleration.normalize();//set accel to 1
    acceleration.mult(random(banana));//scale 

    velocity.add(acceleration);//a = change in velocity over time
    velocity.limit(topspeed);//limit velocity 
    location.add(velocity);//v = change in location (distance) over time
    
  }

  void display() {
    fill(R,G,B);//fill with our colours
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
    
   checkV = PVector.sub(check,location);
    
    float x = checkV.x;
    float y = checkV.y+(1.5*high);//move to centre of shape
    
    if (sqrt(sq(x)) + sq(y) < big){//if they collide with a circle around the centre
     velocity.mult(-1); //invert velocity
     oscCollision();//send a message
     R = int(random(255));//redo colours
    G = int(random(255));
    B = int(random(255));
    }
    
    //border checks & reflection
    if (location.x > width || location.x < 0) {//if to wide, invert x velocity
      velocity.x *=  -1;//for some reason these stopped working when I started using triangles (I was using ellipse earlier)
     oscCollision();
    }    
    if (location.y > width || location.y < 0) {
      velocity.y *= -1;
     oscCollision();
    }//removed the message, original intent was for this to be like when they collide with each other, but when it stopped working it just meant a message was sent 30 times a second which was not so much fun
  }

  void click() {
    mousePos[0] = mouseX;
    mousePos[1] = mouseY;//set target location into the array
  }
  
  float getLocationX(){
    return(location.x);//fairly apparent
  }
  float getLocationY(){
    return(location.y);
  }
  float getVelocity(){
    return(velocity.mag());
  }
  PVector getLocationV(){
    return(location);
  }
  
  void oscCollision(){//when they collide
    OscMessage myMessage = new OscMessage("/collision");//new message
    myMessage.add(R);//add red value for a bit of difference between shapes
    oscP5.send(myMessage, myRemoteLocation);//send
}
}

