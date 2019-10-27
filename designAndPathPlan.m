% designAndPathPlan.m
%
% Main script to run the algorithm for finding optimal design and path plan
% for a non-constant curvature concentric tube. Takes a number of
% iterations, design vs. configuration space exploration weight, maximum
% step size for design and config space, and max number of iterations.
% Outputs the configuration for the best design and the path plan.
%
% Written by: Conor Messer
% Last Modified: 10/21/2019

% User-specified maximum size steps for Design and Configuration spaces
d_max_step = 1; % should this be different for the different params?
c_max_step = 1; % should this be different for insertion/rotation?

% User-specified ranges to define Design and Config spaces
init_range = [-20 20];
delta_range = [-20 20];
factor_range = [-5 5];
insertion_range = [0 20];  % given in cm
rotation_range = [-pi pi]; % given in radians

% Package range values for Design and Config space
design_ranges = [init_range;delta_range;factor_range];
config_ranges = [insertion_range;rotation_range];

% Defines base type names (linear, quadratic, sinusoidal, helix)
base_names = ['linear','quad','helix','sinu'];

for b = 1:4
    base = base_names(b);
    
    % Choose a random d in design space of this base
    % d includes bending coefficient, rate of change, and z factor
    % The d is the same for each, but for sinu, rate of change isn't used
    d_rand = randFromRange(design_ranges);

    % Insert d into Design graph
    % **** Just stored as array for now - could speed up using kd-tree***
    D = d_rand;
    % Initialize configuration graph with initial config (0 insertion, 0 rotation)
    C_map = containers.Map('KeyType','uint32','ValueType','any');
    C_mat = [0 0];  % stores the configuration (insertion, rotation) w/ index referenced in graph
    C_graph = digraph;  %use tree implementation? http://tinevez.github.io/matlab-tree/
    C_checked = true;
    this_C.mat = C_mat;
    this_C.graph = C_graph;
    this_C.checked = C_checked;
    C_map(1) = this_C;

    for i = 1:n
        if rand < p_explore
            [D,C_map] = newDesign(D,C_map,d_max_step,design_ranges); % adds random design and associated entry to map
        else
            D_ind = randi(length(D(:,1)));
            C_map = exploreDesign(D(D_ind,:),D_ind,C_map,c_max_step,config_ranges,obstacles); % adds node to one graph in C_map
            % should there be a boolean on designs to see if there is a
            % valid solution yet?
        end
    end

    % Find best configuration for this base
    % Search through all designs, collect ones that have a solution
    % Compare the cost for the solutions of those designs, choose best
    
end

% Find best configuration out of all bases

% Output configuration and path plan