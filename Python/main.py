import cv2
import os
import sys

def extract_frames(video_path, output_folder, file_format):
    # Check if the output directory exists, if not make a new one
    if not os.path.exists(output_folder):
        print("Output directory doesn't exist, creating one now..")
        os.makedirs(output_folder)
    else:
        # If there are files in the output directory we delete them
        print("Clearing existing files in the output directory...")
        for filename in os.listdir(output_folder):
            file_path = os.path.join(output_folder, filename)
            if os.path.isfile(file_path):
                os.remove(file_path)
    
    video = cv2.VideoCapture(video_path)
    if not video.isOpened():
        print(f"Error: Could not open video file {video_path}")
        return
    
    count = 1  # The current frame, which is also the name of the image
    success, image = video.read()
    
    while success:
        frame_path = os.path.join(output_folder, f"{count}.{file_format}")  
        if file_format == 'jpg':
            cv2.imwrite(frame_path, image, [int(cv2.IMWRITE_JPEG_QUALITY), 90])  # Visit OpenCV Docs for info
        else:
            cv2.imwrite(frame_path, image)  # PNG is the default format
        
        sys.stdout.write(f"\rExtracting frame: {count}")
        sys.stdout.flush()
        success, image = video.read()
        count += 1
    
    video.release()
    print("\nExtraction complete.")

# On screen instructions
video_path = input("Please enter the path to the video file: ").strip()
output_folder = 'videoOutput'

# There is probably a better way to do it other than a while loop, but that's the first solution I thought of and I am sticking to that.
while True:
    file_format = input("Please enter image format (png/jpg): ").strip().lower()
    if file_format in ['png', 'jpg']:
        break
    else:
        print("Invalid format. Please enter 'png' or 'jpg'.")

if not os.path.isfile(video_path):
    print(f"Error: The file at {video_path} does not exist or is not a file.")
else:
    extract_frames(video_path, output_folder, file_format)
    input(f"Successfully split video into .{file_format} slices. Press Enter to close...")
