import cv2
import argparse
import json
import sys

import socket
import time
import random

GODOT_IP = "127.0.0.1" 
GODOT_PORT = 4280
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)


def list_cameras(max_index=10):
    cameras = []

    for index in range(max_index + 1):
        cap = cv2.VideoCapture(index)

        if cap.isOpened():
            cameras.append({
                "index": index,
                "name": f"Camera {index + 1}"
                
            })

        cap.release()

    return cameras

parser = argparse.ArgumentParser()
parser.add_argument("--camera", type=int, default=0)
parser.add_argument("--list-cameras", action="store_true")
args = parser.parse_args()

if args.list_cameras:
    print(json.dumps(list_cameras()))
    sys.exit(0)

cap = cv2.VideoCapture(args.camera)

import mediapipe as mp


mp_hands = mp.solutions.hands
hands = mp_hands.Hands(
    static_image_mode=False, # Indique qu'on traite une vidéo, pas des photos
    max_num_hands=1,         # Une seule main
    model_complexity=0       # Utilise le modèle d'IA le plus rapide
)

new_width = 640
new_height = 360

MIN_LIMIT = 0.25
MAX_LIMIT = 0.75

def remap_and_clamp(value, min_limit, max_limit):
    # Formule de Remap : (val - min) / (max - min)
    mapped = (value - min_limit) / (max_limit - min_limit)
    # Clamp pour rester entre 0.0 et 1.0
    return max(0.0, min(1.0, mapped))

while cap.isOpened():
    success, frame = cap.read()
    if not success: break

    img = cv2.resize(frame, (new_width, new_height))
    img = cv2.flip(img, 1)

    

    img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    results = hands.process(img_rgb)

    if results.multi_hand_landmarks:
        for hand_lms in results.multi_hand_landmarks:
            p_raw = hand_lms.landmark[4] # Pouce
            i_raw = hand_lms.landmark[8] # Index

            p_x = remap_and_clamp(p_raw.x, MIN_LIMIT, MAX_LIMIT)
            p_y = remap_and_clamp(p_raw.y, MIN_LIMIT, MAX_LIMIT)
            i_x = remap_and_clamp(i_raw.x, MIN_LIMIT, MAX_LIMIT)
            i_y = remap_and_clamp(i_raw.y, MIN_LIMIT, MAX_LIMIT)

            message = f"{p_x:.3f},{p_y:.3f},{i_x:.3f},{i_y:.3f}"

            sock.sendto(message.encode(), (GODOT_IP, GODOT_PORT))
            

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()