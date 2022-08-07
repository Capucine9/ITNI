# Introduction au Traitemnt Numérique d'Image

Inspiré du Merge Cube.

Réalisation d'un programme permettant de rajouter un objet 3D sur des images et vidéos utilisant les les valeurs RGB ou encore HSV des couleurs afin de discerner les différentes faces du cube. 
L'utilisation de la webcam est également possible.

Fichiers :
- data : Dossier contenant les diiférentes images/vidéos sources utilisées par les algorithmes.
- image_hsv/image_hsv.pde : Code source pour l’algorithme fonctionnant avec des images. Les couleurs sont retrouvées par transformations en HSV au préalable.
- video_hsv/video_hsv.pde Code source pour l’algorithme fonctionnant avec des vidéos. Les couleurs sont retrouvées par transformations en HSV au préalable.
- video_rgb/video_rgb.pde Code source pour l’algorithme fonctionnant avec des vidéos. Le seuil pour retrouver les couleurs est directement appliqué sur les valeurs RGB.
- webcam_hsv/webcam_hsv.pde Code source pour l’algorithme fonctionnant avec un flux vidéo webcam. L’algorithme fonctionne en temps réel. Les couleurs sont retrouvées par transformations en HSV au préalable.
- webcam_hsv_bary/webcam_hsv_bary.pde : Code source pour l’algorithme fonctionnant avec un flux vidéo webcam. L’algorithme fonctionne en temps réel. Les couleurs sont retrouvées par transformations en HSV au préalable. Une étape supplémentaire pour suppression de bruit à été rajoutée.
- res : Résultats exemples des différentes exécutions.
