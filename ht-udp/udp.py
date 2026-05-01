import socket
import time
import random

GODOT_IP = "127.0.0.1" 
GODOT_PORT = 4280
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
firstime = True

try:
  if (firstime):
    sock.sendto("voici les cameras mon gars", (GODOT_IP, GODOT_PORT))
    firstime = False
  while True:
    x = round(random.uniform(0, 1), 3)
    y = round(random.uniform(0, 1), 3)
    

    message = f"{x},{y}"
    
    sock.sendto(message.encode(), (GODOT_IP, GODOT_PORT))
    
    print(f"Envoyé : {message}")
    time.sleep(0.1)

except KeyboardInterrupt:
  print("Arrêt du test.")