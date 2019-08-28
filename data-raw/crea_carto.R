library(tidyverse)
library(sf)
library(rmapshaper)

# nettoyage puis création des mailles DEP
# par millésime

# 1801
geo_ARR_1801 <- st_read("./geo_source/arrondissements1801_S.shp") %>%
  st_transform(2154) %>%
  mutate(CODGEO = str_pad(IDEN, side = "left", width = 4, pad = "0")) %>%
  select(CODGEO)

geo_DEP_1801 <- geo_ARR_1801 %>% 
  mutate(CODGEO = substr(CODGEO,1,2)) %>%
  group_by(CODGEO) %>%
  summarise()

# 1826
geo_ARR_1826 <- st_read("./geo_source/arrondissements1826_S.shp") %>%
  st_transform(2154) %>%
  mutate(CODGEO = str_pad(IDEN, side = "left", width = 4, pad = "0")) %>%
  select(CODGEO)

geo_DEP_1826 <- geo_ARR_1826 %>% 
  mutate(CODGEO = substr(CODGEO,1,2)) %>%
  group_by(CODGEO) %>%
  summarise()

# 1866
geo_DEP_1866 <- geo_DEP_1876 %>% 
  filter(!CODGEO %in% c('90','57','54','88')) %>%
  rbind(geo_DEP_1826 %>% filter(CODGEO %in% c('57', '99','67','68','88'))) 


# 1876
geo_ARR_1876 <- st_read("./geo_source/arrondissements1876_S.shp") %>%
  st_transform(2154) %>%
  mutate(CODGEO = str_pad(IDEN, side = "left", width = 4, pad = "0")) %>%
  select(CODGEO)

geo_DEP_1876 <- geo_ARR_1876 %>% 
  mutate(CODGEO = substr(CODGEO,1,2)) %>%
  group_by(CODGEO) %>%
  summarise()


# 1918

geo_DEP_1918 <- st_read("https://raw.githubusercontent.com/gregoiredavid/france-geojson/master/departements.geojson") %>%
  rename(CODGEO = code, LIBGEO = nom) %>%
  st_transform(2154) %>%
  mutate(CODGEO = case_when(CODGEO %in% c('2A','2B') ~ '20',
                                #CODGEO %in% c('90') ~ '68',
                                CODGEO %in% c('75','92','93','94') ~ '75',
                                CODGEO %in% c('95','78','91') ~ '78',
                                TRUE ~ as.character(CODGEO))) %>%
  group_by(CODGEO) %>%
  summarise() %>%
  ms_simplify(keep = 0.01)



#################
## fichier unique de l'historique des geometries des départements

geo_DEP_SGF_histo <-
  geo_DEP_1801 %>% mutate(ANNEE_GEOGRAPHIE = 1801) %>%
  rbind.data.frame(geo_DEP_1826 %>% mutate(ANNEE_GEOGRAPHIE = 1826)) %>%
  rbind.data.frame(geo_DEP_1866 %>% mutate(ANNEE_GEOGRAPHIE = 1866)) %>%
  rbind.data.frame(geo_DEP_1876 %>% mutate(ANNEE_GEOGRAPHIE = 1876)) %>%
  rbind.data.frame(geo_DEP_1918 %>% mutate(ANNEE_GEOGRAPHIE = 1918))

# libellés départements

ref_lib_dep_1 <- data_SGF %>% filter(NIVGEO %in% 'DEP') %>% filter(SRC_DATA %in% 'REC_T01') %>% filter(VAR_COD %in% 'V10') %>%
  select(CODGEO, LIBGEO) %>%
  mutate(LIBGEO = case_when(CODGEO %in% '04' ~ "BASSES-ALPES",
                            CODGEO %in% '05' ~ "HAUTES-ALPES",
                            CODGEO %in% '31' ~ "HAUTE-GARONNE",
                            CODGEO %in% '43' ~ "HAUTE-LOIRE",
                            CODGEO %in% '52' ~ "HAUTE-MARNE",
                            CODGEO %in% '64' ~ "BASSES-PYRENEES",
                            CODGEO %in% '65' ~ "HAUTES-PYRENEES",
                            CODGEO %in% '67' ~ "BAS-RHIN",
                            CODGEO %in% '68' ~ "HAUT-RHIN",
                            CODGEO %in% '70' ~ "HAUTE-SAONE",
                            CODGEO %in% '74' ~ "HAUTE-SAVOIE",
                            CODGEO %in% '79' ~ "DEUX-SEVRES",
                            CODGEO %in% '87' ~ "HAUTE-VIENNE",
                            TRUE ~ as.character(LIBGEO)))


geo_DEP_SGF_histo <- 
  geo_DEP_SGF_histo %>%
  left_join(ref_lib_dep_1, by = "CODGEO") %>%
  mutate(LIBGEO = case_when(CODGEO %in% '54' ~ "MEURTHE-ET-MOSELLE",
                            CODGEO %in% '90' ~ "BELFORT",
                            TRUE ~ as.character(LIBGEO)))


# save carto deps
saveRDS(geo_DEP_SGF_histo, file = "./geo/geo_DEP_SGF_histo.rds")
