global thermo_data
thermo_data=[];
%n is the number of steps between 0 and 1 for x1 and x2
thermo_data.n = 251;
thermo_data.azeotrope_sensitivity = 0.001;
%all thermodynamic data is listed
thermo_data.lambda(1,1) = 1;
thermo_data.lambda(1,2) = 0.7486;
thermo_data.lambda(1,3) = 0.9402;
thermo_data.lambda(2,1) = 0.8397;
thermo_data.lambda(2,2) = 1;
thermo_data.lambda(2,3) = 0.3418;
thermo_data.lambda(3,1) = 0.6526;
thermo_data.lambda(3,2) = 0.3277;
thermo_data.lambda(3,3) = 1;
thermo_data.volgradient(1) = (1.2461*10^-3 - 1.1806*10^-3)/50;
thermo_data.volgradient(2) = (1.4205*10^-3 - 1.3316*10^-3)/50;
thermo_data.volgradient(3) = (1.3281*10^-3 - 1.4451*10^-3)/50;
thermo_data.volume(1) = 1/847;
thermo_data.volume(2) = 1/751;
thermo_data.volume(3) = 1/753;
thermo_data.antoineA(1) = 15.9008;
thermo_data.antoineA(2) = 15.7527;
thermo_data.antoineA(3) = 16.6513;
thermo_data.antoineB(1) = 2788.51;
thermo_data.antoineB(2) = 2766.63;
thermo_data.antoineB(3) = 2940.46;
thermo_data.antoineC(1) = -52.36;
thermo_data.antoineC(2) = -50.50;
thermo_data.antoineC(3) = -35.93;
n = thermo_data.n;
m = thermo_data.azeotrope_sensitivity;
%setting up mol fraction x1 and x2 as vectors
x1 = linspace(0,1,n);
x2 = linspace(0,1,n);
%T is produced as an n by n matrix
for i = 1:n
    for j = 1:n
        % if x1+x2 > 1 then system is unphysical so in these cases, set the value to 0 to make it
        % easy to remove these data later. This produces a triangle of zeroes
        if x1(i) + x2(j) > 1;
            T(i,j) = 0;
        else
            %this caluclates the temperature at this composition
            %firstly the compositions are changed and saved as global
            %variables
            thermo_data.x1 = x1(i);
            thermo_data.x2 = x2(j);
            %temperatures is found by minimising my function 'iteration'
            %initial guess of 330 was chosen since most binary mixtures had
            %bubble points around then - not too important tbh.
            thermo_data.bubbletemp(i,j) = fminsearch(@bubblepoint,330);
            T = thermo_data.bubbletemp;
            %compositions in the gas are calculated for each temperature
            y1(i,j) = thermo_data.y(1);
            y2(i,j) = thermo_data.y(2);
        end
    end
end
%this part searches for azeotropes
for i = 1:n
    for j = 1:n
        %the difference between the composition in liquid and vapour phase
        %calculated for component 1 and 2
        comp1_difference(i,j) = y1(i,j) - x1(j);
        comp2_difference(i,j) = y2(i,j) - x2(j);
        %if xi is very close to yi for both component 1 and 2, an azeotrope
        %is identified.
        if (comp1_difference(i,j) < m) && (comp1_difference(i,j) > -m) && (comp2_difference(i,j) < m) && (comp2_difference(i,j) > -m)
            azeotrope = [x1(i), x2(j)];
            disp(azeotrope)
        else
        end
    end
end
surf(x1,x2,T)



