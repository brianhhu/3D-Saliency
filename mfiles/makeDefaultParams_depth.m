function params =  makeDefaultParams_depth
%Sets the default parameters for the grouping saliency map
%
%inputs: none
%
%Outputs:
%params - parameter structure for grouping saliency map
%
%By Alexander Russell and Stefan Mihalas, Johns Hopkins University, 2012

fprintf('\nCreating parameters. \n');

%pyramid levels over which to compute
minLevel = 1;%leave as 1
maxLevel =10; %How many times do you want to downsample the pyramid

%Set downsampling mode
downSample = 'full'; %downsample by 'half' or 'full' octave. better performance at full

params.channels = ['ICOT']; %feature channels on which to operate
                           %I - intensity
                           %C - color opponency
                           %O - orientation
                           %T - depth

params.maxLevel = maxLevel;
params.minSize = 3; % minimum image size after downsampling


%ENTER EDGE MAP ORIENTATIONS (DEG) FOR 1ST QUADRANT ONLY INTO ORI
%   - computations are done on ori and ori + 90 degrees
ori = [0 45];
oris = deg2rad([ori (ori+90)] );

%Enter zero crossing radius of Center surround and x where the std of the outer gauss = x*(std inner gauss)
[sigma1,sigma2] = calcSigma(2,3);

%Center-Surround parameters
params.csPrs.inner = sigma1;
params.csPrs.outer =sigma2;
params.csPrs.depth = maxLevel;
params.csPrs.downSample = downSample;

% center-surround mask
csPrs = params.csPrs;
params.csPrs.CSmsk = makeCentreSurround(csPrs.inner,csPrs.outer);

%get radius of zero crossing in center surround mask
temp = params.csPrs.CSmsk(round(size(params.csPrs.CSmsk,1)/2),:);
temp(temp>0)= 1;
temp(temp<0)= -1;
zc = temp(round(size(params.csPrs.CSmsk,2)/2):end-1)-temp(round(size(params.csPrs.CSmsk,1)/2)+1:end);
R0 = find(abs(zc)==2);
fprintf('Center Surround Radius is %d pixels. \n\n',R0);

%gabor filter parameters for orientation channel
params.gaborPrs.lamba = 8; %wavelenth
params.gaborPrs.sigma = 0.4*params.gaborPrs.lamba; %std of gaussian
params.gaborPrs.gamma = 0.8;%aspect ratio

% make gabor pyramid masks
gaborPrs = params.gaborPrs;
for i = 1:length(oris)
    params.gaborPrs.Evmsk{i} = makeEvenOrientationCells(oris(i),gaborPrs.lamba,gaborPrs.sigma,gaborPrs.gamma);
end

%even orientation cell parameters
params.evenCellPrs.minLevel = minLevel;
params.evenCellPrs.maxLevel = maxLevel;
params.evenCellPrs.oris = oris;
params.evenCellPrs.numOri = length(oris);
params.evenCellPrs.lambda = 4; %gabor filter wavlength
params.evenCellPrs.sigma = 0.56*params.evenCellPrs.lambda; %std of gaussian in gabor filter
params.evenCellPrs.gamma = 0.5; %aspect ratio of gabor filter

% make even mask
evenprs = params.evenCellPrs;
for i = 1:evenprs.numOri
    params.evenCellPrs.Evmsk{i} =  makeEvenOrientationCells(evenprs.oris(i),evenprs.lambda,evenprs.sigma,evenprs.gamma);
end

%odd orientation cell parameters
params.oddCellPrs.minLevel = minLevel;
params.oddCellPrs.maxLevel = maxLevel;
params.oddCellPrs.oris = oris;
params.oddCellPrs.numOri = length(oris);
params.oddCellPrs.lambda = 4;
params.oddCellPrs.sigma = 0.56*params.oddCellPrs.lambda;
params.oddCellPrs.gamma = 0.5;

% make odd mask
oddprs = params.oddCellPrs;
for i = 1:oddprs.numOri    
    params.oddCellPrs.Oddmsk1{i} = makeOddOrientationCells_batch(oddprs.oris(i),oddprs.lambda,oddprs.sigma,oddprs.gamma);
end

%border pyramid paramers
params.bPrs.minLevel = minLevel;
params.bPrs.maxLevel = maxLevel;
params.bPrs.numOri = length(oris);
params.bPrs.alpha = 1;
params.bPrs.oris = oris;
params.bPrs.CSw = 1; %inhibition between CS pyramids

%von Mises distribution paramers
params.vmPrs.minLevel = minLevel;
params.vmPrs.maxLevel = maxLevel;
params.vmPrs.oris = oris;
params.vmPrs.numOri = length(oris);
params.vmPrs.R0 =R0;

% make von Mises masks
vmPrs = params.vmPrs;
dim1 = -3*vmPrs.R0:3*vmPrs.R0;
dim2 = dim1;
for i = 1:vmPrs.numOri
    [params.vmPrs.msk_1{i},params.vmPrs.msk_2{i}] =  makeVonMises(vmPrs.R0, vmPrs.oris(i)+pi/2,dim1,dim2);
end

%Grouping Cell inhibition parameters
params.giPrs.w_sameChannel = 1;% Inhibitory weight for same channel inhibition



