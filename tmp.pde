import milchreis.imageprocessing.*;
import milchreis.imageprocessing.utils.*;

//String imgFile ="../../data/synthetic1.png";
//String imgFile ="../../data/synthetic2.png";
//String imgFile ="../../data/synthetic3.png";
String imgFile ="../../data/synthetic4.png";
//String imgFile ="../../data/webcam.jpg";
//String imgFile ="../../data/smallCube1.png";
//String imgFile ="../../data/smallCube2.png";

PImage image;
PImage image_modif;
PImage yellow_contours;
PImage red_contours;
PImage blue_contours;

PVector yellow_edge = new PVector();
PVector yellow_a = new PVector(),yellow_b = new PVector();
PVector red_edge = new PVector();
PVector red_a = new PVector(),red_b = new PVector();
PVector blue_edge = new PVector();
PVector blue_a = new PVector(),blue_b = new PVector();

//fenêtre d'aperçu final
void settings() {
  size(1600,845, P3D);
}

//index du pixel de coordonnées i,j
int imIndex(int i, int j) {
  return i + j*image.width;
}

PVector idxReverse(int i) {
  return new PVector(i%image.width, i/image.width);
}

float distance(float ax, float ay, float bx, float by) {
  return sqrt(sq(bx-ax)+sq(by-ay));
}

PVector rotateAxis(PVector p, float pitch, float roll, float yaw) {
    double cosa = Math.cos(yaw);
    double sina = Math.sin(yaw);

    double cosb = Math.cos(pitch);
    double sinb = Math.sin(pitch);

    double cosc = Math.cos(roll);
    double sinc = Math.sin(roll);

    double Axx = cosa*cosb;
    double Axy = cosa*sinb*sinc - sina*cosc;
    double Axz = cosa*sinb*cosc + sina*sinc;

    double Ayx = sina*cosb;
    double Ayy = sina*sinb*sinc + cosa*cosc;
    double Ayz = sina*sinb*cosc - cosa*sinc;

    double Azx = -sinb;
    double Azy = cosb*sinc;
    double Azz = cosb*cosc;

        double px = p.x;
        double py = p.y;
        double pz = p.z;

        p.x = (float)(Axx*px + Axy*py + Axz*pz);
        p.y = (float)(Ayx*px + Ayy*py + Ayz*pz);
        p.z = (float)(Azx*px + Azy*py + Azz*pz);
  return p;
}

void setup()
{
  camera(0,0,-300, 0,0, 0, 0, 1, 0);
  lights();
  
  image = loadImage(dataPath(imgFile));
  scale(0.8); //uniquement pour les images nommées "synthetic"
  
  //seuil de repérage de la couleur qui nous intéresse
  double seuil = 35;//70;
  
  //RGB de la couleur qui nous intéresse
  float yellowR = 255;
  float yellowG = 255;
  float yellowB = 125;
  
  float redR = 224;
  float redG = 54;
  float redB = 0;
  
  float blueR = 61;
  float blueG = 86;
  float blueB = 127;
  
  //création d'une image sur laquelle nous allons travailler 
  image_modif = createImage(image.width, image.height, RGB);
  image_modif.loadPixels();
  
  //mise en place d'un fond noir
  for (int i = 0; i < image_modif.pixels.length; i++) 
  {
    image_modif.pixels[i] = color(0, 0, 0); 
  }
  
  double sum = 0;
  double yellowsum = 0;
  
  //repérage des pixels de la couleur qui nous intéresse et changement de ceux-la en blanc dans notre nouvelle image
  for (int i = 0; i < image.pixels.length; i++) 
  {
    double distyellow = Math.sqrt(sq(yellowR - red(image.pixels[i])) + sq(yellowG - green(image.pixels[i])) + sq(yellowB - blue(image.pixels[i])));
    double distred = Math.sqrt(sq(redR - red(image.pixels[i])) + sq(redG - green(image.pixels[i])) + sq(redB - blue(image.pixels[i])));
    double distblue = Math.sqrt(sq(blueR - red(image.pixels[i])) + sq(blueG - green(image.pixels[i])) + sq(blueB - blue(image.pixels[i])));
    if(distyellow < seuil)
    {
      image_modif.pixels[i] = color(yellowR, yellowG, yellowB);
      sum++;
      yellowsum++;
    }
    else if(distred < seuil){
      image_modif.pixels[i] = color(redR, redG, redB);
      sum++;
    }
    else if(distblue < seuil){
      image_modif.pixels[i] = color(blueR, blueG, blueB);
      sum++;
    }
  }
  float angle1 = radians((float)(yellowsum/sum) * 90.0);
  
  int glblx = 0;
  int glbly = 0;
  int cntr = 0;
  int yllwglblx = 0;
  int yllwglbly = 0;
  int yllwcntr = 0;
  for (int i = 0; i < image_modif.pixels.length; i++) {
    if(red(image_modif.pixels[i]) > 0 && green(image_modif.pixels[i]) > 0 && blue(image_modif.pixels[i]) > 0) {
      PVector pos = idxReverse(i);
      glblx+=pos.x;
      glbly+=pos.y;
      cntr++;
    }
    if(red(image_modif.pixels[i]) == yellowR && green(image_modif.pixels[i]) == yellowG && blue(image_modif.pixels[i]) == yellowB) {
      PVector pos = idxReverse(i);
      yllwglblx+=pos.x;
      yllwglbly+=pos.y;
      yllwcntr++;
    }
  }
  PVector glbl = new PVector(glblx/cntr,glbly/cntr);
  PVector yllwglbl = new PVector(yllwglblx/yllwcntr,yllwglbly/yllwcntr);
  PVector dir = new PVector(yllwglbl.x,yllwglbl.y,0);
  dir.sub(glbl);
  dir.normalize();
  
  pushMatrix();
  rotateY(-angle1);
  PVector axis = new PVector(0,1,0);
  axis = rotateAxis(axis,0,angle1,0);
  axis.normalize();
  println(degrees(angle1));
  println(axis);
  float angle2 = dir.dot(axis);
  angle2 = acos(angle2);
  rotateX(-angle2);
  box(50);
  popMatrix();
  image_modif.updatePixels();
  translate(0,0,500);
  stroke(255);
  ellipse(glbl.x-image_modif.width/2,glbl.y-image_modif.height/2, 30,30);
  ellipse(yllwglbl.x-image_modif.width/2,yllwglbl.y-image_modif.height/2, 30,30);
  image(image_modif,-image_modif.width/2,-image_modif.height/2);
}