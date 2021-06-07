# 1.0 Importing Files ----

source("scripts/organize_ukbb.R")

feather_file <- file.path(data_path,"ukbb","ukb_df.feather")

ukbb_df <- arrow::read_feather(feather_file,
                               col_select = c(col_vars$col_name,
                               matches("