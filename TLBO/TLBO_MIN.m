%______________________________________________________________________%
    % ------------  Creator    :      Ali Rezaei         ----------- %
    % ------------  K. N. Toosi University of Technology ----------- % 
    % ------------      Advanced Control Systems Lab     ----------- %
    % ------------   Email: a.rezaei2@email.kntu.ac.ir   ----------- %
    % -------------------- TLBO - Minimization --------------------- %
%_____________________________________________________________________%

%% init
clc;
clear;
close all; 
%% cost function
pfun=@desired_fun; % cost function

%% TLBO init
res=400; 
ps=20;          % number of students
n_d=2;          % dimension (number of inputs)
d=1;            % number of subjects which are takenbye students
n_g=200;         % max generation 
n_i=0;           % number of iterations
ub=3*ones(1,n_d);    % upper bound to vars
lb=-3*ones(1,n_d);   % lower bound
r=1;
true_flag=1;
k=1;
range=repmat((ub-lb),ps,1);
lower=repmat(lb,ps,1);
out_new_1=zeros(ps,1);
in_new_1=rand(ps,n_d).*range+lower; % initial random solution

% initial knowledge //
for i=1:ps
    x=in_new_1(i,1:n_d);
    out=pfun(x);    % minimize problem
    out_new_1(i,1)=out;
end 
% \\

%% main loop (while)
flag=1;
while(flag)
    n_i=n_i+1;
    k=k+1;
    
    % teacher phase starts  --------------------------------------------// 
    mean_v=mean(in_new_1);
    indext=find(out_new_1==min(out_new_1)); % teacher position
    teacher_position=indext;
    teacher=zeros(1,n_d);
    tf=randi(2);
    diff=zeros(1,n_d);
    for j=1:n_d
        teacher(1,j)=in_new_1(teacher_position(1,1),j);
        diff(1,j)=rand*(teacher(1,j)-tf*mean_v(1,j));
    end

    in_new=zeros(ps,n_d);
    out_new=zeros(ps,1);
    for i=1:ps
        for j=1:n_d
            in_new(i,j)=in_new_1(i,j)+diff(1,j);
            if in_new(i,j)>ub(1,j)
                in_new(i,j)=ub(1,j);
            elseif in_new(i,j)<lb(1,j)
                in_new(i,j)=lb(1,j);
            end
        end
        
        x=in_new(i,1:n_d);
        out_new(i,1)=pfun(x);
        if out_new(i,1)>out_new_1(i,1) % if old knowledge is better keep it!
            out_new(i,1)=out_new_1(i,1);
            in_new(i,:)=in_new_1(i,:);
        end
    end
    % teaching phase finished -----------------------------------------\\

    % learner phase starts --------------------------------------------//     
    for i=1:ps
        for j=1:n_d
            index1=randi(numel(out_new_1));
            rand_st=index1;
            st_rnd_1=zeros(1,n_d);
            for kk=1:n_d
                st_rnd_1(1,kk)=in_new(rand_st,kk);
            end
            if out_new_1(index1,1)>out_new(i,1)
                sgn=-1;
            elseif out_new_1(index1,1)<=out_new(i,1)
                sgn=1;
            end

            in_new_1(i,j)=in_new_1(i,j)+sgn*rand*(st_rnd_1(1,j)-in_new(i,j));
            if in_new_1(i,j)>ub(1,j)
                in_new_1(i,j)=ub(1,j);
            elseif in_new_1(i,j)<lb(1,j)
                in_new_1(i,j)=lb(1,j);
            end
        end
        
        x=in_new_1(i,1:n_d);
        out_new_1(i,1)=pfun(x);
        if out_new_1(i,1)>out_new(i,1) % if old knowledge is better keep it!
            out_new_1(i,1)=out_new(i,1);
            in_new_1(i,:)=in_new(i,:);
        end
       % learner phase finished ----------------------------------------\\ 

        best_solution_position=find(out_new_1==min(out_new_1));
        global_min=out_new_1(best_solution_position(1,1));
        if n_i==n_g
            flag=0;
        else 
            flag=1;
        end

    end
    
end

disp("number of iterations: "+num2str(n_i))
disp("global minimum cost: " +num2str(global_min))
disp("global min location: x1= "+num2str(in_new_1(best_solution_position(1,1),1))+", x2= "+num2str(in_new_1(best_solution_position(1,1),2)))


%% plotting peaks function
xi = linspace(lb(1),ub(1),res);
yi = linspace(lb(2),ub(2),res);
[X,Y] = meshgrid(xi,yi);
z=pfun([X(:),Y(:)]);
z=reshape(z,size(X));
surf(X,Y,z,'MeshStyle','none','EdgeColor','interp');
colorbar
hold on
plot3(in_new_1(best_solution_position(1,1),1),in_new_1(best_solution_position(1,1),2),global_min,'rX','markersize',20);

figure()
contourf(X,Y,z,20)
colorbar
hold on
plot(in_new_1(best_solution_position(1,1),1),in_new_1(best_solution_position(1,1),2),'rx','markersize',7);



