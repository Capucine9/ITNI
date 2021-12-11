import milchreis.imageprocessing.*;
import milchreis.imageprocessing.utils.*;

void setup()
{
  size(1600,845);
  
  double seuil = 70;
  double dist;
  
  float R = 255;
  float G = 255;
  float B = 125;

  
  float moyenne_X = 0;
  float moyenne_Y = 0;
  double moyenne_dist = 0;
  
  float p = 0;
  
  int nb_blanc = 0;
  int nb_blanc2 = 0;
  
  double compacite;
  
  PImage image;
  //image = loadImage("../data/synthetic1.png");
  //scale(0.8);
  //image = loadImage("../data/synthetic2.png");
  //scale(0.8);
  //image = loadImage("../data/synthetic3.png");
  //scale(0.8);
  image = loadImage("../data/webcam.jpg");
  //image = loadImage("../data/smallCube1.png");
  //image = loadImage("../data/smallCube2.png");
  
  
  PImage image_modif = createImage(image.width, image.height, RGB);
  image_modif.loadPixels();
  
  for (int i = 0; i < image_modif.pixels.length; i++) 
  {
    image_modif.pixels[i] = color(0, 0, 0); 
  }
  
  for (int i = 0; i < image.pixels.length; i++) 
  {
    dist = Math.sqrt(sq(R - red(image.pixels[i])) + sq(G - green(image.pixels[i])) + sq(B - blue(image.pixels[i])));
    
    if(dist < seuil)
    {
      image_modif.pixels[i] = color(255, 255, 255);
    }
  }
  
  image_modif.updatePixels();
  
  /*PImage processedImage = Erosion.apply(image_modif, 5);
  
  for (int i = 0; i < processedImage.pixels.length; i++) 
  {
    if(red(processedImage.pixels[i]) == 255)
    {
      p++;
      
      moyenne_X += i % image.width;
      //moyenne_Y += (i  - i % image.width) / image.width; 
      moyenne_Y += (int) (i / image.width);
    }
  }
  
  moyenne_X = (int) (moyenne_X / p);
  moyenne_Y = (int) (moyenne_Y / p);
  
  //println(moyenne_X);
  //println(moyenne_Y);
  
  for (int i = 0; i < processedImage.pixels.length; i++) 
  {
    if(red(processedImage.pixels[i]) == 255)
    {
      moyenne_dist += dist(moyenne_X, moyenne_Y, i % processedImage.width, ((int) (i / processedImage.width)));
    }    
  }
  
  moyenne_dist = (int) (moyenne_dist / p);
  
  //println(moyenne_dist);
  
  for (int i = 0; i < processedImage.pixels.length; i++) 
  {
    if(red(processedImage.pixels[i]) == 255)
    {
      if(dist(moyenne_X, moyenne_Y, i % processedImage.width, ((int) (i / processedImage.width))) > 2 * moyenne_dist)
      {
        processedImage.pixels[i] = color(0, 0, 0); 
      }
    }
  }
  
  processedImage.updatePixels();
  
  PImage processedImage2 = Dilation.apply(processedImage, 5);  // radius is a positive number
  
  for (int i = 0; i < processedImage2.pixels.length; i++) 
  {
    if(red(processedImage2.pixels[i]) == 255)
    {
      nb_blanc++;
    }
  }*/
  
  PImage processedImage3 = CannyEdgeDetector.apply(image_modif);
  
  for (int i = 0; i < processedImage3.pixels.length; i++) 
  {
    if(red(processedImage3.pixels[i]) == 255)
    {
      nb_blanc2++;
    }
  }
  
  compacite = ((sq(nb_blanc2)) / (4 * PI * nb_blanc));  
  
  println(compacite);
  
  image(image, 0, 0);
  image(processedImage3,image.width, 0);
  
  //stroke(255,0,0);
  fill(0,0,0,0);
  circle(moyenne_X, moyenne_Y, (float)moyenne_dist * 4);
  
}
