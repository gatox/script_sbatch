find . -type d -name "traj_*" -exec grep -q "Some important variables" {}/gen_results.out \; -exec echo {} \; | sort -t '_' -k 2 -n > trajectories_ok_list
find . -type d -name "traj_*" -exec grep -q "Convergence problem" {}/omolcas.log \; -exec echo {} \; | sort -t '_' -k 2 -n > convergence_problem_list
find . -type d -name "traj_*" -exec grep -q "No convergence after200 iterations" {}/omolcas.log \; -exec echo {} \; | sort -t '_' -k 2 -n > no_conv_rasscf_iterations
find . -type d -name "traj_*" -exec grep -q "No convergence after 399 Iterations" {}/omolcas.log \; -exec echo {} \; | sort -t '_' -k 2 -n > no_conv_scf_iterations
find . -type d -name "traj_*" -exec grep -q "Non-zero return code" {}/omolcas.log \; -exec echo {} \; | sort -t '_' -k 2 -n > non_zero_return_code
