import cv2
import argparse
import json
import sys
import socket

GODOT_IP = "127.0.0.1"
GODOT_PORT = 4280

NEW_WIDTH = 640
NEW_HEIGHT = 360

MIN_LIMIT = 0.25
MAX_LIMIT = 0.75

PINCH_ON_RATIO = 0.35
PINCH_OFF_RATIO = 0.55

SMOOTHING_FACTOR = 0.35


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


def remap_and_clamp(value, min_limit, max_limit):
    mapped = (value - min_limit) / (max_limit - min_limit)
    return max(0.0, min(1.0, mapped))


def distance_2d(a, b):
    dx = a.x - b.x
    dy = a.y - b.y
    return (dx * dx + dy * dy) ** 0.5


def get_hand_scale(hand_lms):
    wrist = hand_lms.landmark[0]
    middle_mcp = hand_lms.landmark[9]
    return distance_2d(wrist, middle_mcp)


parser = argparse.ArgumentParser()
parser.add_argument("--camera", type=int, default=0)
parser.add_argument("--list-cameras", action="store_true")
args = parser.parse_args()

if args.list_cameras:
    print(json.dumps(list_cameras()))
    sys.exit(0)

import mediapipe as mp

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
cap = cv2.VideoCapture(args.camera)

if not cap.isOpened():
    print(f"Camera {args.camera} could not be opened", file=sys.stderr)
    sys.exit(1)

mp_hands = mp.solutions.hands
hands = mp_hands.Hands(
    static_image_mode=False,
    max_num_hands=1,
    model_complexity=0
)

is_pinching = False
smoothed_x = None
smoothed_y = None

while cap.isOpened():
    success, frame = cap.read()

    if not success:
        break

    img = cv2.resize(frame, (NEW_WIDTH, NEW_HEIGHT))
    img = cv2.flip(img, 1)

    img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    results = hands.process(img_rgb)

    if results.multi_hand_landmarks:
        for hand_lms in results.multi_hand_landmarks:
            thumb = hand_lms.landmark[4]
            index = hand_lms.landmark[8]

            center_x_raw = (thumb.x + index.x) / 2.0
            center_y_raw = (thumb.y + index.y) / 2.0

            cursor_x = remap_and_clamp(center_x_raw, MIN_LIMIT, MAX_LIMIT)
            cursor_y = remap_and_clamp(center_y_raw, MIN_LIMIT, MAX_LIMIT)

            if smoothed_x is None:
                smoothed_x = cursor_x
                smoothed_y = cursor_y
            else:
                smoothed_x = smoothed_x + (cursor_x - smoothed_x) * SMOOTHING_FACTOR
                smoothed_y = smoothed_y + (cursor_y - smoothed_y) * SMOOTHING_FACTOR

            pinch_distance = distance_2d(thumb, index)
            hand_scale = get_hand_scale(hand_lms)

            if hand_scale > 0:
                pinch_ratio = pinch_distance / hand_scale

                if not is_pinching and pinch_ratio < PINCH_ON_RATIO:
                    is_pinching = True
                elif is_pinching and pinch_ratio > PINCH_OFF_RATIO:
                    is_pinching = False

            message = f"{smoothed_x:.3f},{smoothed_y:.3f},{int(is_pinching)}"
            sock.sendto(message.encode(), (GODOT_IP, GODOT_PORT))

    if cv2.waitKey(1) & 0xFF == ord("q"):
        break

cap.release()
cv2.destroyAllWindows()
