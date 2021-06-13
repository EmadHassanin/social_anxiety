conv <- fread("/home/ubuntu/Emad/ukb_biobank/200_exome/conversion_table")

sample_fam_id <- fread("/home/ubuntu/Emad/ukb_biobank/genotype_data/array/ukb52446_imp_chr1_v3_s487296.sample")

fam_id <- fread("/home/ubuntu/UKBB_genotypes/bk_ukb_cal_allChrs_XY.fam")

fam_id %>% 
  left_join(conv %>% dplyr::select(V1,V7) , by =  c( "V1" = "V1")) %>% 
  dplyr::select(-V1,-V2) %>% 
  rename(V1 = V7) %>% 
  mutate(V2 = V1) %>% 
  dplyr::select(V1,V2,everything()) %>% 
  as.data.frame() -> new_fam1

new_fam1 %>% 
  left_join(prova1 %>% dplyr::select(eid,pheno) , by =  c( "V1" = "eid")) -> e

names(new_fam1) <- NULL

fwrite(new_fam1,"/home/ubuntu/UKBB_genotypes/convID_ukb_cal_allChrs_XY.fam",sep = " ")