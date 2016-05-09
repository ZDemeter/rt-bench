% -------- WARNING -------- 
% This file is automatically generated by 'analysis/process.m'. It reports
%   the data of the experiment 'm120_700', extracted from
%   'm120_700.json'. It is going to be loaded in the preample in the
%   analysis file 'results/m120_700/analysis.m'
%
% In case you make any modification that you would like to save, make sure
%   not to run 'analysis/process.m' again. You actually should not need to
%   re-run 'analysis/process.m'
% -------- WARNING --------

experiment_name = 'm120_700';

%% Experiment source data
% File with original input data in the format
%    #Time, #Thread-number, #Job-number, #CPU
input_file = 'm120_700.csv';

%% Thread data
thread_names = {'thread1'; 'thread2'; };
thread_run = [1;2];
thread_num = length(thread_run);
cpu_set = 0;
% if affinity_map(i,k) = 1, then i-th thread may execute over k-th CPU
affinity_map = [1;1];

%% Simulation data
% simulation duration extracted from JSON file
sim_duration = 50;

% thread_window(i,1) = start instant of first job of i-th thread
% thread_window(i,2) = start instant of last job of i-th thread
thread_window = [5668586.269675 5668635.220489;5668586.276277 5668635.219122];
analysis_window = [5668586.276277 5668635.219122];

% thread_nJobs(i) = number of i-th thread's jobs in interval
%   [thread_window(i,1), thread_window(i,2)]
thread_nJobs = [7860;7972];
migr_nJobs = [0;0];
run_map = [1;1];

%% Analysis data
% Time horizon, in seconds, over which computing the supply function and
%   the best (alpha,Delta) approximation. It should be significantly
%   smaller than the simulation time specified in the .json file
%   ("global.duration"), like one order of magnitude less. Default is
%   'sim_duration/20'
time_horizon = 50.000000;

% The reference thread should have the following characteristics:
%   (1) the job body is the same as in the simulation
%   (2) the reference thread runs as uninterrupted as possible, for example
%       with high priority (SCHED_FIFO) and no migration
% 'ref_infile' is the file name of such a processed trace
ref_infile = 'm120_700.1.csv';
% ref_infile = '../results/sched_fifo/sched_fifo.1.csv';
ref_data = csvread(ref_infile);
tol_ref = 0;      % tolerance to compute nominal job length
[ref_seq, ind_last] = uniformYvalues(ref_data(:,1), tol_ref, sum(thread_nJobs)+thread_num);

