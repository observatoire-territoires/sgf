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

ref_lib_dep_1 <- data_SGF %>% filter(NIVGEO %in% 'DEP') %>% filter(SRC_DATA %in% 'REC_T01') %>% filter(VAR_COD %in% 10) %>%
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
                            TRUE ~ as.character(LIBGEO))) %>%
  select(CODGEO, LIBGEO, ANNEE_GEOGRAPHIE, geometry)


class(geo_DEP_SGF_histo) <- c("sf", "data.frame")

# save carto deps
#saveRDS(geo_DEP_SGF_histo, file = "./geo/geo_DEP_SGF_histo.rds")


##############################
#### fonds ARRONDISSEMENTS
#############################


geo_ARR_SGF_histo <-
  geo_ARR_1801 %>% mutate(ANNEE_GEOGRAPHIE = 1801) %>%
  rbind.data.frame(geo_ARR_1826 %>% mutate(ANNEE_GEOGRAPHIE = 1826)) %>%
  rbind.data.frame(geo_ARR_1876 %>% mutate(ANNEE_GEOGRAPHIE = 1876)) 


# correction des arrondissements avec iles

geo_ARR_SGF_histo <- geo_ARR_SGF_histo %>% group_by(CODGEO, LIBGEO, ANNEE_GEOGRAPHIE) %>% summarise()


# rectification du code et de l'arrondissement de Toul en 1876

geo_ARR_SGF_histo_2 <- geo_ARR_SGF_histo
class(geo_ARR_SGF_histo_2) <- c('sf','data.frame')

geo_ARR_SGF_histo_2 <-geo_ARR_SGF_histo_2  %>%
  ungroup() %>%
  mutate(CODGEO = case_when(CODGEO %in% '5404' & ANNEE_GEOGRAPHIE %in% 1876 ~ "5405",
         TRUE ~ as.character(CODGEO))) %>%
  mutate(LIBGEO = case_when(CODGEO %in% '5405' & ANNEE_GEOGRAPHIE == 1876 ~ "TOUL",
         TRUE ~ as.character(LIBGEO)))

# changement de format DEP sf
geo_DEP_SGF_histo_2 <- geo_DEP_SGF_histo
class(geo_DEP_SGF_histo_2) <- c('sf','data.frame')

# libellés départements

ref_lib_arr_1 <- data_SGF %>% 
  filter(NIVGEO %in% 'ARR') %>%
  # filter(SRC_DATA %in% 'REC_T01') %>%
  # filter(VAR_COD %in% 10) %>%
  distinct(CODGEO, LIBGEO) %>%
  filter(!LIBGEO %in% c('VILLEFR-DE-ROUERG','TARASCON',"PONT L'EVEQUE", "CHATILLON-SUR-SEI",
                        "NOGENT LE ROTROU","VILLEFRANC DE LAU","ISSODUN","SAVENAY","VILLENEUV-SUR-LOT",
                        "SCHELESTADT","GUEBWILLER","VILLE-FR-SUR-SAON", "VILLEFR-SUR-SAONE",
                        "SAINT-JEAN-DE-MAU","ST-JEAN-DE-MAUR","SAINT-JULLIEN","NEUFCHATEL-EN-BRA",
                        "LAROCHE-SUR-YON","LES SABLES-D'OLONNE","MOULINS-SUR-ALLIE") ) %>%
  mutate(LIBGEO = case_when(CODGEO %in% '6802' ~ 'BELFORT', TRUE ~ as.character(LIBGEO))) %>%
  filter(!substr(CODGEO,1,3) %in% c('754','755','756')) %>%
  distinct(CODGEO, LIBGEO)




geo_ARR_SGF_histo <- 
  geo_ARR_SGF_histo %>%
  left_join(ref_lib_arr_1, by = "CODGEO") %>%
  select(CODGEO, LIBGEO, ANNEE_GEOGRAPHIE, geometry)


class(geo_ARR_SGF_histo) <- c("sf", "data.frame")
