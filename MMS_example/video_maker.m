% Specify the folder containing PNG images
folderPath = './pics/'; % Replace with the path to your folder

% Specify the output video file name
outputVideoName = 'output_video.mp4';

% Set the desired frame rate for the video
frameRate = 50; % Frames per second

% Get a list of all PNG files in the folder
imageFiles = dir(fullfile(folderPath, '*.png'));

% Sort files by name to maintain sequence
[~, sortedIdx] = sort({imageFiles.name});
imageFiles = imageFiles(sortedIdx);

% Check if there are any images
if isempty(imageFiles)
    error('No PNG files found in the specified folder.');
end

% Create a VideoWriter object
videoWriter = VideoWriter(outputVideoName, 'MPEG-4');
videoWriter.FrameRate = frameRate;
open(videoWriter);

% Loop through each image and write it to the video
for i = 1:length(imageFiles)
    % Read the image
    imgPath = fullfile(folderPath, imageFiles(i).name);
    img = imread(imgPath);
    
    % Convert to frame if needed (e.g., resize or adjust dimensions)
    % Uncomment and modify the following line if needed:
    % img = imresize(img, [height, width]); % Set desired dimensions
    
    % Write the frame to the video
    writeVideo(videoWriter, img);
    
    % Display progress
    % fprintf('Adding %s to the video...\n', imageFiles(i).name);
end

% Close the video writer
close(videoWriter);

disp('Video creation complete.');
