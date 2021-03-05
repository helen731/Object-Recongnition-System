function result = siftCal(left,right)
%% converting image to GrayScale and double
fprintf('Loading images\n');
left=rgb2gray(left);
left=im2double(left);
right=rgb2gray(right);
right=im2double(right);

circles_left = findCircles(left);
circles_right = findCircles(right);
r_L = circles_left(:,2); 
c_L = circles_left(:,1);
r_R = circles_right(:,2); 
c_R = circles_right(:,1);
descriptor_L = find_sift(left, circles_left, 1.5);
descriptor_R = find_sift(right, circles_right, 1.5);

distance = dist2(descriptor_L,descriptor_R);
%% get the first n smallest distance pairs
fprintf('Finding smallest distance pairs\n');
smallestNum = 90;
for i = 1:smallestNum
    sortDis = sort(distance(:));
    [L,R] = find(distance<=sortDis(1),1);
    position_in_original_L = L;
    position_in_original_R = R;
    pairs(i,:) = [position_in_original_L r_L(position_in_original_L) c_L(position_in_original_L) ...
        position_in_original_R r_R(position_in_original_R) c_R(position_in_original_R)];
    distance(L,:)=10000;
    distance(:,R)=10000;
end


%% RANSAC
fprintf('Running RANSAC\n');
iterationNum = 5000;
threshold = 110;
for i = 1: iterationNum
    %get random initial inliers
    inliers = randi(smallestNum,6,1);
    %calculate pseudo inverse of matrix C 
    C = [];
    y = [];
    for j = 1: 6
        if j ==1
            C = [pairs(inliers(j),3) pairs(inliers(j),2) 1 0 0 0 ...
                -pairs(inliers(j),3)*pairs(inliers(j),6) -pairs(inliers(j),2)*pairs(inliers(j),6) ];
            C = [C;0 0 0 pairs(inliers(j),3) pairs(inliers(j),2) 1 ...
                -pairs(inliers(j),3)*pairs(inliers(j),5) -pairs(inliers(j),2)*pairs(inliers(j),5) ];
            y = [pairs(inliers(j),6);pairs(inliers(j),5)];
        else
            C = [C;pairs(inliers(j),3) pairs(inliers(j),2) 1 0 0 0 ...
                -pairs(inliers(j),3)*pairs(inliers(j),6) -pairs(inliers(j),2)*pairs(inliers(j),6)];
            C = [C;0 0 0 pairs(inliers(j),3) pairs(inliers(j),2) 1 ...
                -pairs(inliers(j),3)*pairs(inliers(j),5) -pairs(inliers(j),2)*pairs(inliers(j),5) ];
            y = [y;pairs(inliers(j),6);pairs(inliers(j),5)];
        end
    end
    p = C\y;
    M = [p(1:3)';p(4:6)';p(7:8)' 1];
    residual_total = 0;
    inliers = [];
    current_inliers = 0;
    for k = 1: smallestNum
        A = M*[pairs(k,3);pairs(k,2);1];
        x1 = A(1)/A(3);
        y1 = A(2)/A(3);
        residual = dist2([x1,y1], [pairs(k, 6),pairs(k, 5)]);
        if residual <= threshold
            current_inliers = current_inliers + 1;
            inliers = [inliers;k];
            residual_total = residual_total + residual;
        end
    end
    if i==1
        biggestInliers = current_inliers;
        inliers_final = inliers;
        residual_final = residual_total;
        transformation = M;
    elseif current_inliers>biggestInliers
        biggestInliers = current_inliers;
        inliers_final = inliers;
        residual_final = residual_total;
        transformation = M;
    end
end
fprintf('RANSAC finish\n');


if size(inliers_final,1)>11
    result = 1;
else
    result = 0;
end
end


