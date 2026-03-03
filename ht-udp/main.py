import cv2
import mediapipe as mp

import socket
import time
import random

GODOT_IP = "127.0.0.1" 
GODOT_PORT = 4280
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

cap = cv2.VideoCapture(0)
cap.set(cv2.CAP_PROP_FRAME_WIDTH, 640)
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 480)

mp_hands = mp.solutions.hands
hands = mp_hands.Hands(
    static_image_mode=False, # Indique qu'on traite une vidéo, pas des photos
    max_num_hands=1,         # Une main
    model_complexity=0       # Utilise le modèle d'IA le plus rapide
)

while cap.isOpened():
    success, img = cap.read()
    if not success: break

    img = cv2.flip(img, 1)
    img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    results = hands.process(img_rgb)

    if results.multi_hand_landmarks:
        for hand_lms in results.multi_hand_landmarks:
            pouce = hand_lms.landmark[4]
            index = hand_lms.landmark[8]

            message = f"{pouce.x:.3f},{pouce.y:.3f},{index.x:.3f},{index.y:.3f}"

            sock.sendto(message.encode(), (GODOT_IP, GODOT_PORT))
            

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()