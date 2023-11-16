function output = bubblepoint(inputs)
T = inputs;
global thermo_data
%firstly import the thermodnyamic data and mol fractions from resolver
%by using global data, this iteration function can be made a function of only
%Temperature, whilst still allowing me to vary composition in a for loop.
x(1) = thermo_data.x1;
x(2) = thermo_data.x2;
x(3) = 1- x(1) - x(2);
volumeT1 = thermo_data.volume();
lambdaT1 = thermo_data.lambda();
volgrad = thermo_data.volgradient;
%the dependence of volume with temperature is assumed to be linear and
%calculated for each species as a function of T
for i = 1:3
    volumeT2(i) = volumeT1(i) + (T-323)*thermo_data.volgradient(i);
end
%new values of lambda can be calculated
for i = 1:3
    for j = 1:3
        lambdaT2(i,j) = lambdaT1(i,j) * volumeT2(j)*volumeT1(i) * exp(1/T) / (volumeT2(i) * volumeT1(j) * exp(1/323));
    end
end

lambda = lambdaT2;
%by definition lambaii = 1 so these values are reset to 1
lambda(1,1) =  1;
lambda(2,2) =  1;
lambda(3,3) =  1;
%the activity coefficient is calulated for each species using the formula
for i = 1:3
    loggamma(i) = 1 - log( x(1)*lambda(i,1) +x(2)*lambda(i,2)+x(3)*lambda(i,3) ) - x(1)*lambda(1,i)/(x(1)*lambda(1,1)+x(2)*lambda(1,2) + x(3)*lambda(1,3))- x(2)*lambda(2,i)/(x(1)*lambda(2,1)+x(2)*lambda(2,2) + x(3)*lambda(2,3)) - x(3)*lambda(3,i)/(x(1)*lambda(3,1)+x(2)*lambda(3,2) + x(3)*lambda(3,3));
    gamma(i) = exp(loggamma(i));
end
%saturation pressure for each species is calculated using antoine
Psat(1) = 133.322*exp(thermo_data.antoineA(1) - thermo_data.antoineB(1)/(T+thermo_data.antoineC(1)));
Psat(2) = 133.322*exp(thermo_data.antoineA(2) - thermo_data.antoineB(2)/(T+thermo_data.antoineC(2)));
Psat(3) = 133.322*exp(thermo_data.antoineA(3) - thermo_data.antoineB(3)/(T+thermo_data.antoineC(3)));
%partial pressure of each species is calculated
for i = 1:3
    Py(i) = Psat(i) * x(i) * gamma(i);
end
%total pressure is calculated
Ptotal = Py(1)+Py(2)+Py(3);
%the output is the pressure - target pressure. The absolute of this is
%taken so that any minimise function will find a minimum where Ptotal =
%120000.
output = abs(120000-Ptotal);