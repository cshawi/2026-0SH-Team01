import cv2


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

    print(cameras)
    
    return cameras
