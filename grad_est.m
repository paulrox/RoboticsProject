function [ grad ] = grad_est( r, type, q_k )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if strcmp(type, 'manip')
    obj_f = @(x) -r.maniplty(x, 'yoshikawa');
elseif strcmp(type, 'joint')
    % Distance from mechanical joint limits
    j_mid = mean([r.qlim(:,2) r.qlim(:,1)], 2);
    obj_f = @(x) (1 / (2*r.n)) * sumsqr((x' - j_mid) ./ (r.qlim(:,2) - ...
        r.qlim(:,1)));
elseif strcmp(type, 'plane')
    obj_f = @(x) -dist_plane(r, x);
end

xk = q_k;
tk = 1;
D = [0 0 0 0 0 0 0 0 ;
0 0 0 0 0 0 0 1 ;
0 0 0 0 0 0 1 0 ;
0 0 0 0 0 0 1 1 ;
0 0 0 0 0 1 0 0 ;
0 0 0 0 0 1 0 1 ;
0 0 0 0 0 1 1 0 ;
0 0 0 0 0 1 1 1 ;
0 0 0 0 1 0 0 0 ;
0 0 0 0 1 0 0 1 ;
0 0 0 0 1 0 1 0 ;
0 0 0 0 1 0 1 1 ;
0 0 0 0 1 1 0 0 ;
0 0 0 0 1 1 0 1 ;
0 0 0 0 1 1 1 0 ;
0 0 0 0 1 1 1 1 ;
0 0 0 1 0 0 0 0 ;
0 0 0 1 0 0 0 1 ;
0 0 0 1 0 0 1 0 ;
0 0 0 1 0 0 1 1 ;
0 0 0 1 0 1 0 0 ;
0 0 0 1 0 1 0 1 ;
0 0 0 1 0 1 1 0 ;
0 0 0 1 0 1 1 1 ;
0 0 0 1 1 0 0 0 ;
0 0 0 1 1 0 0 1 ;
0 0 0 1 1 0 1 0 ;
0 0 0 1 1 0 1 1 ;
0 0 0 1 1 1 0 0 ;
0 0 0 1 1 1 0 1 ;
0 0 0 1 1 1 1 0 ;
0 0 0 1 1 1 1 1 ;
0 0 1 0 0 0 0 0 ;
0 0 1 0 0 0 0 1 ;
0 0 1 0 0 0 1 0 ;
0 0 1 0 0 0 1 1 ;
0 0 1 0 0 1 0 0 ;
0 0 1 0 0 1 0 1 ;
0 0 1 0 0 1 1 0 ;
0 0 1 0 0 1 1 1 ;
0 0 1 0 1 0 0 0 ;
0 0 1 0 1 0 0 1 ;
0 0 1 0 1 0 1 0 ;
0 0 1 0 1 0 1 1 ;
0 0 1 0 1 1 0 0 ;
0 0 1 0 1 1 0 1 ;
0 0 1 0 1 1 1 0 ;
0 0 1 0 1 1 1 1 ;
0 0 1 1 0 0 0 0 ;
0 0 1 1 0 0 0 1 ;
0 0 1 1 0 0 1 0 ;
0 0 1 1 0 0 1 1 ;
0 0 1 1 0 1 0 0 ;
0 0 1 1 0 1 0 1 ;
0 0 1 1 0 1 1 0 ;
0 0 1 1 0 1 1 1 ;
0 0 1 1 1 0 0 0 ;
0 0 1 1 1 0 0 1 ;
0 0 1 1 1 0 1 0 ;
0 0 1 1 1 0 1 1 ;
0 0 1 1 1 1 0 0 ;
0 0 1 1 1 1 0 1 ;
0 0 1 1 1 1 1 0 ;
0 0 1 1 1 1 1 1 ;
0 1 0 0 0 0 0 0 ;
0 1 0 0 0 0 0 1 ;
0 1 0 0 0 0 1 0 ;
0 1 0 0 0 0 1 1 ;
0 1 0 0 0 1 0 0 ;
0 1 0 0 0 1 0 1 ;
0 1 0 0 0 1 1 0 ;
0 1 0 0 0 1 1 1 ;
0 1 0 0 1 0 0 0 ;
0 1 0 0 1 0 0 1 ;
0 1 0 0 1 0 1 0 ;
0 1 0 0 1 0 1 1 ;
0 1 0 0 1 1 0 0 ;
0 1 0 0 1 1 0 1 ;
0 1 0 0 1 1 1 0 ;
0 1 0 0 1 1 1 1 ;
0 1 0 1 0 0 0 0 ;
0 1 0 1 0 0 0 1 ;
0 1 0 1 0 0 1 0 ;
0 1 0 1 0 0 1 1 ;
0 1 0 1 0 1 0 0 ;
0 1 0 1 0 1 0 1 ;
0 1 0 1 0 1 1 0 ;
0 1 0 1 0 1 1 1 ;
0 1 0 1 1 0 0 0 ;
0 1 0 1 1 0 0 1 ;
0 1 0 1 1 0 1 0 ;
0 1 0 1 1 0 1 1 ;
0 1 0 1 1 1 0 0 ;
0 1 0 1 1 1 0 1 ;
0 1 0 1 1 1 1 0 ;
0 1 0 1 1 1 1 1 ;
0 1 1 0 0 0 0 0 ;
0 1 1 0 0 0 0 1 ;
0 1 1 0 0 0 1 0 ;
0 1 1 0 0 0 1 1 ;
0 1 1 0 0 1 0 0 ;
0 1 1 0 0 1 0 1 ;
0 1 1 0 0 1 1 0 ;
0 1 1 0 0 1 1 1 ;
0 1 1 0 1 0 0 0 ;
0 1 1 0 1 0 0 1 ;
0 1 1 0 1 0 1 0 ;
0 1 1 0 1 0 1 1 ;
0 1 1 0 1 1 0 0 ;
0 1 1 0 1 1 0 1 ;
0 1 1 0 1 1 1 0 ;
0 1 1 0 1 1 1 1 ;
0 1 1 1 0 0 0 0 ;
0 1 1 1 0 0 0 1 ;
0 1 1 1 0 0 1 0 ;
0 1 1 1 0 0 1 1 ;
0 1 1 1 0 1 0 0 ;
0 1 1 1 0 1 0 1 ;
0 1 1 1 0 1 1 0 ;
0 1 1 1 0 1 1 1 ;
0 1 1 1 1 0 0 0 ;
0 1 1 1 1 0 0 1 ;
0 1 1 1 1 0 1 0 ;
0 1 1 1 1 0 1 1 ;
0 1 1 1 1 1 0 0 ;
0 1 1 1 1 1 0 1 ;
0 1 1 1 1 1 1 0 ;
0 1 1 1 1 1 1 1 ;
1 0 0 0 0 0 0 0 ;
1 0 0 0 0 0 0 1 ;
1 0 0 0 0 0 1 0 ;
1 0 0 0 0 0 1 1 ;
1 0 0 0 0 1 0 0 ;
1 0 0 0 0 1 0 1 ;
1 0 0 0 0 1 1 0 ;
1 0 0 0 0 1 1 1 ;
1 0 0 0 1 0 0 0 ;
1 0 0 0 1 0 0 1 ;
1 0 0 0 1 0 1 0 ;
1 0 0 0 1 0 1 1 ;
1 0 0 0 1 1 0 0 ;
1 0 0 0 1 1 0 1 ;
1 0 0 0 1 1 1 0 ;
1 0 0 0 1 1 1 1 ;
1 0 0 1 0 0 0 0 ;
1 0 0 1 0 0 0 1 ;
1 0 0 1 0 0 1 0 ;
1 0 0 1 0 0 1 1 ;
1 0 0 1 0 1 0 0 ;
1 0 0 1 0 1 0 1 ;
1 0 0 1 0 1 1 0 ;
1 0 0 1 0 1 1 1 ;
1 0 0 1 1 0 0 0 ;
1 0 0 1 1 0 0 1 ;
1 0 0 1 1 0 1 0 ;
1 0 0 1 1 0 1 1 ;
1 0 0 1 1 1 0 0 ;
1 0 0 1 1 1 0 1 ;
1 0 0 1 1 1 1 0 ;
1 0 0 1 1 1 1 1 ;
1 0 1 0 0 0 0 0 ;
1 0 1 0 0 0 0 1 ;
1 0 1 0 0 0 1 0 ;
1 0 1 0 0 0 1 1 ;
1 0 1 0 0 1 0 0 ;
1 0 1 0 0 1 0 1 ;
1 0 1 0 0 1 1 0 ;
1 0 1 0 0 1 1 1 ;
1 0 1 0 1 0 0 0 ;
1 0 1 0 1 0 0 1 ;
1 0 1 0 1 0 1 0 ;
1 0 1 0 1 0 1 1 ;
1 0 1 0 1 1 0 0 ;
1 0 1 0 1 1 0 1 ;
1 0 1 0 1 1 1 0 ;
1 0 1 0 1 1 1 1 ;
1 0 1 1 0 0 0 0 ;
1 0 1 1 0 0 0 1 ;
1 0 1 1 0 0 1 0 ;
1 0 1 1 0 0 1 1 ;
1 0 1 1 0 1 0 0 ;
1 0 1 1 0 1 0 1 ;
1 0 1 1 0 1 1 0 ;
1 0 1 1 0 1 1 1 ;
1 0 1 1 1 0 0 0 ;
1 0 1 1 1 0 0 1 ;
1 0 1 1 1 0 1 0 ;
1 0 1 1 1 0 1 1 ;
1 0 1 1 1 1 0 0 ;
1 0 1 1 1 1 0 1 ;
1 0 1 1 1 1 1 0 ;
1 0 1 1 1 1 1 1 ;
1 1 0 0 0 0 0 0 ;
1 1 0 0 0 0 0 1 ;
1 1 0 0 0 0 1 0 ;
1 1 0 0 0 0 1 1 ;
1 1 0 0 0 1 0 0 ;
1 1 0 0 0 1 0 1 ;
1 1 0 0 0 1 1 0 ;
1 1 0 0 0 1 1 1 ;
1 1 0 0 1 0 0 0 ;
1 1 0 0 1 0 0 1 ;
1 1 0 0 1 0 1 0 ;
1 1 0 0 1 0 1 1 ;
1 1 0 0 1 1 0 0 ;
1 1 0 0 1 1 0 1 ;
1 1 0 0 1 1 1 0 ;
1 1 0 0 1 1 1 1 ;
1 1 0 1 0 0 0 0 ;
1 1 0 1 0 0 0 1 ;
1 1 0 1 0 0 1 0 ;
1 1 0 1 0 0 1 1 ;
1 1 0 1 0 1 0 0 ;
1 1 0 1 0 1 0 1 ;
1 1 0 1 0 1 1 0 ;
1 1 0 1 0 1 1 1 ;
1 1 0 1 1 0 0 0 ;
1 1 0 1 1 0 0 1 ;
1 1 0 1 1 0 1 0 ;
1 1 0 1 1 0 1 1 ;
1 1 0 1 1 1 0 0 ;
1 1 0 1 1 1 0 1 ;
1 1 0 1 1 1 1 0 ;
1 1 0 1 1 1 1 1 ;
1 1 1 0 0 0 0 0 ;
1 1 1 0 0 0 0 1 ;
1 1 1 0 0 0 1 0 ;
1 1 1 0 0 0 1 1 ;
1 1 1 0 0 1 0 0 ;
1 1 1 0 0 1 0 1 ;
1 1 1 0 0 1 1 0 ;
1 1 1 0 0 1 1 1 ;
1 1 1 0 1 0 0 0 ;
1 1 1 0 1 0 0 1 ;
1 1 1 0 1 0 1 0 ;
1 1 1 0 1 0 1 1 ;
1 1 1 0 1 1 0 0 ;
1 1 1 0 1 1 0 1 ;
1 1 1 0 1 1 1 0 ;
1 1 1 0 1 1 1 1 ;
1 1 1 1 0 0 0 0 ;
1 1 1 1 0 0 0 1 ;
1 1 1 1 0 0 1 0 ;
1 1 1 1 0 0 1 1 ;
1 1 1 1 0 1 0 0 ;
1 1 1 1 0 1 0 1 ;
1 1 1 1 0 1 1 0 ;
1 1 1 1 0 1 1 1 ;
1 1 1 1 1 0 0 0 ;
1 1 1 1 1 0 0 1 ;
1 1 1 1 1 0 1 0 ;
1 1 1 1 1 0 1 1 ;
1 1 1 1 1 1 0 0 ;
1 1 1 1 1 1 0 1 ;
1 1 1 1 1 1 1 0 ;
1 1 1 1 1 1 1 1 ;
];

D = [D; -D];
 
numBasis = 512;
min = obj_f(xk);
i_min = -1;

for i = 1 : numBasis
    if (obj_f(xk + tk*D(i,:)) < min)
        min = obj_f(xk + tk*D(i,:));
        i_min = i;
    end;
end;

grad = D(i_min,:);

end

