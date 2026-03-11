<p align="center"><img src="./_bin/logo.svg" alt="drawing" width="100"/></p>
<h4 align="center">0SH - Gestion de projet (2026)</h4>


# Calendrier du projet

|  Date |                   Matière en classe                    |    Projet     |
| ----: | :----------------------------------------------------: | :-----------: |
| 02-20 |              Création d'un projet GitHub               | Planification |
| 02-27 |           Structuration des attribution de tâches      |  Livrable #1  |
| 03-06 |                        Relâche                         |               |
| 03-13 |                                                        |               |
| 03-20 |                                                        |               |
| 03-27 |                                                        |               |
| 04-03 |                    Congé de Pâques                     |               |
| 04-10 |                                                        |               |
| 04-17 |                                                        |               |
| 04-24 |                                                        |               |
| 05-01 | Présentation des projets en classe (Épreuve terminale) |  Livrable #4  |

# 1. Mise en situation (client)

Écrire une description de quelques lignes ou de quelques paragraphes représentant la demande du client. Je dois savoir exactement ce que je dois programmer en lisant votre texte.

> Pas le **comment**, mais le **quoi** !

# 2. Preuve de faisabilité technique

Envoyer des donneées sur un websocket en localhost. Utiliser le protocole UDP pour la transmission de packet. Se connecter sur le Websocket et lire les packet udp avec godot.

# 3. Conception

Dans le cadre du projet, un système de suivi de main en temps réel a été développé afin de permettre une interaction gestuelle avec le jeu sous Godot. La détection est réalisée à l’aide de la bibliothèque **MediaPipe** exécutée en **Python**, qui analyse le flux vidéo d’une caméra et extrait les positions 3D des 21 points de repère de la main.

Afin de valider une architecture distribuée et adaptée aux contraintes temps réel, le module de vision est exécuté sur une machine dédiée, ansi que le jeu Godot. Les données de tracking sont transmises via le protocole **UDP** sur le localhost. À chaque image traitée, le script Python sérialise les informations de position et les envoie sous forme de paquets réseau vers l’application Godot.

Du côté de Godot, le dernier paquets reçus sera lu et il sera utilisé à chaque frame pour interpréter les gestes (position, orientation, pincement) et contrôler les interactions dans le jeu.

Cette architecture répartie (**Python + MediaPipe** sur une machine, **Godot** sur une autre) démontre la faisabilité d’un pipeline temps réel performant, combinant vision par ordinateur, communication réseau à faible latence et intégration interactive dans un moteur de jeu.

<hr>
<p align="center"><img src="./_bin/end.png" alt="drawing" width="150"/></p>
