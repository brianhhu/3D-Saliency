% combineMaps - returns the sum of a vector of maps.
%
% resultMap = combineMaps(maps,label)
%   Adds the data fields in the maps vactor and returns
%   the result as a map with label as the label.
%
% See also dataStructures.

% This file is part of the SaliencyToolbox - Copyright (C) 2006-2013
% by Dirk B. Walther and the California Institute of Technology.
% See the enclosed LICENSE.TXT document for the license agreement.
% More information about this project is available at:
% http://www.saliencytoolbox.net

function SM = combineMaps_weight(maps,depth_weight)

lm = length(maps); % number of features

SM.data = zeros(size(maps{1}.data));
for m = 1:lm % loop over features
    if m < lm
        SM.data = SM.data + (1-depth_weight) / 3 .* maxNormalizeLocalMax(maps{m}.data,[0 10]);
    else
        SM.data = SM.data + depth_weight .* maxNormalizeLocalMax(maps{m}.data,[0 10]);
    end
end