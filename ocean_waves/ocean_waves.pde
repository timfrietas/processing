//TODO:

//--So many nested loops.  Can probably fix that now that it is working.
//--Colors still determined by x or y value.  Distributing them more randomly is more challenging but may be interesting
//--Animations can be achieved by applying a tranistion to patch.turn() or changing rotate between tile flips as commented below.
//  Ideally we would let things scale() in one state then move on to the next, and so on, until we can get a perfect loop.



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
  //translate(width/2+tilecenter, tilecenter);
  translate(tilesize * 4+ tilecenter, tilecenter);
  //loop to flip the rows
  for (int i=0; i <= 3; i++) {
    //loop to transpose whole tiles into rows
    for (int j=0; j <= 3; j++) {
      //translate half tile to become whole
      for (int k=0; k <= 1; k++) {
        //translate once to create half tile
        for (int z=0; z <= 1; z++) {
          //create quarter tile
          for (int x=0; x < 4; x++) {
            for (int y=0; y < 4; y++) {
              //hack to print only the proper triangles in the inner tile
              if ((x+y) > 0 && (x+y) < 5) {
                push();
                Patch patch = new Patch(colors[y], (x * tilesize), (y * tilesize), -(tilecenter), -(tilecenter), -(tilecenter), tilecenter, tilecenter, -(tilecenter)); 
                patch.move();
                //patch.turn(90);  //< rotate group is nice transition effect
                scale(0.75+sin(frameCount*0.1)*0.25);
                patch.drawpatch();
                //println(x * tilecenter, y * tilecenter);
                //println("X value: ", x);
                //println("Y value: ", y);
                pop();
              }
            }
          }
          //  Transpose to create tile
          translate(tilesize * 3, tilesize * 4);
          rotateZ(radians(90));
        }
        //translate(tilesize * 3, tilesize * 4);
        //rotateZ(radians(90)); //<This is super interesting if left on, could make awesome animation transition state
      }
      //create rows
      translate(tilesize * 8, 0);
      //rotateZ(radians(90));
    }
    //flip rows
    translate(-tilesize*32,tilesize * 8);
    //rotateZ(radians(180));
  }
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
