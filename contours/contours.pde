import milchreis.imageprocessing.*;
import processing.video.*;
import milchreis.imageprocessing.utils.*;

PShape cat;

//String imgFile ="../../data/synthetic1.png";
//String imgFile ="../../data/synthetic2.png";
//String imgFile ="../../data/synthetic3.png";
//String imgFile ="../../data/synthetic4.png";
String imgFile ="../../data/synthetic5.png";
//String imgFile ="../../data/webcam.jpg";
//String imgFile ="../../data/smallCube1.png";
//String imgFile ="../../data/smallCube2.png";

String videoFile = "../../data/smallCube-1min.mov";

Movie video; // Pour la vidéo

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

// fenêtre d'aperçu final
void settings() {
  size(800,600, P3D);
}

// produit un indice à partir des coordonnées
int imIndex(int i, int j) {
  return i + j*image.width;
}

// retrouve les coordonnées à partir d'un indice
PVector imIndexReverse(int i) {
  return new PVector(i%image.width, i/image.width);
}

// distance euclidenne entre deux points
float distance(float ax, float ay, float bx, float by) {
  return sqrt(sq(bx-ax)+sq(by-ay));
}

void setup() {
  // environnement 3D
  camera(0,0,-1000, 0,0, 0, 0, 1, 0);
  lights();
  cat = loadShape("../../data/cat.obj");
  image = createImage(800,600, RGB);
  video = new Movie(this, videoFile); // Pour la vidéo
  video.loop();
  /*if (video.available()) {
    video.read();
  }*/
}

void draw() {
  
  if (video.available()) {
    image(video,0,0);
    println("OK1");
    video.read();
    println("OK2");
    PImage tmp;// = createImage(video.width,video.height, RGB);
    video.loadPixels();
    tmp = video.get();
    println(tmp.width, tmp.height);
    //for(int i = 0; i < tmp.width * tmp.height; i++) print(red(tmp.get(i*tmp.width));
    image.copy(tmp,  0,0, tmp.width,tmp.height,  0,0, image.width,image.height);
    println("OK3",video.width,video.height);
  // chargement de l'image
  //image = loadImage(dataPath(imgFile));
    //image.resize(800,600);
  println("OK4");
  
  // seuil de repérage de la couleur qui nous intéresse
  double seuil = 20;
  
  // RGB de la couleur qui nous intéresse
  float yellowR = 255;
  float yellowG = 255;
  float yellowB = 125;
  
  float redR = 224;
  float redG = 54;
  float redB = 0;
  
  float blueR = 61;
  float blueG = 86;
  float blueB = 127;
  
  // création d'une image sur laquelle nous allons travailler 
  image_modif = createImage(image.width, image.height, RGB);
  image_modif.loadPixels();
  
  // mise en place d'un fond noir
  for (int i = 0; i < image_modif.pixels.length; i++) 
  {
    image_modif.pixels[i] = color(0, 0, 0); 
  }
  
  //------------------------------------------------------------------------------------
  // calcul de la quantité de surface jaune par rapport à la surface globale du cube visible
  double sum = 0;
  double yellowsum = 0;
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
  // calcul du premier angle en fonction de la quantité de surface jaune visible
  float angle1 = radians((float)(yellowsum/sum) * 90.0);
  //------------------------------------------------------------------------------------
  // calcul des positions du centre de la surface jaune et du centre du cube (coordonnées barycentriques)
  int glblx = 0;
  int glbly = 0;
  int cntr = 1;
  int yllwglblx = 0;
  int yllwglbly = 0;
  int yllwcntr = 1;
  for (int i = 0; i < image_modif.pixels.length; i++) {
    if(red(image_modif.pixels[i]) > 0 || green(image_modif.pixels[i]) > 0 || blue(image_modif.pixels[i]) > 0) {
      PVector pos = imIndexReverse(i);
      glblx+=pos.x;
      glbly+=pos.y;
      cntr++;
    }
    if(red(image_modif.pixels[i]) == yellowR && green(image_modif.pixels[i]) == yellowG && blue(image_modif.pixels[i]) == yellowB) {
      PVector pos = imIndexReverse(i);
      yllwglblx+=pos.x;
      yllwglbly+=pos.y;
      yllwcntr++;
    }
  }
  PVector glbl = new PVector(glblx/cntr,glbly/cntr);
  PVector yllwglbl = new PVector(yllwglblx/yllwcntr,yllwglbly/yllwcntr);
  // calcul du vecteur normal du centre du cube vers le centre de la surface jaune (2D)
  PVector dir = new PVector(yllwglbl.x,yllwglbl.y,0);
  dir.sub(glbl);
  dir.normalize();
  // calcul de l'angle entre le vecteur trouvé précédemment et l'axe y
  float angle2 = acos(dir.dot(0,1,0));
  //------------------------------------------------------------------------------------
  
  // dessine l'arrière-plan
  background(image);
  //image(video,0,0);
  
  // applique les deux rotations sur le modèle et le dessine dans l'environnement 3D
  pushMatrix();
  rotateZ(angle2);
  rotateX(angle1);
  translate(0,120,0);
  shape(cat);
  popMatrix();
  }
}
