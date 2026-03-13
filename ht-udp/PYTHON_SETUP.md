# Configuration Python (Tracking MediaPipe)

Ce module permet de détecter la main et d'envoyer les coordonnées à Godot via UDP

## Prérequis
Vous **devez** utiliser **Python 3.12**. Les versions plus récentes  ne sont pas compatibles avec MediaPipe actuellement.
* **Lien de téléchargement :** [Python 3.12.10](https://www.python.org/downloads/release/python-31210/)
## Installation rapide

1. **Créer l'environnement virtuel** (en forçant la version 3.12) :
    ```powershell
    py -3.12 -m venv venv
    ```

2. **Activer l'environnement virtuel** :
   ```powershell
   .\venv\Scripts\activate
   ```

3. **Installer les dépendances** :
   ```powershell
   pip install -r requirements.txt
   ```

## Utilisation

1. **Activer l'environnement virtuel** (si pas déjà fait) :
   ```powershell
   .\venv\Scripts\activate
   ```

2. **Lancer le script** :
   ```powershell
   python main.py
   ```