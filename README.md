# Panneau de contrôle TRAVELERS

Ceci est le panneau de contrôle du projet. Il permettra à son terme de contrôler les différents aspects du projet.
Notamment une authentification, le retour vidéo, la gestion des capteurs, la gestion des moteurs, etc.

## Installation

Attention ! ce tutoriel n'aide pas à installer flutter, il décrit juste les étapes pour créer l'application. Vous ne pourrez donc pas exécuter l'application sans installation.

Pour créer l'app, on commence par créer un nouveau projet flutter :

```bash
flutter create control_panel
```

Puis on ajoute le dossier assets dans le dossier control_panel, et on y ajoute les images de l'interface dans un autre dossier img.
On pourrait alors effectuer la commande :

```bash
cd control_panel/assets/img/
```

Puis on ajoute les images dans le dossier img.

On modifie le fichier pubspec.yaml pour ajouter les images en elenvant le # devant assets de manière à obtenir :

```yaml
  assets:
    - assets/img/
```

On peut ensuite modifier l'application via le dossier lib/

Pour exécuter l'application, on exécute :

```bash
flutter run
```
