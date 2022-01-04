/*
 * Capucine Hubert
 * Louis-Wilhelm Raban-Schürmann
 */
 
import milchreis.imageprocessing.*;
import milchreis.imageprocessing.utils.*;

PShape cat;

//String imgFile ="../../data/synthetic1.png";
//String imgFile ="../../data/synthetic2.png";
String imgFile = "../../data/synthetic3.png";
//String imgFile ="../../data/synthetic4.png";
//String imgFile ="../../data/synthetic5.png";

PImage image;
PImage image_modif;

//fenêtre d'aperçu final
void settings() {
    size(1000, 1056, P3D);
}

//index du pixel de coordonnées i,j
int imIndex(int i, int j) {
    return i + j * image.width;
}

PVector idxReverse(int i) {
    return new PVector(i % image.width, i / image.width);
}

// retrouve les coordonnées à partir d'un indice
PVector imIndexReverse(int i) {
    return new PVector(i % image.width, i / image.width);
}

float distance(float ax, float ay, float bx, float by) {
    return sqrt(sq(bx - ax) + sq(by - ay));
}

float dist(float a, float b) {
    float res = a - b;
    if (res < 0) return -res;
    return res;
}

void setup() {
    // environnement 3D
    ortho(-width / 2, width / 2, -height / 2, height / 2);
    cat = loadShape("../../data/cat.obj");
    lights();
    image = loadImage(dataPath(imgFile));
    image.loadPixels();
    image.resize(1000, 1056);

    // RGB de référence pour nos calculs internes
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
    for (int i = 0; i < image_modif.pixels.length; i++) {
        image_modif.pixels[i] = color(0, 0, 0);
    }

    //------------------------------------------------------------------------------------
    // calcul de la quantité de surface jaune par rapport à la surface globale du cube visible
    double pixelnmbr = image.width * image.height;
    double sum = 0;
    double yellowsum = 0;
    Boolean show = true;
    for (int i = 0; i < image.pixels.length; i++) {
        if (dist(hue(image.pixels[i]), 43) < 1 && saturation(image.pixels[i]) > 100) {
            image_modif.pixels[i] = color(yellowR, yellowG, yellowB);
            sum++;
            yellowsum++;
        } else if (dist(hue(image.pixels[i]), 7) < 1) {
            image_modif.pixels[i] = color(redR, redG, redB);
            sum++;
        } else if (dist(hue(image.pixels[i]), 155) < 2) {
            image_modif.pixels[i] = color(blueR, blueG, blueB);
            sum++;
        }
    }
    // calcul du premier angle en fonction de la quantité de surface jaune visible
    float angle1 = radians((float)(yellowsum / sum) * 90.0);
    // retirer si la surface jaune est inférieure à 1% de la surface de l'écran
    if (yellowsum / pixelnmbr * 100 < 1) show = false;
    //------------------------------------------------------------------------------------
    // calcul des positions du centre de la surface jaune et du centre du cube (coordonnées barycentriques)
    int glblx = 0;
    int glbly = 0;
    int cntr = 1;
    int yllwglblx = 0;
    int yllwglbly = 0;
    int yllwcntr = 1;
    for (int i = 0; i < image_modif.pixels.length; i++) {
        if (red(image_modif.pixels[i]) > 0 || green(image_modif.pixels[i]) > 0 || blue(image_modif.pixels[i]) > 0) {
            PVector pos = imIndexReverse(i);
            glblx += pos.x;
            glbly += pos.y;
            cntr++;
        }
        if (red(image_modif.pixels[i]) == yellowR && green(image_modif.pixels[i]) == yellowG && blue(image_modif.pixels[i]) == yellowB) {
            PVector pos = imIndexReverse(i);
            yllwglblx += pos.x;
            yllwglbly += pos.y;
            yllwcntr++;
        }
    }
    PVector glbl = new PVector(glblx / cntr, glbly / cntr);
    PVector yllwglbl = new PVector(yllwglblx / yllwcntr, yllwglbly / yllwcntr);
    image.pixels[imIndex((int) yllwglbl.x, (int) yllwglbl.y)] = color(255, 0, 0);
    image.pixels[imIndex((int) glbl.x, (int) glbl.y)] = color(0, 255, 0);
    // calcul du vecteur normal du centre du cube vers le centre de la surface jaune (2D)
    PVector dir = new PVector(yllwglbl.x, yllwglbl.y, 0);
    dir.sub(glbl);
    dir.normalize();
    // calcul de l'angle entre le vecteur trouvé précédemment et l'axe y
    float angle2 = atan2(dir.y, dir.x) + radians(-90);
    //------------------------------------------------------------------------------------

    // dessine l'arrière-plan
    background(image);

    if (show) {
        // applique les deux rotations sur le modèle et le dessine dans l'environnement 3D
        pushMatrix();
        translate(yllwglbl.x, yllwglbl.y, 0);
        scale(0.5);
        rotateZ(angle2);
        rotateX(angle1);
        shape(cat);
        popMatrix();
    }
}
