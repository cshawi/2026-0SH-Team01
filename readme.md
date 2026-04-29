## Build du module Python (Tracking MediaPipe)

Le jeu utilise un module Python pour détecter la main avec MediaPipe et envoyer les coordonnées à Godot via UDP.

Dans une version exportée, Godot lance automatiquement le module de tracking. Il faut toutefois générer l'exécutable `hand_tracking` adapté à votre système d'exploitation.

### Prérequis

Vous **devez** utiliser **Python 3.12**. Les versions plus récentes ne sont pas compatibles avec MediaPipe actuellement.

- **Lien de téléchargement :** [Python 3.12.10](https://www.python.org/downloads/release/python-31210/)

## Windows

Sur Windows, le fichier `hand_tracking.exe` est déjà fourni dans le dossier de release.

Aucune étape de build Python n'est nécessaire.

Le dossier final doit contenir :

    The_Hand_of_Fate/
    ├─ The_Hand_of_Fate.exe
    └─ hand_tracking.exe

## macOS / Linux

Le fichier `hand_tracking.exe` généré sur Windows ne fonctionne pas sur macOS ou Linux. Il faut générer l'exécutable sur la machine cible.

### 1. Aller dans le dossier Python

    cd ht-udp

### 2. Créer l'environnement virtuel

    python3.12 -m venv venv

### 3. Activer l'environnement virtuel

    source venv/bin/activate

### 4. Installer les dépendances

    pip install -r requirements.txt
    pip install pyinstaller pyinstaller-hooks-contrib opencv-python

### 5. Générer l'exécutable

    pyinstaller --clean --onefile --name hand_tracking --collect-all mediapipe --collect-all cv2 main.py

### 6. Récupérer l'exécutable généré

Le fichier sera créé ici :

    ht-udp/dist/hand_tracking


Exemple macOS :

    The_Hand_of_Fate/
    ├─ The_Hand_of_Fate.app
    └─ hand_tracking

Exemple Linux :

    The_Hand_of_Fate/
    ├─ The_Hand_of_Fate
    └─ hand_tracking

## Tester le module Python sans Godot

### Windows

    cd ht-udp
    .\venv\Scripts\activate
    python main.py

### macOS / Linux

    cd ht-udp
    source venv/bin/activate
    python main.py

## Fichiers générés à ne pas commit

Les fichiers générés par PyInstaller ne doivent pas être commit dans Git :

    ht-udp/venv/
    ht-udp/build/
    ht-udp/dist/
    ht-udp/*.spec
    ht-udp/__pycache__/
    ht-udp/*.pyc

Le fichier `hand_tracking` ou `hand_tracking.exe` doit être inclus dans le dossier/zip de release final, mais pas dans Git.

### Note pour macOS

Avant de poursuivre veuillez tester une première fois si la caméra s'active bien ou pas.

Sur macOS, l'export Godot génère généralement une application :

    The_Hand_of_Fate.app

Le programme Python généré par PyInstaller s'appelle :

    hand_tracking

Pour que Godot puisse le lancer automatiquement, il doit être placé dans le dossier interne de l'application Godot.

Après l'export macOS :

1. Faire clic droit sur :

       The_Hand_of_Fate.app

2. Cliquer sur :

       Show Package Contents

3. Aller dans :

       Contents/MacOS/

4. Copier le fichier `hand_tracking` dans ce dossier.

Le résultat doit ressembler à ceci :

    The_Hand_of_Fate.app/
    └─ Contents/
       └─ MacOS/
          ├─ The_Hand_of_Fate
          └─ hand_tracking

Ensuite, lancer normalement :

    The_Hand_of_Fate.app

Godot devrait lancer automatiquement `hand_tracking`.

Si le tracking ne fonctionne pas, vérifier les permissions caméra dans :

    System Settings > Privacy & Security > Camera

