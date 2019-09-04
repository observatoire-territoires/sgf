library(tidyverse)
library(foreign)
library(janitor)

#### fonction pour import simple d'un dataset

f_dl_import_dataset <- function(id_theme,name_theme, id_dataset){
  
  # dl
  # curl_download(paste0("https://www.insee.fr/fr/statistiques/fichier/",id_theme,"/",name_theme,"_",id_dataset,".dbf"),
  #               paste0("./data/",name_theme,"_",id_dataset,".dbf"))
  
  # import
  data = read.dbf(paste0("./data/",name_theme,"_",id_dataset,".dbf"), as.is = T)  %>%
    mutate_if(is.integer, as.numeric) 
  
}

test <- f_dl_import_dataset(id_theme <- "2653233",
                            name_theme <- "REC",
                            id_dataset <- "T02")



#### fonction pour import d'un dataset avec son année de millésime géographique correspondant

f_dl_import_md_dataset <- function(id_theme,name_theme, id_dataset, annee_recensement, annee_geographie){
  
  # dl
  # curl_download(paste0("https://www.insee.fr/fr/statistiques/fichier/",id_theme,"/",name_theme,"_",id_dataset,".dbf"),
  #               paste0("./data/",name_theme,"_",id_dataset,".dbf"))
  # 
  # import
  data = read.dbf(paste0("./data_source/",name_theme,"_",id_dataset,".dbf"), as.is = T)  %>%
    clean_names(case = "upper_camel") %>%
    mutate_if(is.integer, as.numeric) %>%
    mutate(ANNEE_GEOGRAPHIE = annee_geographie) %>%
    mutate_at(.vars = vars(-c(V1,V3,V4,V5,V6)), as.numeric)
  
  # long format
  data_lg <-
    data %>%
    gather(VAR,VAL, -c(V1,V3,V4,V5,V6,ANNEE_GEOGRAPHIE))
  
  # récup noms variables
  data_lg <-
    data_lg %>%
    left_join(liste_variables %>%
                filter(TABLEAU %in% c("Tous les tableaux",paste0(name_theme,"_", id_dataset) )) %>%
                select(VAR,VAR_LIB = LIB, ANNEE_DONNEE),
              by = "VAR") %>%
    rename(VAR_COD = VAR)
  
  # nettoyage nivgeo
  data_lg <-
    data_lg %>%
    mutate(NIVGEO = case_when(V1 %in% "0" ~ "FR",
                              V1 %in% "1" ~ "DEP",
                              V1 %in% "2" ~ "ARR",
                              V1 %in% "3" ~ "CHL",
                              V1 %in% "4" ~ "VIL",
                              V3 %in% '00' & V4 %in% '00' & V5 %in% '00' ~ "FR",
                              !V3 %in% '00' & V4 %in% '00' & V5 %in% '00' ~ "DEP",
                              !V3 %in% '00' & !V4 %in% '00' & V5 %in% '00' ~ "ARR",
                              !V3 %in% '00' & !V4 %in% '00' & !V5 %in% '00' ~ "CHL")) %>%
    mutate(CODGEO = case_when(NIVGEO %in% "FR" ~ "FR",
                              NIVGEO %in% "DEP" ~ V3,
                              NIVGEO %in% "ARR" ~ paste0(V3,V4),
                              NIVGEO %in% "CHL" ~ paste0(V3,V5),
                              NIVGEO %in% "VIL" ~ paste0(V3,V5))) %>%
    rename(LIBGEO = V6) %>%
    select(-c(V1:V5)) %>%
    mutate(SRC_DATA = paste0(name_theme,"_",id_dataset)) %>%
    select(NIVGEO, CODGEO, LIBGEO,SRC_DATA, VAR_COD, VAR_LIB, ANNEE_DONNEE,ANNEE_GEOGRAPHIE, VAL) 
  
}



#########
library(readxl)

liste_datasets <- read_xlsx("./data_source/liste_datasets.xlsx", sheet = "REC") %>%
  rbind.data.frame(read_xlsx("./data_source/liste_datasets.xlsx", sheet = "MVTPOP")) %>%
  rbind.data.frame(read_xlsx("./data_source/liste_datasets.xlsx", sheet = "TERR")) %>%
  rbind.data.frame(read_xlsx("./data_source/liste_datasets.xlsx", sheet = "ENSP"))


liste_variables <- read_xlsx("./data_source/liste_variables.xlsx", sheet = "REC") %>%
  rbind.data.frame(read_xlsx("./data_source/liste_variables.xlsx", sheet = "MVTPOP")) %>%
  rbind.data.frame(read_xlsx("./data_source/liste_variables.xlsx", sheet = "TERR")) %>%
  rbind.data.frame(read_xlsx("./data_source/liste_variables.xlsx", sheet = "ENSP"))
  

indicateurs_SGF <- liste_variables %>%
  left_join(liste_datasets %>%
              mutate(TABLEAU = paste0(name_theme,"_",id_dataset)) %>%
              select(TABLEAU,
                     ECHELLES_GEO = type_geo,
                     NOM_TABLEAU = label_file,
                     ANNEE_GEOGRAPHIE = annee_geographie_DEP),
            by = "TABLEAU") %>%
  filter(!TABLEAU %in% 'Tous les tableaux') %>%
  select(TABLEAU, NOM_TABLEAU, VAR_COD = VAR_N, VAR_LIB = LIB, ANNEE_DONNEE, ECHELLES_GEO, ANNEE_GEOGRAPHIE)

# imports et aggrégation de tous les datasets du thème REC


argList <- list(liste_datasets$id_theme,
                liste_datasets$name_theme,
                liste_datasets$id_dataset, 
                liste_datasets$annee_recensement, 
                liste_datasets$annee_geographie_DEP)

data_SGF <- pmap_dfr(argList,
                    f_dl_import_md_dataset) %>%
  mutate(VAR_COD = as.numeric(str_replace_all(VAR_COD, "V","")))


# # Save an object to a file
# saveRDS(data_SGF, file = "./data/data_SGF.rds")
# # Restore the object
# data_SGF <- readRDS(file = "./data/data_SGF.rds")





################################
#### modifs pour intégration data arrondissements
################################

# modifs année géographie
indicateurs_SGF_NEW <- 
  indicateurs_SGF %>%
  mutate(ANNEE_GEOGRAPHIE = case_when(TABLEAU %in% 'MVTPOP_T91' ~ 1826, TRUE ~ ANNEE_GEOGRAPHIE))



# modifs année géographie
<<<<<<< HEAD
data_SGF <- data_SGF %>%
=======
data_SGF_NEW <- data_SGF %>%
>>>>>>> 5429021d5d3642e4cad82330e64d494a98b3660e
  mutate(NIVGEO = case_when(SRC_DATA %in% 'MVTPOP_T91' ~ "ARR", TRUE ~ as.character(NIVGEO))) %>%
  mutate(ANNEE_GEOGRAPHIE = case_when(SRC_DATA %in% 'MVTPOP_T91' ~ 1826, TRUE ~ ANNEE_GEOGRAPHIE))

# corrections arrondissements PARIS
<<<<<<< HEAD
data_SGF_NEW <- data_SGF %>%
  ungroup() %>%
  mutate(CODGEO_NEW = case_when(substr(CODGEO,1,3) %in% c('754','755','756') ~ "7501", TRUE ~ as.character(CODGEO))) %>%
  group_by(NIVGEO, CODGEO_NEW , SRC_DATA ,VAR_COD , VAR_LIB , ANNEE_DONNEE , ANNEE_GEOGRAPHIE) %>%
  summarise(LIBGEO = first(LIBGEO),
            VAL = sum(VAL, na.rm = T)) %>%
  select("NIVGEO", CODGEO = "CODGEO_NEW" , "LIBGEO" , "SRC_DATA" ,"VAR_COD" , "VAR_LIB" , "ANNEE_DONNEE" ,    "ANNEE_GEOGRAPHIE", "VAL") %>%
  mutate(LIBGEO = case_when(LIBGEO %in% 'LOUVRE' ~ "PARIS", TRUE ~ as.character(LIBGEO)))
=======
data_SGF_NEW <- data_SGF_NEW %>%
  ungroup() %>%
  mutate(CODGEO_NEW = case_when(substr(CODGEO,1,3) %in% c('754','755','756') ~ "7501", TRUE ~ as.character(CODGEO))) %>%
  group_by(NIVGEO, CODGEO_NEW , LIBGEO ,SRC_DATA ,VAR_COD , VAR_LIB , ANNEE_DONNEE , ANNEE_GEOGRAPHIE) %>%
  summarise(VAL = sum(VAL, na.rm = T)) %>%
  select("NIVGEO", CODGEO = "CODGEO_NEW" , "LIBGEO" , "SRC_DATA" ,"VAR_COD" , "VAR_LIB" , "ANNEE_DONNEE" ,    "ANNEE_GEOGRAPHIE", "VAL")
>>>>>>> 5429021d5d3642e4cad82330e64d494a98b3660e


# fonction sgf_sfdf

sgf_sfdf_2 <- function(TYPE_NIVGEO, SRC, LISTE_VAR_COD) {
  
<<<<<<< HEAD
  df_data <- data_SGF_NEW %>%
=======
  df_data <- data_SGF %>%
>>>>>>> 5429021d5d3642e4cad82330e64d494a98b3660e
    filter(NIVGEO %in% TYPE_NIVGEO) %>%
    filter(SRC_DATA %in% SRC & VAR_COD %in% LISTE_VAR_COD) %>%
    select(CODGEO,ANNEE_GEOGRAPHIE,VAR_LIB, VAL) %>%
    spread(VAR_LIB, VAL) %>%
    clean_names() %>%
    ungroup()
  
  
  annee_geo <- df_data %>% distinct(annee_geographie) %>% as.vector() %>% pull()
  
  if(TYPE_NIVGEO == "DEP") {
<<<<<<< HEAD
    data <- geo_DEP_SGF_histo %>%
      filter(ANNEE_GEOGRAPHIE %in% annee_geo) %>%
      left_join(df_data %>% select(-annee_geographie),
                by = c("CODGEO" = "codgeo")) %>%
      ungroup()
=======
  data <- geo_DEP_SGF_histo %>%
    filter(ANNEE_GEOGRAPHIE %in% annee_geo) %>%
    left_join(df_data %>% select(-annee_geographie, -nivgeo, -libgeo, -src_data, -var_cod, -annee_donnee, -annee_geographie),
              by = c("CODGEO" = "codgeo")) %>%
    ungroup()
>>>>>>> 5429021d5d3642e4cad82330e64d494a98b3660e
  }
  
  else {
    data <- geo_ARR_SGF_histo %>%
      filter(ANNEE_GEOGRAPHIE %in% annee_geo) %>%
<<<<<<< HEAD
      left_join(df_data %>% select(-annee_geographie),
=======
      left_join(df_data %>% select(-annee_geographie, -nivgeo, -libgeo, -src_data, -var_cod, -annee_donnee, -annee_geographie),
>>>>>>> 5429021d5d3642e4cad82330e64d494a98b3660e
                by = c("CODGEO" = "codgeo")) %>%
      ungroup()
  }
  
}


ARR_cheptels_1872 <-
  sgf_sfdf_2(TYPE_NIVGEO = "ARR",
           SRC ="REC_T24",
           LISTE_VAR_COD = c(18))


