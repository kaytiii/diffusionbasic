#/bin/bash

#############################################
# Skull Stripping via BET
# Kayti Keith - 3/9/21      
#############################################

printf "\033[1;94mPlease enter the path to your study folder:\033[0m  \n" 
read folder_path
cd $folder_path

IDs=$folder_path/01_Protocols/IDs.txt
analysis=$folder_path/03_Analysis
SUBJ_IDs=$(cat $IDs)
 
mkdir -p $analysis/02_DTIFIT

printf "\033[1;94mBeginning tensor fitting via DTIFIT.\033[0m  \n"
printf "\033[1;94mPlease enter BET threshold (0-1) you used in previous step: \033[0m"
read bet_thresh

for i in $SUBJ_IDs ; do
  mkdir -p $analysis/02_DTIFIT/${i}
  dtifit -k $folder_path/02_Data/${i}/DWI.nii -o $analysis/02_DTIFIT/${i}/dtifit -m $analysis/01_BET/${i}/DWI_bet_"$bet_thresh".nii -r $folder_path/02_Data/${i}/DWI.bvec -b $folder_path/02_Data/${i}/DWI.bval
  gunzip $analysis/02_DTIFIT/${i}/dtifit*
  printf "\033[1;36mDTIFIT complete for ${i}.\033[0m  \n"
  mkdir $analysis/02_DTIFIT/${i}/Eigen
  for f in V1 V2 V3 L1 L2 L3 ; do
    mv $analysis/02_DTIFIT/${i}/dtifit_${f}.nii $analysis/02_DTIFIT/${i}/Eigen/dtifit_${f}.nii
  done
done

printf "\033[1;32mDTIFIT is complete. \033[4m Please be sure to QC DTIFIT outputs.\033[0m  \n"