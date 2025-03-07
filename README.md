# Kidney Stone Detection using MATLAB

## Project Overview
Detecting kidney stones in medical images is essential for early diagnosis and treatment. This project develops a MATLAB-based system that processes medical images to identify kidney stones. The system enables users to manually select a Region of Interest (ROI), enhances image visibility, removes noise, and isolates potential stone regions. If a kidney stone is detected, it is highlighted on the original image for clear visualization.

## Features
- **Medical Image Processing**: Uploads and processes medical images.
- **Manual ROI Selection**: Users select the kidney region in the image.
- **Preprocessing**: Grayscale conversion, binarization, and contrast enhancement.
- **Noise Reduction**: Median filtering and morphological operations.
- **Stone Detection**: Identifies potential stones and marks them on the original image.
- **Result Visualization**: Displays multiple stages of processing and final detection results.

## Methodology
1. **Image Acquisition**: User selects a medical image via a file selection dialog.
2. **ROI Selection**: The user manually marks the kidney region.
3. **Preprocessing**:
   - Convert image to grayscale.
   - Apply binarization for segmentation.
4. **Image Processing**:
   - Enhance contrast using `imadjust`.
   - Reduce noise using median filtering (`medfilt2`).
   - Apply morphological operations (erosion and dilation) for refinement.
5. **Stone Detection**:
   - Connected component analysis using `bwlabel`.
   - Determine bounding boxes and centroids.
   - Highlight detected stones on the original image.
6. **Result Display**:
   - Show original, grayscale, binarized, and processed images.
   - Mark detected stones.
   - Display warnings if stones are detected.

## Installation & Usage
### Prerequisites
- MATLAB (with Image Processing Toolbox)

### Steps to Run
1. Clone the repository:
   ```sh
   git clone https://github.com/Kidney-Stone-Detection-on-Ultrasound-images
   ```
2. Open MATLAB and navigate to the project directory.
3. Run the script:
   ```matlab
   kidney_stone_detection.m
   ```
4. Select a medical image when prompted.
5. Manually select the Region of Interest (ROI).
6. View processed images and detection results.

## Result Analysis
The system successfully processed medical images and detected kidney stones in most cases. However, detection accuracy depends on:
- **Noise and image quality**: High noise levels can affect detection.
- **ROI selection**: User selection impacts detection accuracy.
- **Stone size**: Very small or overlapping stones may be harder to detect.

### False Positives & False Negatives
- **False Positive**: Incorrectly identifying a stone due to an improper ROI selection.
- **False Negative**: Missing a stone if ROI selection does not include it.

## Future Improvements
- **Automated ROI selection**: Reduce manual dependency.
- **Advanced segmentation**: Deep learning models for better accuracy.
- **Improved noise reduction**: Enhance image clarity and reduce false detections.

## Team Contribution
- **Rafid Mahmud (ID: 200021239)**: Led coding, image preprocessing, and morphological operations.
- **Muhtasim Zunaid (ID: 200021237)**: Developed segmentation and detection logic.
- **Natasha Hasan (ID: 200021229)**: Wrote and structured the report.
- **Mubarak Ibrahim (ID: 200021259)**: Assisted in debugging and optimizing code.
- **Mutakabbir Ashfak (ID: 200021227)**: Designed and prepared presentation slides.

## References
- Otsu, N. (1979). *A Threshold Selection Method from Gray-Level Histograms.* IEEE Transactions on Systems, Man, and Cybernetics.
- MATLAB Documentation: [Image Processing Toolbox](https://www.mathworks.com/help/images/)
- GitHub Repository: [Kidney-Stone-Detection-on-Ultrasound-images](https://github.com/Kidney-Stone-Detection-on-Ultrasound-images)

## License
This project is licensed under the MIT License.

