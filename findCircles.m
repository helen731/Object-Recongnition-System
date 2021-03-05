function circles = findCircles(img)
fprintf('Finding key points\n');
%% calculate sigma_n for different scale space
k=1.18;
sigma_n(1)=2;
for i=2 : 15
    sigma_n(i)= k*sigma_n(i-1);
end

%% creating filter and scale space 
for i=1:14
        filter1 = fspecial('Gaussian', 21, sigma_n(i));
        filter2 = fspecial('Gaussian', 21, sigma_n(i+1));
        filter = filter2 - filter1;  % DoG
        response = imfilter(img,filter,'replicate');
        scale_space(:,:,i) = response;  
end


%% perform nonmaximum suppression in scale space
%2d nonmaximum suppression
for i=1:14
   nms_2d(:,:,i) = ordfilt2(scale_space(:,:,i),9,ones(3,3)) ; 
end

%3d nonmaximum suppression and find maximum value
nms_3d = max(nms_2d,[],3);
nms_3d= (nms_3d==nms_2d).*nms_2d;
% makesure only one point is stored
[r,c] = size(img);
for i=1:r
    for j = 1:c
        for k = 1:13
            if nms_3d(i,j,k) == nms_3d(i,j,k+1)
                nms_3d(i,j,k) = 0;
            end
        end
    end
end
%% Finding coordinates of the maximas and drawing circles for that maxima.
for i=1: 14
    radius=sqrt(2) * sigma_n(i); %Calculating Radius
    thresh=.007;               %Setting threshold
    [x,y] = find((scale_space(:,:,i)==nms_3d(:,:,i))&(scale_space(:,:,i)>thresh));

    if i==1
        x1=x;
        y1=y;
        rad=radius;        
        rad=repmat(radius,size(x,1),1);

    else
        rad2=repmat(radius,size(x,1),1);
        rad=cat(1,rad,rad2);
        x1=cat(1,x1,x);
        y1=cat(1,y1,y);
    end

end
%show_all_circles(img, y1, x1, rad,'r' , 1.5); 
circles = [y1 x1 rad];