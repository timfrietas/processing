//TODO:

//--So many nested loops.  Can probably fix that now that it is working.
//--Colors still determined by x or y value.  Distributing them more randomly is more challenging but may be interesting
//--Need to tune scale() sine wave to get perfect loop
//--Add delay between twists



//globals
int tilesize = 20;
int tilecenter = tilesize/2;
int[] colors = {#d081dc, #f6f983, #3d9df3, #2d8bde, #662d62, #56cde7, #377003, #ed2551, #f47fe1, #f7ba20, #ccc020, #7c7b68};

//setup
void setup() {
  background(10);
  size(640, 640, P3D);
  smooth(8);
}

//draw

void draw() {
  //noLoop();
  background(10);
  noStroke();

  //tile offsetting--does this belong in a loop below?
  translate(tilesize * 4+ tilecenter, tilecenter);

  //Throwaway patch for initialization
  Patch patch = new Patch(colors[0], (tilesize), (tilesize), -(tilecenter), -(tilecenter), -(tilecenter), tilecenter, tilecenter, -(tilecenter)); 
  
  //loop to flip the rows  <--should probably refactor this to support arbitrary canvas height
  for (int i=0; i <= 3; i++) {
    //loop to transpose whole tiles into rows <--should probably refactor this to support arbitrary canvas width
    for (int j=0; j <= 3; j++) {
      patch.wholetile(4, 4);
      translate(tilesize * 8, 0);
    }
    //flip rows
    translate(-tilesize*32, tilesize * 8);
    //rotateZ(radians(180));
  }
  delay(40);
}

class Patch {
  //patch color
  color c1;
  //offsets for starting points of each triangle
  float xOffset, yOffset;
  //Traingle coordinates
  float x1, y1, x2, y2, x3, y3;

  //Constructor
  Patch(color c1_, float xOffset_, float yOffset_, float x1_, float y1_, float x2_, float y2_, float x3_, float y3_) {
    c1 = c1_;
    xOffset = xOffset_;
    yOffset = yOffset_;
    x1 = x1_;
    y1 = y1_;
    x2 = x2_;
    y2 = y2_;
    x3 = x3_;
    y3 = y3_;
  }

  void drawpatch () {
    noStroke();
    fill(c1);
    triangle(x1, y1, x2, y2, x3, y3);
  }

  //move triangle 
  void move() {
    translate(xOffset, yOffset);
  }

  //triangle orientation
  void flip(int deg) {
    rotate(radians(deg));
  }

  //triangle orientation
  void turn(int deg) {
    rotateZ(radians(deg));
  }

  //Draw 4x4 quarter tile, excluding select triangles
  void quartertile(int a, int b) {
    for (int x=0; x < a; x++) {
      for (int y=0; y < b; y++) {
        //hack to print only the proper triangles in the inner tile
        if ((x+y) > 0 && (x+y) < 5) {
          push();
          Patch patch = new Patch(colors[y], (x * tilesize), (y * tilesize), -(tilecenter), -(tilecenter), -(tilecenter), tilecenter, tilecenter, -(tilecenter)); 
          patch.move();
          patch.turn(0+frameCount%360);  //< rotate group is nice transition effect
          scale(0.75+sin(frameCount*0.1)*0.25);
          patch.drawpatch();
          pop();
        }
      }
    }
  }

  //Translate quartertile once to create half tile
  void halftile(int a, int b) {
    for (int z=0; z <= 1; z++) {
      quartertile(a, b);
      translate(tilesize * 3, tilesize * 4);
      rotateZ(radians(90));
    }
  }

  //Translate half tile once more to become whole
  void wholetile(int a, int b) {
    for (int k=0; k <= 1; k++) {
      halftile(a, b);
    }
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

//If it is possible to create a function out of this to call between rotations to randomize the color array
//Well, it'd be pretty nice

//for (int i=colors.length-1; i > 0; i--) {
//       int r = int(random(i));
//       int save = colors[i];
//       colors[i] = colors[r];
//       colors[r] = save;
//     }
