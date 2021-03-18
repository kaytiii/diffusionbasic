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

printf "\033[1;94mPlease enter the path to your study folder: \033[0m \n" #prompt for path input
read folder_path #reads path input
cd $folder_path #changes directory to path input

IDs=$folder_path/01_Protocols/IDs.txt #sets ID text file as a variable
analysis=$folder_path/03_Analysis #sets Analysis folder path as variable
SUBJ_IDs=$(cat $IDs) #sets the list in the IDs.txt as an array

mkdir -p $analysis #creates 03_Analysis folder
mkdir -p $analysis/01_BET #creates 01_BET folder

printf "\033[1;94mBeginning skull stripping and brain mask creation via BET.\033[0m \n"
printf "\033[1;94mPlease enter BET threshold (0-1): \033[0m" #prompts user for BET threshold
read bet_thresh #reads BET threshold
printf "\033[1;94mBeginning BET with a threshold of $bet_thresh. \033[0m \n"

for i in $SUBJ_IDs ; do #loops through ID list array
  fslsplit $folder_path/02_Data/${i}/DWI.nii $folder_path/02_Data/${i}/DWI #splits original 4D into 3Ds
  mv $folder_path/02_Data/${i}/DWI0000.nii.gz $folder_path/02_Data/${i}/DWI_B0.nii #renames first 3D to 'DWI_B0'
  rm $folder_path/02_Data/${i}/DWI00* #removes all other 3Ds
  mkdir -p $analysis/01_BET/${i} #creates subject folders within 01_BET
  bet $folder_path/02_Data/${i}/DWI_B0.nii $analysis/01_BET/${i}/DWI_bet_"$bet_thresh".nii -m -f $bet_thresh #BET
  gunzip $analysis/01_BET/${i}/DWI_bet_"$bet_thresh".nii.gz #unzips BET outputs
  printf "\033[1;36mBET is complete for ${i} at a threshold of $bet_thresh.\033[0m \n"
done

printf "\033[1;32mBET is complete. \033[4m Please be sure to QC all BET outputs.\033[0m \n"