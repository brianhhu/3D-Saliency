%{
Basic demo of the proto-object based saliency model with added depth information, which allows
users to test the model on different datasets. Simply run demo.m to start.

This code was inspired by the code from "A model of proto-object based saliency",
which was written by Alexander Russell and Stefan Mihalas (Johns Hopkins University, 2012).
Parts of this code are also inspired by Dirk Walther''s Saliency Toolbox (www.saliencytoolbox.net).

If you have questions about the code, feel free to contact me at: bhu6 (AT) jhmi (DOT) edu.
%}

clc
addpath('datasets');
addpath('mfiles');
addpath('mex');

params = makeDefaultParams_depth; % default parameters for the saliency model

%% Change the parameters here for different datasets (NUS-3D,Gaze-3D,NCTU-3D) and number of images (1-3)
params.dataset = 'NUS-3D'; % identifies which dataset to use (choose either 'NUS-3D','Gaze-3D', or 'NCTU-3D')
num_images = 3; % number of images to process from each dataset (choose either 1,2, or 3)
%%

d_color = dir(['datasets/' params.dataset '/color/']); % find the color images
imgFiles_color = {d_color(~[d_color.isdir]).name};
d_depth = dir(['datasets/' params.dataset '/depth/']); % find the depth images
imgFiles_depth = {d_depth(~[d_depth.isdir]).name};

% error checking to make sure correct dataset is given
if isempty(imgFiles_color) || isempty(imgFiles_depth)
    fprintf(['Please check your param.dataset variable. Valid choices are: ''NUS-3D'', ''Gaze-3D'', or ''NCTU-3D''' '\n']);
    return;
end

h = cell(num_images,1); % initialize for storing conspicuity maps
for i=1:num_images % loop over images
    
    fprintf('Processing image %d of %d: computing saliency map ...\n\n',i,num_images);
        
    % Load image
    im.data = normalizeImage(im2double(imread(imgFiles_color{i})));
    if strcmp(params.dataset, 'Gaze-3D')
        load(imgFiles_depth{i})
        im.depth_data = Depth_map; % depth data is in .mat format, not image format
    else
        im.depth_data = normalizeImage(im2double(imread(imgFiles_depth{i})));
    end
    
    % Note: Gaze-3D dataset does not need edge cropping
    if strcmp(params.dataset, 'NUS-3D')
        % Crop image border to avoid edge effects (640x480 images)
        im.data = im.data(5:end-4,5:end-4,:); % 4 pixel border
        im.depth_data = im.depth_data(5:end-4,5:end-4,:);
    elseif strcmp(params.dataset, 'NCTU-3D')
        % Crop image border to avoid edge effects (1920x1080 images)
        im.data = im.data(41:end-40,41:end-40,:); % 40 pixel border
        im.depth_data = im.depth_data(41:end-40,41:end-40,:);
    end
    
    % Run proto-object based saliency model
    h = runProtoSal_depth(im,params); % returns conspicuity maps for each feature channel: intensity, color, orientation, depth
    salmap_nodepth = combineMaps_weight(h,0);
    % Note: in our paper, we weighted the depth channel 20%, but we increase it here to show the influence of depth information
    salmap_depth = combineMaps_weight(h,0.8);
%     salmap_depth = combineMaps_weight(h,0.2);
    
    figure;
    subplot(2,2,1),imagesc(im.data); title('RGB Image'); set(gca,'XTickLabel',[]); set(gca,'YTickLabel',[]);
    subplot(2,2,2),imagesc(im.depth_data); title('Depth Image'); set(gca,'XTickLabel',[]); set(gca,'YTickLabel',[]);
    subplot(2,2,3),imagesc(salmap_nodepth.data); title('No Depth Information'); set(gca,'XTickLabel',[]); set(gca,'YTickLabel',[]);
    subplot(2,2,4),imagesc(salmap_depth.data); title('Depth Information Added'); set(gca,'XTickLabel',[]); set(gca,'YTickLabel',[]);
end
