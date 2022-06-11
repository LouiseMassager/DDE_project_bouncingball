clear; close all; clc;

%% Creating the dataset

data = readmatrix('cluster_data.csv'); % read the data in the CSV file and convert it into a matrix

% Extract time and ball height of the experiment
T_exp = data(:,1);
H_exp = data(:,3);

n_data = size(T_exp,1); % number of samples in the dataset

% figure
% plot(T_exp, H_exp, '.r')
% xlabel("Time [s]")
% ylabel("Height of the ball [px]")

%% Computation of the velocity

V_exp = zeros(n_data,1); % Initial velocity will be zero
for i = 2:n_data
    dH = ( H_exp(i) - H_exp(i-1) ) / ( T_exp(i) - T_exp(i-1) );
    V_exp(i) = dH;
end

figure
plot(T_exp, V_exp, '.-r')
xlabel("Time [s]")
ylabel("Velocity of the ball [px/s]")

hold on

%% Cleaning the outliers

Data = [T_exp, V_exp]; % Group time and velocity in a matrix
[V_clean, outliers] = removeOutliers(Data, 550, 25); % custom function

n_data_new = size(V_clean,1);

plot(V_clean(:,1), V_clean(:,2), '-b')
plot(outliers(:,1), outliers(:,2), 'ob')

%% Save to file

% Initialization of storage arrays
X_save = zeros(n_data_new,1);
H_save = zeros(n_data_new,1);

for i = 1:n_data_new
    k = find(T_exp==V_clean(i,1)); % find the index of the time value in T_exp
    H_save(i) = H_exp(k);
    X_save(i) = data(k,2);
end

saveFile = "velocity_clean.csv";
writematrix([V_clean(:,1), X_save, H_save, V_clean(:,2)], saveFile);

%% Filtering

N = 400;
filter_x = @(Ts, x, x_prev, xf_prev) ( xf_prev * (2-N*Ts) + x * N*Ts + x_prev* N*Ts ) / (N*Ts+2);

vf_prev = V_clean(1,2);
V_filter = ones(n_data_new,1) * vf_prev; % First element in V_filter = V_clean(1,2)
for i = 2:n_data_new
    deltaT = V_clean(i,1) - V_clean(i-1,1);
    V_filter(i) = filter_x(deltaT, V_clean(i,2), V_clean(i-1,2), vf_prev);
    vf_prev = V_filter(i);
end

plot(V_clean(:,1), V_filter, '-g')

legend(["Original data", "Cleaned data", "Outlier", "Cleaned and filtered data"])