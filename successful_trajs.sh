find . -type d -name "traj_*" -exec grep -q "Some important variables" {}/gen_results.out \; -exec echo {} \; | sort -t '_' -k 2 -n > trajectories_ok_list
