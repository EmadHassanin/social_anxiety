# Organize uk_biobank phenotype data ----

# 1.0 Load libraries ----
print("install and loading dependencies packages")

#install.packages("pacman") 
library("pacman")

#devtools::install_github("kenhanscombe/ukbtools", build_vignettes = TRUE, dependencies = TRUE, force = TRUE)

pacman::p_load(tidyverse     # tidy data
               , tictoc      # checking time 
               , furrr       # functional programing with map()
               , future      # parallel computing
               , arrow       # apache arrow provides powerful package for sharing data
               , data.table  # exporting data as .txt
               , ggpubr      # add themes and visualization prop. to ggplot
               , e1071
               )    

#install.packages("arrow", repos = c("https://dl.bintray.com/ursalabs/arrow-r"))

#library("arrow")

# 2.0 Importing Files ----

# UKBB

data_path <- "/home/ubuntu/Emad/output/"


col_vars <- 
  tribble(
    ~col_var             , ~col_name,
    "id"                 , "eid",
    "sex"                , "sex_f31_0_0",
    "age_at_assessment"  , "age_when_attended_assessment_centre_f21003_0_0",
    "age_at_death"       , "age_at_death_f40007_2_0",
    "body_mass_index"    , "body_mass_index_bmi_f21001_0_0",
    "socioeconomic"      , "townsend_deprivation_index_at_recruitment_f189_0_0",
    "ethnicity"          , "ethnic_background_f21000_0_0",
    "employment"         , "current_employment_status_f6142_0_0",
    "centre"             , "uk_biobank_assessment_centre_f54_0_0",
    "Genotype_batch"     , "genotype_measurement_batch_f22000_0_0",
    "Genotype_plate"     , "genotype_measurement_plate_f22007_0_0",
    "Genotype_well"      , "genotype_measurement_well_f22008_0_0" ,
    "Genetic_sex"        , "genetic_sex_f22001_0_0",
    "Genetic_kinship"    , "genetic_kinship_to_other_participants_f22021_0_0",
    "Genetic_ethnic"     , "genetic_ethnic_grouping_f22006_0_0",
    "Sex chromosome aneuploidy", "sex_chromosome_aneuploidy_f22019_0_0",
    "Outliers for heterozygosity or missing rate", "outliers_for_heterozygosity_or_missing_rate_f22027_0_0",
    "Heterozygosity"     , "heterozygosity_f22003_0_0",
    "Heterozygosity, PCA corrected", "heterozygosity_pca_corrected_f22004_0_0",
    "Missingness"        , "missingness_f22005_0_0" ,
    #"Genetic principal components", "" ,
    "Used in genetic principal components", "used_in_genetic_principal_components_f22020_0_0"
  )

# ukbb_df <- arrow::read_feather(feather_file,
#                                col_select = c(col_vars$col_name,  matches("age_at_cancer_diagnosis") ,
#                                               matches("cancer_code_selfreported"),
#                                               matches("noncancer_illness_code_selfreported"),
#                                               matches("type_of_cancer"),
#                                               matches("interpolated_age_of_participant"),
#                                               matches("date_of_cancer_diagnosis"),
#                                               matches("^diagnoses.*icd"),
#                                               matches("^diagnoses.*icd"),
#                                               behaviour_of_cancer_tumour_f40012_0_0,
#                                               matches("date_of_attending_assessment_centre"),
#                                               matches("22009"), matches("41280"),matches("41262"),
#                                               matches("41281"), matches("41263"),
#                                               matches("month_of_birth_f52"),
#                                               matches("year_of_birth_f34_0_0"),
#                                               matches("illnesses_of"),
#                                               matches("f87"),
#                                               matches("30770"),
#                                               matches("21003"),
#                                               matches("41282")))


# diagnosis data

## non-cancer

feather_file <- file.path(data_path ,"ukbb/diagnosis","self_reported.feather")
self_reported<- arrow::read_feather(feather_file) %>% as.data.frame()


feather_file <- file.path(data_path ,"ukbb/diagnosis","icd10.feather")
icd10 <- arrow::read_feather(feather_file) %>% as.data.frame()

feather_file <- file.path(data_path ,"ukbb/diagnosis","icd9.feather")
icd9 <- arrow::read_feather(feather_file) %>% as.data.frame()


feather_file <- file.path(data_path ,"ukbb/diagnosis","opcs4.feather")
opcs4 <- arrow::read_feather(feather_file) %>% as.data.frame()

