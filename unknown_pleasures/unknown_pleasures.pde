float xoff = 0;
float yoff = 0;
boolean make_gifs = true;
int numFrames = 60;

void setup() {
  size(600,800);
  strokeWeight(2);
  stroke(255);
  strokeJoin(ROUND);
  smooth();
}

void draw() {
  background(0);
  for(float y = height*0.2; y < height*0.9; y += 8) {
    pushMatrix();
    translate(0, y);
    fill(0);
    float peak = random(.3, .7);
    beginShape();
    for(float x = width*0.1; x < width*0.9; x++) {
      float ypos = map(noise(x/50 + xoff, y/10 + yoff), 0, 1, -80, 0);
      float wave = x < width*peak ? map(x, width*0.25, width*peak, 0, 1.6) : map(x, width*peak, width*0.75, 1.6, 0);
      ypos *= wave;
      if(ypos > 0) ypos = random(2);
      vertex(x, ypos);
    }
    endShape();
    popMatrix();
  }
  
  xoff += 0.001;
  yoff += -0.001;
  
 
  
  if (make_gifs) {
    saveFrame("../gifs/###.gif");
    if (frameCount==numFrames)
    exit();
  }
}
