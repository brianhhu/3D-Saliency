function [pyr params] = makePyramid_batch(img,params)
%Makes the centre surround pyramid using a CS mask on each
%layer of the image pyramid
%
%inputs :
%img - input image
%params - model parameter structure
%
%outputs :
%pyr - image pyramid
%params - model parameter structure
%
%By Alexander Russell and Stefan Mihalas, Johns Hopkins University, 2012

if (nargin ~= 2)
    error('Incorrect number of inputs for makePyramid');
end
if (nargout ~= 2)
    error('Two output arguments required for makePyramid');
end

depth = params.maxLevel;
minsize = params.minSize;

pyr(1).data = img;
for l = 2:depth
    if strcmp(params.csPrs.downSample,'half')%downsample halfoctave
        pyr(l).data = imresize(pyr(l-1).data,0.7071,'cubic');
        if ( (size(pyr(l).data,1) < minsize) || (size(pyr(l).data,2) < minsize) ) % added by bh
%             fprintf('reached minimum size at level = %d. cutting off additional levels\n', l);
            params.maxLevel = l-1;
            params.csPrs.depth = l-1;
            params.evenCellPrs.maxLevel = l-1;
            params.oddCellPrs.maxLevel = l-1;
            params.bPrs.maxLevel = l-1;
            params.vmPrs.maxLevel = l-1;
            break;
        end
    elseif strcmp(params.csPrs.downSample,'full') %downsample full octave
        pyr(l).data = imresize(pyr(l-1).data,0.5,'cubic');
        if ( (size(pyr(l).data,1) < minsize) || (size(pyr(l).data,2) < minsize) ) % added by bh
%             fprintf('reached minimum size at level = %d. cutting off additional levels\n', l);
            params.maxLevel = l-1;
            params.csPrs.depth = l-1;
            params.evenCellPrs.maxLevel = l-1;
            params.oddCellPrs.maxLevel = l-1;
            params.bPrs.maxLevel = l-1;
            params.vmPrs.maxLevel = l-1;
            break;
        end
    else
        error('Please specify if downsampling should be half or full octave');
    end
end
