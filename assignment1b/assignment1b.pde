//Global variables
int count, t;
float i, x, y, x2, y2;

// initialise classes
wavy wave1;
wavy wave2;
wavy wave3;
wavy wave4;

void setup()
{
  size(200, 200);//set size
  frameRate(25);//set framerate
  smooth();//smooth it out
  t = 10;//seems to be a good value 
  
  wave1 = new wavy(0,0,200,200,5,5,100,0);
  wave2 = new wavy(0,0,200,200,5,5,100,1);
  wave3 = new wavy(0,0,200,200,5,5,100,2);
  wave4 = new wavy(0,0,200,200,5,5,100,3);//get our bendy lines going
}

void draw() {
  background(255);//white is nice

  x = ((100-t)*cos(i))+(t*(cos(((100+t)/t)*i)))+100;//Parametric equation for a hypocycloid
  y = ((100-t)*sin(i))-(t*(sin(((100+t)/t)*i)))+100;//with a few variables ready to change 
  
  x2 = ((100-t)*cos(i))+(t*(cos(((100-t)/t)*i)))+100;//Parametric equation for an epicycloid
  y2 = ((100-t)*sin(i))-(t*(sin(((100-t)/t)*i)))+100;//for a bit of variation, will be similar 
                                                     //for low t values, get more different as t rises
  
  wave1.update(x, y, x2, y2);//move the control points of our beziers with
  wave2.update(x, y, x2, y2);//the equations above
  wave3.update(x, y, x2, y2);
  wave4.update(x, y, x2, y2);
  
  stroke(0,0,255,100);//blue will stand out a bit
  strokeWeight(7);//thick to be seen
  line(x, y,x2,y2);//track control points with a line between them
  
  stroke(0);  //black
  strokeWeight(2);//thin again
  rect(0, 0, 199, 199);//add a border
  
  if (count <250) {
    i = i+.05;//i goes up, makes control points trace curves
  }
  else {
    i = i-.05;//and then back down
  }
  if (count > 500) {
    count = 0;
    t=t+7;//advance t to change the shape of curves
  }
  if (t >80) {
    t = 20;//t goes back down abruptly
  }
  count++;//count needs to move 
}

