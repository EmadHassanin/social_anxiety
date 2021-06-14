# 1.0 Importing Files ----

source("scripts/organize_ukbb.R")

feather_file <- file.path(data_path,"ukbb","ukb_df.feather")

ukbb_df <- arrow::read_feather(feather_file,col_select = c(col_vars$col_name))

ukbb_sa <- arrow::read_feather(feather_file,
                               col_select = c("eid",
                               matches(c("20537","20539","20544"))))

ukbb_pcs <- arrow::read_feather(feather_file,
                               col_select = c("eid",
                                              matches(c("22009"))))



social_anxiety <-  
  ukbb_sa %>% 
  filter_at(vars(4:ncol(.)),
            any_vars(. =="Social anxiety or social phobia")) %>% 
  filter(frequency_of_difficulty_controlling_worry_during_worst_period_of_anxiety_f20537_0_0 == 
           "Often") %>% 
  left_join(ukbb_df) %>% 
  #count(ethnic_background_f21000_0_0 )
  filter(genetic_ethnic_grouping_f22006_0_0 == "Caucasian" &
         ethnic_background_f21000_0_0 == "British"  ) %>% 
  mutate(pheno = 1)
  
  

## all Mental and behavioral disorders [F00-F99]

all_mental_disordes <- icd10 %>% filter(str_detect(code_icd10 , "^(F[0-99][0-9])"))


Controls <- 
  ukbb_sa %>% 
  filter_at(vars(4:ncol(.)),
            all_vars(is.na(. ))) %>% 
  anti_join(all_mental_disordes ) %>% 
  left_join(ukbb_df) %>% 
  filter(genetic_ethnic_grouping_f22006_0_0 == "Caucasian" &
           ethnic_background_f21000_0_0 == "British"  ) %>% 
  mutate( pheno = 0)

sa <- rbind(social_anxiety,Controls) 

sa %>%  
  dplyr::select(
    eid, sex_f31_0_0, age_when_attended_assessment_centre_f21003_0_0, pheno
  ) %>% 
  left_join(ukbb_pcs %>% 
              dplyr::select(eid, 
                            genetic_principal_components_f22009_0_1,
                            genetic_principal_components_f22009_0_2,
                            genetic_principal_components_f22009_0_3,
                            genetic_principal_components_f22009_0_4)) %>% 
  left_join(conv %>% dplyr::select(V1,V7), by = c("eid" = "V7"))-> sa_final

sa_final %>% 
  dplyr::select(-V1) %>% 
  dplyr::select(eid,everything()) %>% 
  inner_join(sample_fam_id  %>% dplyr::select(ID_1), by = c("eid"="ID_1")) -> prova1


fwrite(prova1, "/home/ubuntu/Emad/output/ukbb/pheno/social_anxiety/sa_covariates" , sep = "\t")

prova1 <- fread("/home/ubuntu/Emad/output/ukbb/pheno/social_anxiety/sa_covariates")
