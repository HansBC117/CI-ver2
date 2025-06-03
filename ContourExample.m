% ContourExample
clear all, close all
 
% loading X Y Z data from the mat file supposed for this example only:
load ContourExampleData

% renaming X, Y and Z to engine parameters that are easier to relate to
N = X;
BMEP = Y;
NOx = Z;

% 1D interpolation of BMEP with 100 points at each engine speed
points = 100;
% preparing the X Y and Z matrices for interpolation allong the first dimension (BMEP)
Nint1 = repmat([1500 2000 2500 3000 3500],points,1);
BMEPint1 = repmat(linspace(min(BMEP),max(BMEP),points)',1,5);
NOxint1 = [];

for i = 1:5
 
    % Selecting data at each engine speed
    index = find(N == Nint1(1,i));
 
    % sort the indeces so that the BMEP comes in ascending order:
    [notused sortorder] = sort(BMEP(index));
    index = index(sortorder);
 
    % creating a vector of the maximum BMEPs that could be achieved 
    BMEPborder(1,i) = BMEP(max(index));
 
    % performing the 1D interpolation at the specified engine speed 
    NOxint1(:,i) = interp1(BMEP(index),NOx(index),BMEPint1(:,i),'spline');
 
 
end
 
% preparing the X and Y matrices for interpolation allong the second dimension (N)
Nint2 = repmat(linspace(1500,3500,points),points,1);
BMEPint2 = repmat(linspace(min(BMEP),max(BMEP),points)',1,points);
 
% performing the interpolation to get the Z matrix. Here NOx concentrations
NOxint2 = interp2(Nint1,BMEPint1,NOxint1,Nint2,BMEPint2,'spline');
 
% 1D interpolation of the maximum BMEPs.
BMEPborderint = interp1(Nint1(1,:),BMEPborder,Nint2(1,:),'spline');
 
% Using the interpolated maximum BMEPs to create a matrix with NaN's outside the
% the engines performance range and one's inside. Multiplying this matrix on the 
% 2D interpolated data is a way to remove extrapolated data but with a smooth appearance.
NANmatrix = ones(size(BMEPint2));
NANmatrix(BMEPint2 > repmat(BMEPborderint,points,1)) = NaN;
 
% Creating contour plot and adding a fat line that shows the BMEP limit
figure
set(gcf,'name','Example value, say NOx concentration [ppm]')
[C,h] = contour(Nint2,BMEPint2,NANmatrix.*NOxint2,[280 290 300 310 325 350 400 500 600 700]); % with manual contour selection
%[C,h] = contour(Nint2,BMEPint2,NANmatrix.*NOxint2); % automatic contour selection
clabel(C,h)
hold on
plot(Nint2(1,:),BMEPborderint,'-k','LineWidth',2)
xlabel('N [rpm]')
ylabel('BMEP [kPa]')
title('Example value, say NOx concentration [ppm]')
ylim([min(BMEP) 1.05*max(BMEP)])
