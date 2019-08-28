library(scales)
library(hrbrthemes)

# fonts
library(extrafont)

library(showtext)
font_add_google("Roboto", "Roboto")

myFont2 <- "Roboto"

# liste changements contours départements

geo_DEP_SGF_histo_modifs <- 
  geo_DEP_SGF_histo %>%
  mutate(modif = case_when(CODGEO %in% '82' & ANNEE_GEOGRAPHIE == 1826 ~ "création",
                           CODGEO %in% '73' & ANNEE_GEOGRAPHIE == 1866 ~ "création",
                           CODGEO %in% '74' & ANNEE_GEOGRAPHIE == 1866 ~ "création",
                           CODGEO %in% '06' & ANNEE_GEOGRAPHIE == 1866 ~ "création",
                           CODGEO %in% '83' & ANNEE_GEOGRAPHIE == 1866 ~ "modification",
                           CODGEO %in% '54' & ANNEE_GEOGRAPHIE == 1876 ~ "création",
                           CODGEO %in% '90' & ANNEE_GEOGRAPHIE == 1876 ~ "création",
                           CODGEO %in% '88' & ANNEE_GEOGRAPHIE == 1876 ~ "modification",
                           CODGEO %in% '57' & ANNEE_GEOGRAPHIE == 1918 ~ "création",
                           CODGEO %in% '67' & ANNEE_GEOGRAPHIE == 1918 ~ "création",
                           CODGEO %in% '68' & ANNEE_GEOGRAPHIE == 1918 ~ "création")) %>%
  # ajout des départements supprimés en 1876
  rbind.data.frame(geo_DEP_SGF_histo %>%
                     filter(ANNEE_GEOGRAPHIE == 1866 & CODGEO %in% c('57','67','68')) %>%
                     mutate(ANNEE_GEOGRAPHIE = 1876) %>%
                     mutate(modif = "suppression"))



# choroplèthe 
ggplot(data = geo_DEP_SGF_histo %>%
         filter(ANNEE_GEOGRAPHIE == 1801)) +
  geom_sf(fill = "grey90",
          color = "grey70") +
  geom_sf_text(aes(label = CODGEO), color = "grey20", size = 3.5, fontface = "bold", family = "Times") +
  #guides(fill = guide_legend(reverse=T)) +
  theme_ipsum_tw() +
  theme(axis.text = element_blank(), axis.title  = element_blank(), axis.ticks  = element_blank()) +
  labs(
    title = "Contours des départements de France métropolitaine"#,
    #subtitle = "1881",
  )+
  theme(legend.position = c(0.95,0.5),
        axis.line=element_blank(),
        axis.title=element_blank(),
        axis.text=element_blank() )+
  coord_sf(crs = st_crs(2154), datum = NA)



# planche de cartes

ggplot(data = geo_DEP_SGF_histo_modifs ) +
  geom_sf(aes(fill = modif),
          color = "grey70") +
  geom_sf_text(aes(label = CODGEO), color = "grey20", size = 2.5, fontface = "bold") +
  #guides(fill = guide_legend(reverse=T)) +
  #theme_ipsum() +
  scale_fill_manual(name = "Modifications successives\ndepuis 1801",
                    values =c("green", "orange", "red"), na.translate = F, na.value = "grey") +
  facet_wrap(~ ANNEE_GEOGRAPHIE, ncol = 3) +
  theme(axis.text = element_blank(), 
        axis.title = element_blank(), 
        text =  element_text(size = 10,face = "bold"),
        strip.text.x = element_text(size = 10, colour = "white"),
        strip.background = element_rect(fill="grey20", colour=NA,size=0),
        legend.position = c(0.85,0.3),
        axis.ticks  = element_blank()) +
  labs(
    title = "Contours des départements de France métropolitaine"#,
    #subtitle = "1881",
  )+
  coord_sf(crs = st_crs(2154), datum = NA)
