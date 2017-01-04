function [h] = runProtoSal_depth(im,params)
%Runs the proto-object based saliency algorithm
%
%inputs:
%filename - filename of image
%
%By Alexander Russell and Stefan Mihalas, Johns Hopkins Univeristy, 2012

fprintf('\nStart Proto-Object Saliency\n')
%generate feature channels
img = generateChannels_depth(im,params);
%generate border ownership structures
[b1Pyr, b2Pyr, params]  = makeBorderOwnership_batch(img,params);
%generate grouping pyramids
gPyr = makeGrouping(b1Pyr,b2Pyr,params);
%normalize grouping pyramids and combine into final saliency map
h = ittiNorm_depth(gPyr,4); % 4 for 'full' down sampling

fprintf('\nDone\n\n')