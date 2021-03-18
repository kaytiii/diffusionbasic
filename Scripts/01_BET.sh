#/bin/bash

#############################################
# Skull Stripping via BET
# Kayti Keith - 3/9/21     
#############################################

#############################################
# Required file format: 
#  
# Study Folder
#    01_Protocols
#        IDs.txt  (ID file with list of all subject IDs)
#    02_Data
#        Subject_Folder
#            DWI.nii/bval/bvec/jason 
#############################################

printf "\033[1;94mPlease enter the path to your study folder: \033[0m \n" 
read folder_path
cd $folder_path


IDs=$folder_path/01_Protocols/IDs.txt
analysis=$folder_path/03_Analysis
SUBJ_IDs=$(cat $IDs)

mkdir -p $analysis 
mkdir -p $analysis/01_BET 

printf "\033[1;94mBeginning skull stripping and brain mask creation via BET.\033[0m \n"
printf "\033[1;94mPlease enter BET threshold (0-1): \033[0m"
read bet_thresh
printf "\033[1;94mBeginning BET with a threshold of $bet_thresh. \033[0m \n"

for i in $SUBJ_IDs ; do
  fslsplit $folder_path/02_Data/${i}/DWI.nii $folder_path/02_Data/${i}/DWI
  mv $folder_path/02_Data/${i}/DWI0000.nii.gz $folder_path/02_Data/${i}/DWI_B0.nii
  rm $folder_path/02_Data/${i}/DWI00*
  mkdir -p $analysis/01_BET/${i} 
  bet $folder_path/02_Data/${i}/DWI_B0.nii $analysis/01_BET/${i}/DWI_bet_"$bet_thresh".nii -m -f $bet_thresh
  gunzip $analysis/01_BET/${i}/DWI_bet_"$bet_thresh".nii.gz
  printf "\033[1;36mBET is complete for ${i} at a threshold of $bet_thresh.\033[0m \n"
done

printf "\033[1;32mBET is complete. \033[4m Please be sure to QC all BET outputs.\033[0m \n"