import gifAnimation.*;

Gif myAnimation;

//'true' allows manual advancing through gif frames with left and right arrows
//'false' loops through gif
boolean manual = false;


// 2D Array of objects for pixel grid
Cell[][] grid;

// Global var for resolution of pixels
int res = 10;

//Global vars to crop section of gif
//TODO: Leave at 0 until canvas dynamic resizing works, add support for padding right and bottom
int column_pad = 0;
int row_pad = 0;

//import source gif 
//todo: allow import from URL
String sourceFile = "out.gif";



void settings() {
  myAnimation = new Gif(this, sourceFile);
  //ugly workaround to set size of canvas to match source gif, apparently the only way to do this in Processing is via 'settings()'
  PImage[] allFrames = myAnimation.getPImages();
  int w = ((allFrames[1].width) - (column_pad * res));
  int h = ((allFrames[1].height) - (row_pad * res));
  size(w, h);
  print("Width:", w, "Height:", h);
}

void setup() {

  //setup to determine grid granularity, has to be in setup loop
  myAnimation = new Gif(this, sourceFile);
  //Because gif.Animation needs to be called inside setup() I have to declare all this over again because variables in setup() can't be global
  PImage[] allFrames = myAnimation.getPImages();
  int w = (allFrames[1].width) - (column_pad * res);
  int h = (allFrames[1].height) - (row_pad * res);
  int cols = w/res;
  int rows = h/res;


  grid = new Cell[cols][rows];
  for (int i = column_pad; i < cols; i++) {
    for (int j = row_pad; j < rows; j++) {
      grid[i][j] = new Cell(i*res, j*res, res, res);
    }
  }
}

void draw() {

  //Finally, have to do this again because of the global variable problem...
  PImage[] allFrames = myAnimation.getPImages();
  int w = (allFrames[1].width) - (column_pad * res);
  int h = (allFrames[1].height) - (row_pad * res);
  int cols = w/res;
  int rows = h/res;

  int z = myAnimation.currentFrame();

  if (!manual) {  
    // create each frame
    for (int i = column_pad; i < cols; i++) {
      for (int j = row_pad; j < rows; j++) {
        grid[i][j].display();
        println(grid[i][j]);
        myAnimation.play();
      }
    }
  } else {
    // press left and right keys to advance frames
    for (int i = column_pad; i < cols; i++) {
      for (int j = row_pad; j < rows; j++) {
        if (keyPressed) {
          if (key == CODED) {
            if (keyCode == RIGHT) {
              grid[i][j].display();
              //TODO: figure out how to compare frames and spit out the delta so I know which pixels to change
              //String colorDelta = grid[i][j].colorGrid();
              //
              myAnimation.jump(z + 1);
            }
            //gif.Animation appears to protect against .jump() exceeding the max length of the array
            //but you'll get an out of bounds exception for negative array indices, thus the ' && (myAnimation.currentFrame() > 0' hack
            if ((keyCode == LEFT) && (myAnimation.currentFrame() > 0)) {
              grid[i][j].display();
              myAnimation.jump(z - 1);
            }
          }
        }
      }
    }
  }
}

class Cell {
  // A cell object knows about its location in the grid 
  // as well as its size with the variables x,y,w,h
  int x, y;   // x,y location
  int w, h;   // width and height

  // Cell Constructor
  Cell(int tempX, int tempY, int tempW, int tempH) {
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
  }


  void display() {
    fill(myAnimation.get(x+(w/2), y+(h/2)));
    rect(x, y, w, h); 
  }
  
   void colorGrid() {
     //prints hex value of each cell, top to bottom, left to right
     int cellColor = (myAnimation.get(x+(w/2), y+(h/2)));
     String colorValue = (hex(cellColor, 6));
     print(colorValue);
     //String [] colorValue = {(hex(cellColor, 6))};
     //print(colorValue[0]);
   }
  
}
