#!/bin/bash

# INPUT VARIABLES
QUEUE=$1
SBATCHFILE=new_saoovqe.sh
JOBID='$SLURM_JOBID'
WORKDIR='$SAOOVQE_WORKDIR'
NTASKS=1
NODES=1
mem='^[0-9.-]+$'
MEM=$2                           # Memory
Mem='16GB'


# CHECK INPUT DATA
echo ""
echo "****************************************************************************************************************************************"
echo "*                        This is an SLURM script for computing calculaions using SAOOVQE in XMARIS cluster.                            *"
echo "* It will request some important information from the user for a correct submission of the job in the cluster.                         *"
echo "*                                                                                                                                      *"
echo "*                           ******** FOR BEGINNERS ********                                                                            *"
echo "*                                                                                                                                      *"
echo "*  If you don't know the number of tasks per node and the number of memory per cpu, you can use the default values.                    *"
echo "*                                                                                                                                      *"
echo "*  The default values are:  1 task per node and 16GB of memory per cpu.                                                                *"
echo "*                                                                                                                                      *"
echo "*                                                                                                                                      *"
echo "*  TYPE:                                                                                                                               *" 
echo "*             qc_maris.sh partition_name                                                                                               *"
echo "*  Where:                                                                                                                              *"
echo "*          partition_name = name of the partition                                                                                      *"
echo "*                                                                                                                                      *"
echo "*                                                                                                                                      *"
echo "****************************************************************************************************************************************"
echo ""
echo ""

if [ -z $1 ]; then
echo "************************************************************************************************************************************"
echo "*    There is a problem with the requiered keywords passed to the script.                                                          *"
echo "*  IMPORTANT:                                                                                                                      *"
echo "* The script will include a list of SLURM directives (or commands) to tell the job scheduler what to do.                           *"
echo "*  Details and options for these scripts are below.                                                                                *"
echo "*                                                                                                                                  *"
echo "*  TYPE:   qc_maris.sh partition_name                                                                                              *"
echo "*                                                                                                                                  *"
echo "*  Where:                                                                                                                          *"
echo "*          partition_name = name of the partition                                                                                  *"
echo "*                                                                                                                                  *"
echo "*                                                                                                                                  *"
echo "*                                      Your job submission has been aborted                                                        *"
echo "*                                           ** HASTA LA VISTA, BABY **                                                             *"
echo "***********************************************************************************************************************************"
echo ""
echo ""
exit
fi

# CHECK THE SELECTION OF PARTITION (Partition is a QUEUE for jobs)


case "$QUEUE" in
compAMD*)
     printf "%s\n" " The partition chosen is compAMD* with max of 15 days" ;;
compAMDlong)
     printf "%s\n" " The partition chosen is compAMDlong with max of 60 days" ;;
compIntel)
     printf "%s\n" " The partition chosen is compIntel with max of 5 days and 12 hours" ;;
gpuIntel)
     printf "%s\n" " The partition chosen is gpuIntel with max of 3 days and 12 hours" ;;
ibIntel)
     printf "%s\n" " The partition chosen is ibIntel with max of 3 days and 12 hours" ;;

*) printf "\n ************************** ERROR IN JOB SUBMISSION ************************** \n"
   printf "\n%s\n" "An incorrect choice of a partition has been passed to the script."
   printf "%s\n\n" "Please choose one of the following:"
   printf "%s\n" "compAMD*, compAMDlong, compIntel, gpuIntel and ibIntel"
   printf "%s\n\n" "***********************************************************************"
   exit 15 ;;
esac

# FORM THE BATCH FILE FOR USE WITH SLURM
echo "#!/bin/bash" > $SBATCHFILE
echo "#SBATCH --no-requeue" >> $SBATCHFILE
echo "#SBATCH --partition=$QUEUE" >> $SBATCHFILE
echo "#SBATCH --job-name=saoovqe.in" >> $SBATCHFILE
echo "#SBATCH --output=saoovqe.in.out" >> $SBATCHFILE

if [ "$1" == "compAMD*" ]; then
   echo "#SBATCH --nodes=$NODES " >> $SBATCHFILE
   echo "#SBATCH --ntasks-per-node=$NTASKS " >> $SBATCHFILE
   echo "#SBATCH --time=360:00:00 " >> $SBATCHFILE
fi

if [ "$1" == "compAMDlong" ]; then
   echo "#SBATCH --nodes=$NODES " >> $SBATCHFILE
   echo "#SBATCH --ntasks-per-node=$NTASKS " >> $SBATCHFILE
   echo "#SBATCH --time=1440:00:00 " >> $SBATCHFILE
fi

if [ "$1" == "compIntel" ]; then
   echo "#SBATCH --nodes=$NODES " >> $SBATCHFILE
   echo "#SBATCH --ntasks-per-node=$NTASKS " >> $SBATCHFILE
   echo "#SBATCH --time=132:00:00 " >> $SBATCHFILE
fi

if [ "$1" == "gpuIntel" ]; then
   echo "#SBATCH --nodes=$NODES " >> $SBATCHFILE
   echo "#SBATCH --ntasks-per-node=$NTASKS " >> $SBATCHFILE
   echo "#SBATCH --time=84:00:00 " >> $SBATCHFILE
fi

if [ "$1" == "ibIntel" ]; then
   echo "#SBATCH --nodes=$NODES " >> $SBATCHFILE
   echo "#SBATCH --ntasks-per-node=$NTASKS " >> $SBATCHFILE
   echo "#SBATCH --time=168:00:00 " >> $SBATCHFILE
fi


#CHECKING THE MEMORY PER CPU

if [ $2 =~ $mem ]; then

 printf "%s\n" " The memory per cpu chosen is: $MEM"
 echo "#SBATCH --mem=$MEM " >> $SBATCHFILE

else if [ -z $2]; then
 printf "%s\n" " You are using the memory per cpu  as a default value"
 printf "%s\n" " The memory per cpu chosen is: 1GB"
 echo "#SBATCH --mem=$Mem " >> $SBATCHFILE

else

printf "\n ************************** ERROR IN JOB SUBMISSION ************************************* \n"
   printf "\n%s\n" "An incorrect choice of memory per cpu has been passed to the script."
   printf "%s\n\n" "Please choose positive integer values"
   printf "%s\n" " Please be aware that the memory is defined in GB"
   printf "%s\n\n" "*****************************************************************************************"
   exit 15
fi
fi


echo "source activate old_saoovqe" >> $SBATCHFILE 

echo "export SAOOVQE_WORKDIR=/marisdata/salazar/SCRATCH/saoovqe_$JOBID" >> $SBATCHFILE
echo "mkdir -p $WORKDIR" >> $SBATCHFILE

echo "python" "/marisdata/salazar/pysurf_fssh/pysurf/fssh/vv_three_deco_fssh_lzsh_propagator.py" >> $SBATCHFILE


# SUBMIT THE SCRIPT
sbatch $SBATCHFILE
squeue -u $USER

rm $SBATCHFILE
