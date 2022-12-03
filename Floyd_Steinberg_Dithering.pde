/* FLOYD STEINBERG DITHERING ------------------------------------------------

In this example, we wil apply Floyd Steinberg Dithering to an image.
Check out my blog post:
        (updt)https://asanka.hashnode.dev/03-flocking-simulation-making-a-flock-of-boids
        (updt)https://asanka-sovis.blogspot.com/2022/05/03-flocking-simulation-making-flock-of.html
Coded by Asanka Akash Sovis

-----------------------------------------------------------------------------*/

PImage img;

int factor = 3;
boolean greyScale = false;

int[] xPos      = new int[]{+1, -1,  0, +1};
int[] yPos      = new int[]{ 0, +1, +1, +1};
int[] errFactor = new int[]{ 7,  3,  5,  1};

void setup() {
  size(1024, 512);
  
  noStroke();
}

void draw() {
  img = loadImage("image.jpg");
  
  if(greyScale)
    img.filter(GRAY);
  
  image(img, 0, 0);
  
  img.loadPixels();
  
  for (int y = 0; y < img.height-1; y++) {
    for (int x = 1; x < img.width-1; x++) {
      color pix = img.pixels[index(x, y)];
      
      float[] oldPixel = new float[]{red(pix), green(pix), blue(pix)};
      
      float[] newPixel = new float[3];
      
      for (int i = 0; i < 3; i++) {
        newPixel[i] = round(factor * oldPixel[i] / 255) * (255/factor);
      }
      
      img.pixels[index(x, y)] = color(newPixel[0], newPixel[1], newPixel[2]);

      float[] err = new float[]{oldPixel[0] - newPixel[0], oldPixel[1] - newPixel[1], oldPixel[2] - newPixel[2]};
      
      for (int i = 0; i < 3; i++) {
        int index = index(x + xPos[i], y + yPos[i]);
        img.pixels[index] = dither(index, img, err, errFactor[i]);
      }
    }
  }
  
  img.updatePixels();
  image(img, 512, 0);
  
  overlays();
  
  //saveFrame("Output\\Floyd_Steinberg_Dithering-" + frameCount + ".png"); // Saves the current frame. Comment if you don't need
}

int index(int x, int y) {
  return x + y * img.width;
}

color dither(int index, PImage img, float[] err, int errFactor) {
  color c = img.pixels[index];
  
  float[] pixel = new float[]{red(c), green(c), blue(c)};
  
  
  for (int i = 0; i < 3; i++) {
    pixel[i] = pixel[i] + err[i] * errFactor / 16.0;
  }
  
  return color(pixel[0], pixel[1], pixel[2]);
}

void overlays() {
  textAlign(LEFT);
  fill(50);
  rect(10, height - 50, 55, 13, 2);
  fill(100);
  rect(10, height - 50, (55 * factor) / 16, 13, 2);
  
  fill(255);
  textSize(10);
  text("Factor: " + factor, 13, height - 40);
  
  fill(50);
  rect(11, height - 30, 20, 8, 2);
  
  fill(100);
  rect(21 - int(greyScale) * 10, height - 30, 10, 8, 2);
  
  fill(200 - int(greyScale) * 100);
  textSize(10);
  text("Color", 37, height - 22);
  
  fill(#DBD9DA);
  textAlign(CENTER);
  textSize(30);
  text("FLOYD STEINBERG DITHERING", width / 2, 100);
  textSize(10);
  text("BY ASANKA SOVIS", width / 2, 120);
}

void mouseWheel(MouseEvent event) {
  factor += event.getCount();
  
  if(factor < 1) {
    factor = 1;
  } else if (factor > 16) {
    factor = 16;
  }
}

void mousePressed() {
  greyScale = !greyScale;
}
