%************************************************%
%OHM 39003
%Genetic Algorithm: In-Class Feb 27, 2020
%Author: Internet Source
%************************************************%
clear all
close all
clc

%GA Params
pop_size = 4;
mutation_probability = 0.6;
number_of_generations = 100;

%Range of Values
x_max = 32;
x_min = 0;

%Variables & Lists to be used during the code
gen_1_xvalues = [];
gen_1_fvalues = [];
generations_x = [];
generations_f = [];
fitness = 0;

%Size of the string in bit
x_size = length(dec2bin(x_max));

%Initial Population
for i=1:pop_size,
	x_tmp = round(rand*(x_max-x_min)+x_min);
	gen_1_xvalues(i) = x_tmp;

	f_tmp = x_function(x_tmp);
	gen_1_fvalues(i) =  f_tmp;
    fitness = fitness + f_tmp;

end

%Create total fitness
	%fitness = fitness + f_tmp;
    
%Getting maximum value for initial population
max_f_gen1 = 0;
for i=1:pop_size,
		if gen_1_fvalues(i) >= max_f_gen1,
			max_f_gen1 = gen_1_fvalues(i);
			max_x_gen1 = gen_1_xvalues(i);
        end
end

% alternatively use sorting 
% M= [gen_1_xvalues; gen_1_fvalues]'
% A= sortrows(M, 2)
% max_gen1=0;
% max_gen1 = A(length(A),:)
% max_x_gen1=max_gen1(1)
% max_f_gen1 = max_gen1(2)

%Starting GA loop
for i=1:number_of_generations,
    %Reseting list for 2nd generation
	gen_2_xvalues = [];
	gen_2_fvalues = [];
	selected = [];
    
    %Selecting individuals to reproduce
	for j=1:pop_size,
		ind_sel = random_selection(gen_1_fvalues);
        %ind_sel =  random_selection(gen_1_fvalues)
		selected(j) = gen_1_xvalues(ind_sel);
    end

	%Crossing the selected members
	for j=1:2:pop_size,
		sel_ind_A = dec2bin(selected(j),x_size);
		sel_ind_B = dec2bin(selected(j+1),x_size);
   
    
	%select point to cross over
		cut_point = round(1+rand*(x_size-1));
        cut_point1 = round(1+rand*(x_size-1));
        a = cut_point;
        b = cut_point1;
        if a < b
            cut_point = a;
            cut_point1 = b;
        else
            cut_point = b;
            cut_point1 = a;
        end
	
	%new individual AB
		ind_AB = strcat(sel_ind_A(1:cut_point),sel_ind_B(cut_point:cut_point1),sel_ind_A(cut_point1:x_size));

	%mutation AB
		ran_mut = rand;
		if ran_mut < mutation_probability
			gene_position = round(1 + rand*(x_size-1));
            pos = round(1 + rand*(x_size-1));
			ind_mut = interchanging(ind_AB, gene_position,pos);
			ind_AB = ind_mut;
        end
	
	%new individual BA
		ind_BA = strcat(sel_ind_B(1:cut_point),sel_ind_A(cut_point:x_size),sel_ind_B(cut_point1:x_size));
        
        
	%mutation BA
		ran_mut = rand();
		if ran_mut < mutation_probability
			gene_position = round(1 + rand*(x_size-1));
			pos = round(1 + rand*(x_size-1));
			ind_mut = interchanging(ind_BA, gene_position,pos);
			ind_BA = ind_mut;
        end

	%Creating Generation 2
		new_AB = bin2dec(ind_AB);
		gen_2_xvalues(j) =  new_AB;

		new_f_AB = x_function(new_AB);
		gen_2_fvalues(j) = new_f_AB;

		new_BA = bin2dec(ind_BA);
		gen_2_xvalues(j+1) = new_BA;

		new_f_BA = x_function(new_BA);
		gen_2_fvalues(j+1) = new_f_BA;
    end
    
        %Getting maximum value
        max_f_gen2 = 0;
        for j=1:pop_size,
            if gen_2_fvalues(j) >= max_f_gen2,
                max_f_gen2 = gen_2_fvalues(j);
                max_x_gen2 = gen_2_xvalues(j);
            end
        end


       %Elitism one individual
    	if max_f_gen1 > max_f_gen2,
        	max_f_gen2 = max_f_gen1;
        	max_x_gen2 = max_x_gen1;
        	gen_2_fvalues(1) = max_f_gen1;
        	gen_2_xvalues(1) = max_x_gen1;
        end
        
	
    	%Transform gen2 into gen1
        gen_1_xvalues = gen_2_xvalues;
        gen_1_fvalues = gen_2_fvalues;
        max_x_gen1 = max_x_gen2;
        max_f_gen1 = max_f_gen2;
        generations_x(i) = max_x_gen2;
        generations_f(i) = max_f_gen2;

        %Creating new fitness
        fitness = 0;
        for j=1:pop_size,
            f_tmp = x_function(gen_1_xvalues(j));
            fitness = fitness + f_tmp;
        end
        
        
end

%Plotting

%Ploting  Function
figure(1);
x = x_min:.1:x_max;
y = x_function(x);
plot (x,y);
title('F(x)');

%Ploting data for last generation
figure(2);
plot(gen_2_xvalues,gen_2_fvalues, 'bo');
xlabel('x');
ylabel('F(x)');
title('Data for last generation');

%Ploting data for maximum values for each generation
figure(3);
nog = 1:1:number_of_generations;
plot(nog,generations_f, 'ro');
xlabel('Generations');
ylabel('F(x) Maximum');
title('Maximum F(X) for each generation');


