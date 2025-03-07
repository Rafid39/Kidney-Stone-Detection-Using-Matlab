clc;
clear;
close all;
warning off;

% Load Image
[file, path] = uigetfile('*.*', 'Select an Image File');
if isequal(file, 0)
    disp('No file selected.');
    return;
end
imagePath = fullfile(path, file);
rawImage = imread(imagePath);
figure;
imshow(rawImage), title('Original Image');

% Convert to Grayscale
grayImg = rgb2gray(rawImage);
figure;
imshow(grayImg), title('Grayscale Image');

% Binarization
binaryImg = imbinarize(grayImg, 20 / 255);
figure;
imshow(binaryImg), title('Binarized Image');

% Fill Holes and Remove Small Objects
filledImg = imfill(binaryImg, 'holes');
cleanImg = bwareaopen(filledImg, 1000);

% Extract ROI from the original image
roiImage = uint8(double(rawImage) .* repmat(cleanImg, [1, 1, 3]));
figure;
imshow(roiImage), title('Region of Interest (ROI)');

% Image Adjustments
adjImage = imadjust(roiImage, [0.3 0.7], []) + 50;
grayAdjImg = rgb2gray(adjImage);
filteredImg = medfilt2(grayAdjImg, [5 5]) > 250;

% Morphological Filtering
se = strel('disk', 5);
cleanedImg = imerode(filteredImg, se);
finalProcessed = imdilate(cleanedImg, se);
figure;
imshow(finalProcessed), title('Cleaned and Processed Image');

% Remove Large Objects
labelImg = bwlabel(finalProcessed);
regions = regionprops(labelImg, 'Area', 'PixelIdxList');
filteredMask = false(size(finalProcessed));

for i = 1:length(regions)
    if regions(i).Area <= 5000
        filteredMask(regions(i).PixelIdxList) = true;
    end
end

finalProcessed = filteredMask;

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

% Define ROI Area
[rows, cols] = size(finalProcessed);
xStart = rows / 2 - 20;
yStart = cols / 3 + 20;
roiWidth = 200;
roiHeight = 40;
roiX = [xStart, xStart + roiHeight, xStart + roiHeight, xStart];
roiY = [yStart, yStart, yStart + roiWidth, yStart + roiWidth];

% Create ROI Mask
roiMask = roipoly(finalProcessed, roiY, roiX);
figure;
imshow(roiMask), title('ROI Selection');

% Check ROI for White Pixels
roiOverlap = finalProcessed & roiMask;

% Create a blank black image to store only detected stone pixels
stoneOnlyImg = zeros(size(finalProcessed));

if any(roiOverlap(:))
    intersectRegions = bwlabel(roiOverlap);
    stoneStats = regionprops(intersectRegions, 'Centroid', 'BoundingBox');
    
    % Create a figure
    figure;
    imshow(stoneOnlyImg);  % Display blank image
    hold on;
    
    % Draw detected stones and keep only their pixels
    for k = 1:length(stoneStats)
        centroid = stoneStats(k).Centroid;
        bbox = stoneStats(k).BoundingBox;
        radius = bbox(3) / 1.8;
        
        % Create a circular mask for detected stones
        [X, Y] = meshgrid(1:size(finalProcessed, 2), 1:size(finalProcessed, 1));
        mask = (X - centroid(1)).^2 + (Y - centroid(2)).^2 <= radius^2;
        
        % Apply the mask to keep only stone pixels
        stoneOnlyImg(mask) = finalProcessed(mask);
        
        % Draw the circles around detected stones
        viscircles(centroid, radius, 'EdgeColor', 'g', 'LineWidth', 2);
    end
    
    % Display only detected stone pixels
    imshow(stoneOnlyImg);
    title('Detected Stones Only');
else
    figure;
    imshow(zeros(size(finalProcessed))), title('No Stones Detected');
end
