function [b1Pyr b2Pyr params]  = makeBorderOwnership_batch(img,params)
%Calculates grouping and border ownership for the input image im
%
%Inputs:
%   im - image structure on which to perform grouping and border ownership
%   params
%
%Outputs:
%   b1Pyr, b2Pyr - Border ownership activity (left and right)
%   params
%
%By Alexander Russell and Stefan Mihalas, Johns Hopkins University, 2012


%% EXTRACT EDGES

for m = 1:size(img,2)
    fprintf('\nAssigning Border Ownership on ');
    fprintf(img{m}.type);    
    fprintf(' channel:\n');    
    for sub = 1:size(img{m}.subtype,2)        
        fprintf('Subtype %d of %d : ',sub,size(img{m}.subtype,2));
        map = img{m}.subtype{sub}.data;         
        [imPyr params] = makePyramid_batch(map,params);
        %% -----------------Edge Detection ------------------------------------
        EPyr = edgeEvenPyramid_batch(imPyr,params);
        OPyr = edgeOddPyramid_batch(imPyr,params);
        cPyr = makeComplexEdge(EPyr,OPyr);
        
        %% ----------------make image pyramid ---------------------------------
        if strcmp(img{m}.subtype{sub}.type ,'Orientation') %generate gabor pyramid
            fprintf('%d deg\n',rad2deg(img{m}.subtype{sub}.ori));
            csPyr = gaborPyramid_batch(imPyr,img{m}.subtype{sub}.ori,params);
        else %generate normal center surround pyramid            
            fprintf(img{m}.subtype{sub}.type);
            fprintf('\n');
            csPyr = csPyramid_batch(imPyr,params);
        end
        [csPyrL csPyrD] = seperatePyr(csPyr);
        [csPyrL csPyrD] = normCSPyr2_batch(csPyrL,csPyrD);
             
        %% GENERATE BORDER OWNERSHIP AND GROUPING MAPS
        %Get border Ownership Pyramids
        [bPyr1_1 bPyr2_1 bPyr1_2 bPyr2_2] = borderPyramid_batch(csPyrL,csPyrD,cPyr,params);
        if strcmp(img{m}.subtype{sub}.type ,'Depth')  % don't need to sum because we don't use both C-S differences
            
            if strcmp(params.dataset,'NUS-3D') % Note: NUS-3D uses range data, so depth differences are reversed
                b1Pyr{m}.subtype{sub} = bPyr1_2; % NUS-3D dataset
                b2Pyr{m}.subtype{sub} = bPyr2_2;
            else
                b1Pyr{m}.subtype{sub} = bPyr1_1; % NCTU-3D and Gaze-3D datasets
                b2Pyr{m}.subtype{sub} = bPyr2_1;
            end
            
        else
            b1Pyr{m}.subtype{sub} = sumPyr(bPyr1_1,bPyr1_2);
            b2Pyr{m}.subtype{sub} = sumPyr(bPyr2_1,bPyr2_2);
        end
        
        if strcmp(img{m}.subtype{sub}.type,'Orientation')
            b1Pyr{m}.subname{sub} =   [num2str(rad2deg(img{m}.subtype{sub}.ori)) ' deg']; 
            b2Pyr{m}.subname{sub} =   [num2str(rad2deg(img{m}.subtype{sub}.ori)) ' deg']; 
        else
            b1Pyr{m}.subname{sub} =   img{m}.subtype{sub}.type; 
            b2Pyr{m}.subname{sub} =   img{m}.subtype{sub}.type; 
        end
    end
    b1Pyr{m}.type = img{m}.type;
    b2Pyr{m}.type = img{m}.type;
end



