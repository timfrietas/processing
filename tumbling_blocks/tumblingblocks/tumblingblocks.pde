int cubesize = 30;

float xvalue = (2* (cubesize * -cos(PI/6)));
float yvalue = (2* (cubesize * -sin(PI/6)));


float x1 = (cubesize * -cos(PI/6));
float y1 = (cubesize * -sin(PI/6));
float x2 = 0.0;
float y2 = (2 *(cubesize * -sin(PI/6)));
float x3 = (cubesize * cos(PI/6));
float y3 = (cubesize * -sin(PI/6));
float x4 = 0.0;
float y4 = 0.0;

//offset values used to move cubes in main drawRows () function
float yOffset = -yvalue*1.49;
float xOffset = 1.52; //these are magic numbers, neeed to figure out the trig still


//Array of colors for each side
color [] blockcolors = {#FF373737, #FF616161, #FF8E8E8E};

void setup() {
  background(255);
  //Lame size() cannot take variables and must take ints.  
  //I'd love a perfectly sized canvas based on the adtual width of N "cubes"
  size(623, 600, P3D);
  smooth(18);
  println(xvalue, yvalue);
}

void draw() {
  noLoop();
  //set initial top right drawing position
  translate(width - xvalue/2, cubesize/2);
  drawRows();
}

void drawRows() {
  for (int k = 1; k < 8; k++) {
    for (int i = 0; i < 13; i++) {
      placeBlock();
      setupRow();
    }

    translate(width - xvalue * (xOffset), (yOffset));
  
    for (int j = 0; j < 13; j++){
    setupRow();
    placeBlock();
    }

    translate(width - xvalue/2, abs(yOffset));
  }
}
 

void placeBlock() {
  for (int i =0; i < blockcolors.length; i++) {
    noStroke();
    rotate(radians(120));
    fill(blockcolors[i]);
    quad(x1, y1, x2, y2, x3, y3, x4, y4);
    println(hex(blockcolors[0]), hex(blockcolors[1]), hex(blockcolors[2]));
 }
}
  void setupRow() {
  translate(xvalue, 0);
 }
 
 void moveBlock() {
   translate(xvalue/2, -yvalue/2 + cubesize);
 }
 
 
