//code largely hijacked from @beesandbombs

int[][] result;
float t;

//aliases for older Processing push/pop functions

void push() {
  pushMatrix();
  pushStyle();
}

void pop() {
  popStyle();
  popMatrix();
}


void draw() {
  for (int i=0; i<width*height; i++)
    for (int a=0; a<3; a++)
      result[i][a] = 0;

  for (int sa=0; sa<samplesPerFrame; sa++) {
    t = map(frameCount-1 + sa*shutterAngle/samplesPerFrame, 0, numFrames, 0, 1);
    draw_();
    loadPixels();
    for (int i=0; i<pixels.length; i++) {
      result[i][0] += pixels[i] >> 16 & 0xff;
      result[i][1] += pixels[i] >> 8 & 0xff;
      result[i][2] += pixels[i] & 0xff;
    }
  }

  loadPixels();
  for (int i=0; i<pixels.length; i++)
    pixels[i] = 0xff << 24 | 
      int(result[i][0]*1.0/samplesPerFrame) << 16 | 
      int(result[i][1]*1.0/samplesPerFrame) << 8 | 
      int(result[i][2]*1.0/samplesPerFrame);
  updatePixels();

  saveFrame("../gifs/###.png");
  if (frameCount==numFrames)
    exit();
}

//////////////////////////////////////////////////////////////////////////////

int samplesPerFrame = 14;
int numFrames = 30;        
float shutterAngle = .6;

void setup() {
  size(800, 720, P3D);
  pixelDensity(2);
  smooth(8);
  result = new int[width*height][3];
  rectMode(CENTER);
  strokeWeight(4.8);
  fill(#111111);
}

float x, y, tt;
int N = 18;
float th, qq;
float h = 22, H = 4;
int nw = 10;


void wave(int q) {
  stroke(cs[(q+10)%3]);

  beginShape();
  //first set of lines
  for (int i=0; i<N; i++) {
    //qq and th are variables in lerp
    qq = i/float(N-2);
    th = TWO_PI*qq*nw + TWO_PI*t;
    //x,y inputs to vertex()
    x = lerp(-width*.7, width*.7, qq);
    y = -H + h*sin(th) + h*.05*sin(3*th);
    vertex(x, y);
  }
  //offset copy of lines
  for (int i=0; i<N; i++) {
    qq = 1-i/float(N-1);
    th = TWO_PI*qq*nw + TWO_PI*t;
    x = lerp(-width*.6, width*.6, qq);
    y = H + h*sin(th) + h*.05*sin(2*th);
    vertex(x, y);
  }
  endShape();
}

//colors in array
color[] cs = { #CFFF9E, #ED79F4, #0892D0 };

void draw_() {
  background(#111111); 
  push();
  //arbitrary design choices for diagonal, offest effect
  translate(width/3, height/3.5);
  rotate(-TWO_PI/11);
  //number of waves/lines
  for (int i=-2; i<48; i++) {
    push();
    translate(1, 3.2*i*H);
    wave(i);
    pop();
  }
  pop();
}