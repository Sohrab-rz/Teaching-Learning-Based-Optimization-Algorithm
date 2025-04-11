%______________________________________________________________________%
    % ------------  Creator    :      Sohrab Rezaei         ----------- %
    % ------------  K. N. Toosi University of Technology ----------- % 
    % --------------------------  TLBO    -------------------------- %
%_____________________________________________________________________%


% Define your desired function below and then run the main TLBO code 
% (MIN or Max) 
% Enjoy! 

function z=desired_fun(xx)
    z=zeros(size(xx,1),1);
    for i=1:size(xx,1)
        x=xx(i,1);
        y=xx(i,2);
        z(i)=(3*(1-x)^2)*exp(-x^2-(y+1)^2)-10*(x/5-x^3-y^5)*exp(-x^2-y^2)-(1/3)*exp(-(x+1)^2-y^2);
    end
