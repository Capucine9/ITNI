import milchreis.imageprocessing.*;
import milchreis.imageprocessing.utils.*;


//String imgFile ="../data/synthetic1.png";
String imgFile ="../data/synthetic2.png";
//String imgFile ="../data/synthetic3.png";
//String imgFile ="../data/webcam.jpg";
//String imgFile ="../data/smallCube1.png";
//String imgFile ="../data/smallCube2.png";

PImage image;
PImage image_modif;
PImage image_contours;
PImage image_coins0;
PImage image_coins;

//fenêtre d'aperçu final
void settings() {
  size(1600,845);
}

//index du pixel de coordonnées i,j
int imIndex(int i, int j) {
  return i + j*image_contours.width;
}

void setup()
{
  image = loadImage(dataPath(imgFile));
  scale(0.8); //uniquement pour les images nommées "synthetic"
  
  //seuil de repérage de la couleur qui nous intéresse
  double seuil = 70;
  double dist;
  
  //RGB de la couleur qui nous intéresse
  float R = 255;
  float G = 255;
  float B = 125;
  
  //création d'une image sur laquelle nous allons travailler 
  image_modif = createImage(image.width, image.height, RGB);
  image_modif.loadPixels();
  
  //mise en place d'un fond noir
  for (int i = 0; i < image_modif.pixels.length; i++) 
  {
    image_modif.pixels[i] = color(0, 0, 0); 
  }
  
  //repérage des pixels de la couleur qui nous intéresse et changement de ceux-la en blanc dans notre nouvelle image
  for (int i = 0; i < image.pixels.length; i++) 
  {
    dist = Math.sqrt(sq(R - red(image.pixels[i])) + sq(G - green(image.pixels[i])) + sq(B - blue(image.pixels[i])));
    
    if(dist < seuil)
    {
      image_modif.pixels[i] = color(255, 255, 255);
    }
  }
  
  image_modif.updatePixels();
  
  //récupération des contours des pixels blancs
  image_contours = CannyEdgeDetector.apply(image_modif);

  //détection coins
  /*for (int i = 1; i < image_contours.width-1; i++) {
    for (int j = 1; j < image_contours.height-1; j++) {
      if //verticalement
      ((image_contours.pixels[imIndex(i-1, j+1)]  != color(0, 0, 0) && image_contours.pixels[imIndex(i, j)] != color(0, 0, 0) && image_contours.pixels[imIndex(i-1, j-1)] != color(0, 0, 0))
       /*|| (image_contours.pixels[imIndex(i-1, j+1)]  != color(0, 0, 0) && image_contours.pixels[imIndex(i, j)] != color(0, 0, 0) && image_contours.pixels[imIndex(i, j-1)] != color(0, 0, 0))
       || (image_contours.pixels[imIndex(i-1, j+1)]  != color(0, 0, 0) && image_contours.pixels[imIndex(i, j)] != color(0, 0, 0) && image_contours.pixels[imIndex(i+1, j-1)] != color(0, 0, 0))
       
       /*|| (image_contours.pixels[imIndex(i, j+1)]  != color(0, 0, 0) && image_contours.pixels[imIndex(i, j)] != color(0, 0, 0) && image_contours.pixels[imIndex(i-1, j-1)] != color(0, 0, 0))
       || (image_contours.pixels[imIndex(i, j+1)]  != color(0, 0, 0) && image_contours.pixels[imIndex(i, j)] != color(0, 0, 0) && image_contours.pixels[imIndex(i, j-1)] != color(0, 0, 0))
       || (image_contours.pixels[imIndex(i, j+1)]  != color(0, 0, 0) && image_contours.pixels[imIndex(i, j)] != color(0, 0, 0) && image_contours.pixels[imIndex(i+1, j-1)] != color(0, 0, 0))
       
       || (image_contours.pixels[imIndex(i+1, j+1)]  != color(0, 0, 0) && image_contours.pixels[imIndex(i, j)] != color(0, 0, 0) && image_contours.pixels[imIndex(i-1, j-1)] != color(0, 0, 0))
       /*|| (image_contours.pixels[imIndex(i+1, j+1)]  != color(0, 0, 0) && image_contours.pixels[imIndex(i, j)] != color(0, 0, 0) && image_contours.pixels[imIndex(i, j-1)] != color(0, 0, 0))
       || (image_contours.pixels[imIndex(i+1, j+1)]  != color(0, 0, 0) && image_contours.pixels[imIndex(i, j)] != color(0, 0, 0) && image_contours.pixels[imIndex(i+1, j-1)] != color(0, 0, 0))
        
       //horizontalement
       || (image_contours.pixels[imIndex(i-1, j-1)]  != color(0, 0, 0) && image_contours.pixels[imIndex(i, j)] != color(0, 0, 0) && image_contours.pixels[imIndex(i+1, j-1)] != color(0, 0, 0))
       /*|| (image_contours.pixels[imIndex(i-1, j-1)]  != color(0, 0, 0) && image_contours.pixels[imIndex(i, j)] != color(0, 0, 0) && image_contours.pixels[imIndex(i+1, j)] != color(0, 0, 0))
       
       /*|| (image_contours.pixels[imIndex(i-1, j)]  != color(0, 0, 0) && image_contours.pixels[imIndex(i, j)] != color(0, 0, 0) && image_contours.pixels[imIndex(i+1, j-1)] != color(0, 0, 0))
       || (image_contours.pixels[imIndex(i-1, j)]  != color(0, 0, 0) && image_contours.pixels[imIndex(i, j)] != color(0, 0, 0) && image_contours.pixels[imIndex(i+1, j)] != color(0, 0, 0))
       /*|| (image_contours.pixels[imIndex(i-1, j)]  != color(0, 0, 0) && image_contours.pixels[imIndex(i, j)] != color(0, 0, 0) && image_contours.pixels[imIndex(i+1, j+1)] != color(0, 0, 0))
       
       /*|| (image_contours.pixels[imIndex(i-1, j+1)]  != color(0, 0, 0) && image_contours.pixels[imIndex(i, j)] != color(0, 0, 0) && image_contours.pixels[imIndex(i+1, j)] != color(0, 0, 0))
       || (image_contours.pixels[imIndex(i-1, j+1)]  != color(0, 0, 0) && image_contours.pixels[imIndex(i, j)] != color(0, 0, 0) && image_contours.pixels[imIndex(i+1, j+1)] != color(0, 0, 0))){
        
         image_contours.pixels[imIndex(i, j)] = color(255, 0, 0);
      }
    }
  }*/
  
  //détection coins bis : utilisation du max et min de i et j on obtient 3 points en generale
  int maxi=0;
  int jmaxi=0;
  int mini=image_contours.width;
  int jmini=0;
  
  int maxj=0;
  int imaxj=0;
  int minj=image_contours.height;
  int iminj=0;
  
  for (int i = 1; i < image_contours.width; i++) {
    for (int j = 1; j < image_contours.height; j++) {
      if(image_contours.pixels[imIndex(i, j)] == color(255, 255, 255)){
        if (maxi<i && Math.sqrt(sq(i-maxi))>10){
          maxi=i;
          jmaxi=j;
        }
      }
      if(image_contours.pixels[imIndex(i, j)] == color(255, 255, 255)){
        if (mini>i && Math.sqrt(sq(i-mini))>10){
          mini=i;
          jmini=j;
        }
      }
      
      if(image_contours.pixels[imIndex(i, j)] == color(255, 255, 255)){
        if (maxj<j && Math.sqrt(sq(j-maxj))>10){
          maxj=j;
          imaxj=i;
        }
      }
      if(image_contours.pixels[imIndex(i, j)] == color(255, 255, 255)){
        if (minj>j && Math.sqrt(sq(j-minj))>10){
          minj=j;
          iminj=i;
        }
      }
    }
  }
  image_contours.pixels[imIndex(maxi, jmaxi)] = color(255, 0, 0);
  image_contours.pixels[imIndex(mini, jmini)] = color(255, 0, 0);
  image_contours.pixels[imIndex(imaxj, maxj)] = color(255, 0, 0);
  image_contours.pixels[imIndex(iminj, minj)] = color(255, 0, 0);
  
  //suppression des arrêtes du carrée
  for (int i = 0; i < image_contours.pixels.length; i++) 
  {
    if(image_contours.pixels[i] == color(255, 255, 255)){
      image_contours.pixels[i] = color(0, 0, 0);
    }
  }
  
  image_contours.updatePixels();
  
  //affiche l'image de départ et l'image créée
  image(image, 0, 0);
  image(image_contours,image.width, 0);
}
