import cv2
import os

def extract_frames(video_path, output_folder):
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)
    
    video = cv2.VideoCapture(video_path)
    count = 1  # Start counting from 1
    success, image = video.read()
    
    while success:
        frame_path = os.path.join(output_folder, f"{count}.png")  # Sequential naming
        cv2.imwrite(frame_path, image)
        success, image = video.read()
        count += 1
    
    video.release()

# Specify your video path and output folder here
video_path = 'Input/vid.mp4'
output_folder = 'Output'
extract_frames(video_path, output_folder)