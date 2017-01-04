function cPyr = makeComplexEdge(EPyr, OPyr)
%make complex edges from edges computed using even and odd gabor functions
%
%Inputs
%EPyr - even Gabor filter edge pyramid
%OPyr - odd Gabor filter edge pyramid
%
%Outputs:
%cPyr - complex edge pyramid

for l = 1:size(EPyr,2)
%     temp = zeros(size(EPyr(l).orientation(1).data)); % added by bh
    for ori = 1:size(EPyr(l).orientation,2)
        cPyr(l).orientation(ori).data = sqrt(EPyr(l).orientation(ori).data.^2 ...
            +OPyr(l).orientation(ori).data.^2);
%         cPyr(l).orientation(ori).data(cPyr(l).orientation(ori).data < 0.1*max(cPyr(l).orientation(ori).data(:))) = 0; % thresholding?
%         temp = cat(3,temp,cPyr(l).orientation(ori).data); % added by bh
    end
%     [~,O] = max(temp,[],3); % calculate max over orientations
%     for ori1 = 1:size(cPyr(l).orientation,2)
%         temp(:,:,ori1+1) = temp(:,:,ori1+1) .* (O == ori1+1); % set to max orientation
% %         cPyr(l).orientation(ori1).data = cPyr(l).orientation(ori1).data .* (O == ori1+1);
%     end
%     temp1 = padarray(temp(:,:,2:end),[0 0 1],'circular'); % circular padding
%     kern(1,1,1:3) = [0.5 1 0.5]; % convolution kernel for across angles
%     temp1 = convn(temp1,kern,'same');
%     temp1 = temp1(:,:,2:end-1);
%     for ori2 = 1:size(cPyr(l).orientation,2)
%         cPyr(l).orientation(ori2).data = temp1(:,:,ori2); %cPyr(l).orientation(ori1).data .* (O == ori1+1);
%     end
end
