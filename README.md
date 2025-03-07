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

## Code Implementation
The MATLAB script follows these key steps:
```matlab
clc;
clear;
close all;
warning off;

% Load Image
[file, path] = uigetfile({'*.jpg;*.png;*.bmp'}, 'Select an Image File');
if isequal(file, 0)
    disp('No file selected.');
    return;
end
imagePath = fullfile(path, file);
rawImage = imread(imagePath);
figure; imshow(rawImage), title('Original Image');

% Convert to Grayscale
grayImg = rgb2gray(rawImage);
figure; imshow(grayImg), title('Grayscale Image');

% Binarization
binaryImg = imbinarize(grayImg, 20 / 255);
figure; imshow(binaryImg), title('Binarized Image');

% Fill Holes and Remove Small Objects
filledImg = imfill(binaryImg, 'holes');
cleanImg = bwareaopen(filledImg, 1000);

% Extract ROI
roiImage = uint8(double(rawImage) .* repmat(cleanImg, [1, 1, 3]));
figure; imshow(roiImage), title('Region of Interest (ROI)');

% Contrast Enhancement
adjImage = imadjust(roiImage, [0.3 0.7], []) + 50;
grayAdjImg = rgb2gray(adjImage);
filteredImg = medfilt2(grayAdjImg, [5 5]) > 250;

% Morphological Filtering
se = strel('disk', 5);
cleanedImg = imerode(filteredImg, se);
finalProcessed = imdilate(cleanedImg, se);
figure; imshow(finalProcessed), title('Cleaned and Processed Image');

% Detect Potential Stones
labeledRegions = bwlabel(finalProcessed);
objectStats = regionprops(labeledRegions, 'Area', 'Centroid', 'BoundingBox');
markedCircles = [];

for i = 1:length(objectStats)
    if objectStats(i).Area > 100 && objectStats(i).Area < 5000
        centroid = objectStats(i).Centroid;
        bbox = objectStats(i).BoundingBox;
        radius = bbox(3) / 1.8;
        markedCircles = [markedCircles; centroid, radius];
    end
end

% Display Detection Result
figure; imshow(rawImage); hold on;
for i = 1:size(markedCircles, 1)
    viscircles(markedCircles(i, 1:2), markedCircles(i, 3), 'EdgeColor', 'g', 'LineWidth', 2);
end
hold off; title('Detected Stones');
```

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

---

This README provides a complete overview of your project, covering methodology, installation, usage, and team contributions. Let me know if you need any modifications!
