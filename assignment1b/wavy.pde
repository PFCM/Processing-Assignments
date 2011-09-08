class wavy {

  //global variables
  float x1, y1, x2, y2, xRange, yRange, xSpacing, ySpacing;
  int num, thick, transparency;
  float [][] coords = new float [50][4];//2D array, I know how big I will want it


  //constructor
  wavy(float topLeftX, float topLeftY, float bottomRightX, float bottomRightY, int numberOfCurves, int weight, int alph, int orientation) {
    fill(0,0);//transparency is most important
    thick = weight;
    transparency = alph;
    x1 = topLeftX;
    y1 = topLeftY;
    x2 = bottomRightX;
    y2 = bottomRightY;//setting variables
    
    xRange = x2 - x1;
    xSpacing = xRange/numberOfCurves;
    yRange = y2 - y1;
    ySpacing = yRange/numberOfCurves;//getting some more info
    
    num = numberOfCurves;//need to produce the specified number
    
//time to fill the array
    if (orientation == 0) {//top to bottom
      for (int i = 0; i < num; i++) {
        coords[i][0] = topLeftX+(i*xSpacing);//start x
        coords[i][1] = topLeftY;//start y
        coords[i][2] = topLeftX+(i*xSpacing);//start x
        coords[i][3] = bottomRightY;//start y
      }
    }
    if (orientation == 1) {//top to left
      for (int i = 0; i < num; i++) {
        coords[i][0] = topLeftX+(i*xSpacing);//start x
        coords[i][1] = topLeftY;//start y
        coords[i][2] = topLeftX;//end x
        coords[i][3] = topLeftY+(i*ySpacing);//end y
      }
    }
    if (orientation == 2) {//bottom to right
      for (int i = 0; i < num; i++) {
        coords[i][0] = bottomRightX-(i*xSpacing);//start x
        coords[i][1] = bottomRightY;//start y
        coords[i][2] = bottomRightX;//end x
        coords[i][3] = bottomRightY-(i*ySpacing);//end y
      }
    }
    if (orientation == 3) {//side to side
      for (int i = 0; i < num; i++) {
         coords[i][0] = topLeftX;
        coords[i][1] = topLeftY+(i*ySpacing);
        coords[i][2] = bottomRightX;
        coords[i][3] = topLeftY+(i*ySpacing);
      }
    }
  }
  void update(float cx1, float cy1, float cx2, float cy2 ) {//To draw things. Then re-draw.
    strokeWeight(thick);//thickness
    stroke(0, transparency);//grayness and alpha(bit of that makes it cooler when they overlap)
    
    for (int i = 0; i < num; i++) {//actually drawing
      bezier(coords[i][0], coords[i][1], cx1, cy1, cx2, cy2, coords[i][2], coords[i][3]);
      //draws as many as specified using the coordinates from the constructor and the control points given when this is called
    }
  }
}

