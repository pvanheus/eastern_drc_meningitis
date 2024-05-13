pacman::p_load(tidyverse, janitor, lubridate, rio, sf, geojsonsf, raster)
start_lab <- 25
end_lab <- 36

# these blank columns get incorrectly imported
drop_columns <- c(1, 48, 49)
sample_list <- import("LineList.xlsx", skip=2) %>% select(-any_of(drop_columns))
names(sample_list)[start_lab:end_lab] <- unname(sample_list[1,start_lab:end_lab])

sample_list <- clean_names(sample_list)
saved_names = names(sample_list)
# now re-read the sample list
na_values = c("INCONNU", "INC", "")
sample_list <- import("LineList.xlsx", skip=4, header=F,
                      na=na_values) %>% select(-any_of(drop_columns))
names(sample_list) <- saved_names

# most of the lab results columns are numeric, but the conclusion ones are not
ct_value_columns <- names(sample_list)[start_lab:end_lab][-c(5,6,11,12)]
sample_list <- sample_list %>% mutate_at(ct_value_columns, as.numeric)

# remove the M and ADL from the ages column
clean_ages <- function(x) x %>% gsub(pattern="[^0-9]*", replace="") %>% as.numeric()
sample_list <- sample_list %>% mutate_at("age_nombre", clean_ages)

skimr::skim(sample_list)

bad_samples <- sample_list %>% filter(hexa_ic == 0 | hexb_ic == 0)
good_samples <- sample_list %>% filter(hexa_ic != 0 & hexb_ic != 0)

ct_cutoff <- 30
pathogen_ct_columns <- setdiff(ct_value_columns, c("hexa_ic", "hexb_ic"))
low_ct_samples <- sample_list %>% filter(fama_e_coli_k < ct_cutoff |
                                         roxa_group_b_streptococcus < ct_cutoff |
                                        cy5a_haemophilus_influenzae < ct_cutoff |
                                          famb_listeria_monocytogenes < ct_cutoff |
                                          roxb_neisseria_meningitidis < ct_cutoff |
                                          cy5b_streptococcus_pneumoniae < ct_cutoff)

low_ct_samples <- low_ct_samples %>% mutate(pathogen = case_when(
  fama_e_coli_k < ct_cutoff ~ as.factor('ecoli'),
  roxa_group_b_streptococcus < ct_cutoff ~ as.factor('gbs'),
  cy5a_haemophilus_influenzae < ct_cutoff ~ as.factor('hib'),
  famb_listeria_monocytogenes < ct_cutoff ~ as.factor('list'),
  roxb_neisseria_meningitidis < ct_cutoff ~ as.factor('nm'),
  cy5b_streptococcus_pneumoniae < ct_cutoff ~ as.factor('strep')))

low_ct_samples <- low_ct_samples %>% mutate(pathogen_ct = case_when(
  fama_e_coli_k < ct_cutoff ~ fama_e_coli_k,
  roxa_group_b_streptococcus < ct_cutoff ~ roxa_group_b_streptococcus,
  cy5a_haemophilus_influenzae < ct_cutoff ~ cy5a_haemophilus_influenzae,
  famb_listeria_monocytogenes < ct_cutoff ~ famb_listeria_monocytogenes,
  roxb_neisseria_meningitidis < ct_cutoff ~ roxb_neisseria_meningitidis,
  cy5b_streptococcus_pneumoniae < ct_cutoff ~ cy5b_streptococcus_pneumoniae))

ggplot(low_ct_samples, 
       aes(x=date_de_reception, y=pathogen_ct, color=pathogen, shape=zone_de_sante)) + 
  scale_shape_discrete(na.value=18) + 
  geom_point() + 
  labs(y="Ct value", x="Date of reception at lab")

