import cv2
import os
import sys

def extract_frames(video_path, output_folder):
    # Checks if the output folder exists
    if not os.path.exists(output_folder):
        print("Ο φάκελος output δεν υπάρχει, δημιουργία ενός νέου φακέλου..")
        os.makedirs(output_folder)
    else:
        # Deletes existing files in the output folder
        print("Διαγραφή υπάρχοντών αρχείων στο output")
        for filename in os.listdir(output_folder):
            file_path = os.path.join(output_folder, filename)
            if os.path.isfile(file_path):
                os.remove(file_path)
    
    # Opens the video file
    video = cv2.VideoCapture(video_path)
    if not video.isOpened():
        print(f"Error: Δεν είναι δυνατή η επεξεργασία του βίντεο: {video_path}: Cannot open video.")
        return
    
    count = 1  # Starts numbering from 1
    success, image = video.read()
    
    while success:
        frame_path = os.path.join(output_folder, f"{count}.png")  # Sequential naming
        cv2.imwrite(frame_path, image)
        
        # Prints the current frame number, reusing the same line
        sys.stdout.write(f"\rΕξαγωγή καρε: {count}")
        sys.stdout.flush()
        
        success, image = video.read()
        count += 1
    
    video.release()
    print("\nH εξαγωγή ολογκληρώθηκε complete.")  # Print new line after completion

# Asks the user for the video path and output folder
video_path = input("Εισάγετε την διαδρομή στο αρχείο βίντεο: ").strip()
output_folder = 'videoOutput'  # You can also ask this from the user if needed

# Checks if the video file path is valid
if not os.path.isfile(video_path):
    print(f"Error: Το αρχείο στη διαδρομή {video_path} δεν υπάρχει ή δεν είναι αρχείο.")
else:
    extract_frames(video_path, output_folder)
    input("Η διαίρεση του .mp4 σε .png κομμάτια ολοκληρώθηκε με επιτυχία. Πατήστε Enter για να κλείσετε...")
