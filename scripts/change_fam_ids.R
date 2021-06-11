conv <- fread("/home/ubuntu/Emad/ukb_biobank/200_exome/conversion_table")

fam_id <- fread("/home/ubuntu/UKBB_genotypes/bk_ukb_cal_allChrs_XY.fam")

fam_id %>% 
  left_join(conv %>% dplyr::select(V1,V7) , by =  c( "V1" = "V1")) %>% 
  dplyr::select(-V1) %>% 
  rename(V1 = V7) %>% 
  dplyr::select(V1,everything()) -> new_fam1

fwrite(new_fam1,"/home/ubuntu/UKBB_genotypes/convID_ukb_cal_allChrs_XY.fam",sep = " ")