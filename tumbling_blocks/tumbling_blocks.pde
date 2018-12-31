// Tumbling blocks

// This is not quite done.  Following is a list of todos:
//
// 1. Draw each column full across the canvas once, then in randomly descending order to create step pattern
//
// This is *almost* implemented as desired but due to the nature of how I am drawing columns/rows using random()
// some ancestors (columns in the background) can be shorter than those in the foreground.  It would be ideal to 
// have neighbors always "step down", making it illegal for two adjacent blocks to share the same height.
//
// To do this is quite tricky (I think) as you have to keep track of the highest position in each column 
// and make sure the neighbor is either higher or lower depending on what row it is in.
//
// 2. Have column color programmatically distributed
//
// Right now the color patterns are just repeating.  Ideally a bag of colors would be randomly pulled from until
// exhausted, then repeated, with the rule that no columns of the same color can (significantly) border each other.
//
// 3. Draw one block or column at a time, animate
//
// This would be a lot more interesting if each column grew a block at a time, growing from the bottom, then
// repeating as an animation.  However, due to the nature of Processing's draw() loop it would not be trivial 
// to refactor this sketch as written--moving on to other ideas, may come back to this someday.
//
// 4.  Automatically make size() perfect multiple of cubesize
// 
// size() should be a programmatically determined perfect multiple of `xvalue` and `yvalue`
// Processing makes this quite difficult.  Or my OOP skills suck.  Probably the second more than the first.
//
// 5. `cols` and `rows` should be automatically inferred
//
// I have no idea why, but `cols` and `rows` aren't calulating correctly and must be manually set.  
// They do calculate correctly if you print them when decalred but in the loop they are a much lower value.
//
// 6. Automatic color palletes
//
// The colors here are very clown car.  Probably can fix this with random HSB starting values for each color or leveraging opacity. 


//Empty array of Blocks
Block[][] blocks;

int cubesize = 30;
//int cols = width/cubesize;  < These don't work in the loop below as you'd think
//int rows = height/cubesize;
int cols = 13;
int rows = 21;
float xvalue = (2* (cubesize * -cos(PI/6)));
float yvalue = (2*((cubesize * -sin(PI/6))));

//Three arrays of colors, one for each cube face
//There's probably a better way to access all colors in a single array (hashmap, etc) but my approaches were all too clever
color [] facetcolor1 = {#B61827, #00600F, #c67100, #001970, #373737};
color [] facetcolor2 = {#EF5350, #388E3C, #ffa000, #303f9f, #616161};
color [] facetcolor3 = {#FF867C, #6ABF69, #ffd149, #666ad1, #8e8e8e};


void setup() {
  background(50);
  size(623, 600);
  println(xvalue, yvalue);
  println(cols, rows);
  blocks = new Block[cols][rows];
}

void draw() {
  noLoop();
  background(50);
  translate(width, height + (yvalue/2));
  
  //z = # of descending steps
  //x = columns (width)
  //y = rows (height)
  
  for (int z = 0; z < 18; z = z + 3) {
    for (int x = 0; x < cols; x++ ) {
     for (int y = 0; y < (rows - (z * random(1, 1.8))); y++){
        blocks[x][y] = new Block(facetcolor1[x % facetcolor1.length], facetcolor2[x % facetcolor2.length], facetcolor3[x % facetcolor3.length], (x * xvalue), (y * yvalue), (cubesize * -cos(PI/6)), (cubesize * -sin(PI/6)), 0.0, (2 *(cubesize * -sin(PI/6))), (cubesize * cos(PI/6)), (cubesize * -sin(PI/6)), 0.0, 0.0);
        println("Column: " + x, "Row: " + y);
        push();
        if (z % 2 == 0) {
          int shiftColor = (x + 2) % facetcolor1.length;
          blocks[x][y] = new Block(facetcolor1[shiftColor % facetcolor1.length], facetcolor2[shiftColor % facetcolor2.length], facetcolor3[shiftColor % facetcolor3.length], (x * xvalue), (y * yvalue), (cubesize * -cos(PI/6)), (cubesize * -sin(PI/6)), 0.0, (2 *(cubesize * -sin(PI/6))), (cubesize * cos(PI/6)), (cubesize * -sin(PI/6)), 0.0, 0.0);
          translate(xvalue/2, -yvalue/2);
        }
        blocks[x][y].move();
        blocks[x][y].drawcube();
        pop();
      }
    }   
    //offset every other z value by 50% width to create "Qbert" step offset
    if (z % 2 == 0) {
      push();
      translate(xvalue/2, -yvalue/2);
      pop();
    }
  }
}

class Block {
  //colors for each cube face
  color c1, c2, c3; 
  //offsets for moving cubes around the canvas
  float xOffset, yOffset;
  //coords for each point in the quad() used for each cube face
  float x1, y1, x2, y2, x3, y3, x4, y4;

  //Constructor, initializing variables.  Java-based languages are weird.
  Block(color c1_, color c2_, color c3_, float xOffset_, float yOffset_, float x1_, float y1_, float x2_, float y2_, float x3_, float y3_, float x4_, float y4_) {  
    c1 = c1_;
    c2 = c2_;
    c3 = c3_;
    xOffset = xOffset_;
    yOffset = yOffset_;
    x1 = x1_;
    y1 = y1_;
    x2 = x2_;
    y2 = y2_;
    x3 = x3_;
    y3 = y3_;
    x4 = x4_;
    y4 = y4_;
  }

  // draw three faces to create a cube
  void drawcube() {
    noStroke();
    rotate(radians(120));
    fill(c1);
    quad(x1, y1, x2, y2, x3, y3, x4, y4);
    rotate(radians(120));
    fill(c2);
    quad(x1, y1, x2, y2, x3, y3, x4, y4);
    rotate(radians(120));
    fill(c3);
    quad(x1, y1, x2, y2, x3, y3, x4, y4);  
    // print location, color
    println("X/Y offsets: ", xOffset, yOffset);
    println(hex(c1), hex(c2), hex(c3));
  }

//move block position 
  void move() {
    translate(xOffset, yOffset);
  }
}

//Classic fix to restore push() and pop() 
void push() {
  pushMatrix();
  pushStyle();
}

void pop() {
  popStyle();
  popMatrix();
}
