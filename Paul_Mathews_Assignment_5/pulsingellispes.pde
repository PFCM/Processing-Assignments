class pulsingEllipses
{
  //global variables
  int boundaryX, boundaryY;

  //constructor
  pulsingEllipses(int xin, int yin)
  {
    //set variables
    boundaryX = xin;
    boundaryY = yin;
  }

  //make the shapes
  void update(float colIn, float sizeIn)
  {
    stroke(0);//set outline colour
    strokeWeight(1);//and width
    
    //fill varies with an input variable
    fill(0, 100, 255 - colIn*2, colIn);
    //draw one ellipse, middle at centre, scale y width the most
    ellipse(boundaryX/2, boundaryY/2, boundaryX - sizeIn*10, sizeIn*60);
    //change colour
    fill(100, 255 - colIn*2, 0, colIn);
    //draw other ellipse, middle at centre, scale x width the most
    ellipse(boundaryX/2, boundaryY/2, sizeIn*60, boundaryY - sizeIn*10);
  }
}

