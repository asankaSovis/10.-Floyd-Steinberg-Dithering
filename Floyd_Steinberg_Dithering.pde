/* FLOYD STEINBERG DITHERING ------------------------------------------------

In this example, we wil apply Floyd Steinberg Dithering to an image. Floyd-Steinberg Dithering
is not just a fancy art style; it also has practical applications in the real world. More colours
can be created with a smaller colour palette. The Floyd-Steinberg Dithered image looks much
more natural because the dithering makes the missing colours in the palette appear in our brains.
Check out my blog post:
        https://asanka.hashnode.dev/10-floyd-steinberg-dithering-more-colours-from-less
        https://asanka-sovis.blogspot.com/2022/12/10-floyd-steinberg-dithering-more.html
Coded by Asanka Akash Sovis

-----------------------------------------------------------------------------*/

PImage img; // Loaded image

int factor = 1; // Dithering intensity
boolean greyScale = false; // Greyscale/Colour

// X and Y multipliers to get the adjascent pixels
int[] xPos      = new int[]{+1, -1,  0, +1};
int[] yPos      = new int[]{ 0, +1, +1, +1};

int[] errFactor = new int[]{ 7,  3,  5,  1}; // List of error factors

void setup() {
  size(1920, 1920); // Size of the image
  // NOTE: Change according to the image you have
  
  noStroke(); // Remove strokes
}

void draw() {
  img = loadImage("image.jpg"); // Loads the image to memory from data directory
  
  // Switches the image to greyscale if greyscale is enabled
  if(greyScale)
    img.filter(GRAY);
  
  img.loadPixels(); // Load pixels
  
  // We perform our task to each pixel
  for (int y = 0; y < img.height-1; y++) {
    for (int x = 1; x < img.width-1; x++) {
      
      color pix = img.pixels[index(x, y)]; // Extract colour information from pixelz
      
      float[] oldPixel = new float[]{red(pix), green(pix), blue(pix)}; // Store red,
      // green and blue as separate integer values for processing
      
      float[] newPixel = new float[3]; // Create a pixel array to store modified pixel value
      
      // For each colour channel, dithering factor is applied to round off any errors
      for (int i = 0; i < 3; i++) {
        newPixel[i] = round(factor * oldPixel[i] / 255) * (255/factor);
      }
      
      // Change the colour of the pixel with new value
      img.pixels[index(x, y)] = color(newPixel[0], newPixel[1], newPixel[2]);
      
      // Calculate the difference in error in each colour
      float[] err = new float[]{oldPixel[0] - newPixel[0], oldPixel[1] - newPixel[1], oldPixel[2] - newPixel[2]};
      
      // Set the colour of the adjascent pixels according to the dithering errors
      for (int i = 0; i < 4; i++) {
        int index = index(x + xPos[i], y + yPos[i]);
        img.pixels[index] = dither(index, img, err, errFactor[i]);
      }
      
    }
  }
  
  img.updatePixels(); // Refresh the pixels
  image(img, 0, 0); // Draw the new image on canvas
  
  //saveFrame("Output\\Floyd_Steinberg_Dithering-" + frameCount + ".png"); // Saves the current frame. Comment if you don't need
  noLoop(); // Stops the loop after 1st iteration
}

// Returns the index of a pixel when x and y coordinates are given
int index(int x, int y) {
  // index = x value + (y value * width of image)
  return x + y * img.width;
}

// Returns the dithered value for the adjascent pixels
color dither(int index, PImage img, float[] err, int errFactor) {
  color c = img.pixels[index];
  
  float[] pixel = new float[]{red(c), green(c), blue(c)};
  
  for (int i = 0; i < 3; i++) {
    pixel[i] = pixel[i] + err[i] * errFactor / 16.0;
  }
  
  return color(pixel[0], pixel[1], pixel[2]);
}

// Increases/Decreases the Dithering factor when mouse wheel is scrolled
void mouseWheel(MouseEvent event) {
  factor += event.getCount();
  
  if(factor < 1) {
    factor = 1;
  } else if (factor > 16) {
    factor = 16;
  }
  loop();
}

// Switches between greyscale and colour when mouse is pressed
void mousePressed() {
  greyScale = !greyScale;
  loop();
}
