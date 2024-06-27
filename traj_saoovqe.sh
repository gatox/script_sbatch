find . -type d -name "traj_*" -exec grep -q "Some important variables" {}/gen_results.out \; -exec echo {} \; | sort -t '_' -k 2 -n > trajectories_ok_list
find . -type d -name "traj_*" -exec grep -q "SCF iterations in 100 iterations." {}/saoovqe.in.out \; -exec echo {} \; | sort -t '_' -k 2 -n > no_conv_scf_100_iterations
find . -type d -name "traj_*" -exec grep -q "CANCELLED AT" {}/saoovqe.in.out \; -exec echo {} \; | sort -t '_' -k 2 -n > cancelled_time_limit_iterations
