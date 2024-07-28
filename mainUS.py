# en-US version

import cv2
import os
import sys

def extract_frames(video_path, output_folder):
    # Check if the output directory exists
    if not os.path.exists(output_folder):
        print("Output directory doesn't exist, creating one now..")
        os.makedirs(output_folder)
    else:
        # Delete existing files in the output directory
        print("Clearing existing files in the output directory...")
        for filename in os.listdir(output_folder):
            file_path = os.path.join(output_folder, filename)
            if os.path.isfile(file_path):
                os.remove(file_path)
    
    # Open the video file
    video = cv2.VideoCapture(video_path)
    if not video.isOpened():
        print(f"Error: Could not open video file {video_path}")
        return
    
    count = 1  # Start counting from 1
    success, image = video.read()
    
    while success:
        frame_path = os.path.join(output_folder, f"{count}.png")  # Sequential naming
        cv2.imwrite(frame_path, image)
        
        # Print the current frame number, reusing the same line
        sys.stdout.write(f"\rExtracting frame: {count}")
        sys.stdout.flush()
        
        success, image = video.read()
        count += 1
    
    video.release()
    print("\nExtraction complete.")  # Print newline after completion

# Ask user for the video path and output folder
video_path = input("Please enter the path to the video file: ").strip()
output_folder = 'videoOutput'  # You can also prompt for this if needed

# Check if the video file path is valid
if not os.path.isfile(video_path):
    print(f"Error: The file at {video_path} does not exist or is not a file.")
else:
    extract_frames(video_path, output_folder)
    input("Successfully split .mp4 into .png slices. Press Enter to close...")