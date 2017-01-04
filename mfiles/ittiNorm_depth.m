function h = ittiNorm_depth(gPyr,collapseLevel)
%Normalizes and combines the grouping pyramids into a saliency map
%This is performed in an identical manner to how the feature maps in the
%Itti et al (1998) paper are combined
%
%Inputs:
%gPyr - grouping pyramid
%collapseLevel - final merge level of all the conspicuity maps
%
%Outputs:
%h - saliency map data structure
%
%By Alexander Russell and Stefan Mihalas, Johns Hopkins University, 2012
fprintf('\nNormalizing Grouping Pyramids\n');
for m = 1:size(gPyr,2)
    if ~strcmp(gPyr{m}.type,'Orientation')
        %first sum subtypes across levels then normalize each level
        FM = [];
        clear CML
        for l = 1:size(gPyr{m}.subtype{1},2)
            FM(l).data= zeros(size(gPyr{m}.subtype{1}(l).data,1),size(gPyr{m}.subtype{1}(l).data,2));
            for sub = 1:size(gPyr{m}.subtype,2)
                FM(l).data = FM(l).data + maxNormalizeLocalMax(gPyr{m}.subtype{sub}(l).data,[0 10]);
            end
        end
        for l = 1:size(FM,2)
            CML(l).data = FM(l).data;%maxNormalizeLocalMax(FM(l).data,[0 10]);
        end
        CM{m}.data = zeros(size(FM(collapseLevel).data));
        for l = 1:size(CML,2)
            CM{m}.data = CM{m}.data + imresize(CML(l).data,[size(FM(collapseLevel).data,1) size(FM(collapseLevel).data,2)]);
        end
        
    elseif strcmp(gPyr{m}.type,'Orientation')
        %normalize pyramids for each angle separately then merge
        FM = gPyr{m}.subtype;
        CM{m}.data = zeros(size(FM{1}(collapseLevel).data));
        clear CML
        for sub = 1:size(FM,2)
            CML{sub}.data = zeros(size(FM{1}(collapseLevel).data));
            for l = 1:size(FM{m},2)
                FML{sub}(l).data = maxNormalizeLocalMax(FM{sub}(l).data,[0 10]);
                CML{sub}.data = CML{sub}.data + imresize(FML{sub}(l).data,[size(FM{1}(collapseLevel).data,1) size(FM{1}(collapseLevel).data,2)]);
            end
            CM{m}.data = CM{m}.data + CML{sub}.data; % original code
%             CM{m}.data = CM{m}.data + maxNormalizeLocalMax(CML{sub}.data,[0 10]); % paper version of the code?
        end
        
    else
        error('Please ensure algorithm operates on known feature types');
    end
end
h = CM; % individual conspicuity maps (combined across levels)
