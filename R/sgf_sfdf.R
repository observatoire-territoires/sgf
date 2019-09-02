#' @name sgf_sfdf
#'
#' @title Créer une table de données géographiques avec des indicateurs de la SGF
#'
#' @description Générer un sf dataframe contenant les indicateurs de la SGF préalablement sélectionnés.
#'
#' @param TYPE_NIVGEO Nom court du niveau géographique (pour l'instant, seul 'DEP' pour département est disponible).
#' @param SRC Nom du tableau de données dans lequel se trouvent les indicateurs à récupérer (cf. champ 'TABLEAU' dans la table 'indicateurs_SGF').
#' @param LISTE_VAR_COD Liste des codes des variables à récupérer (cf. champ 'VAR_COD' dans la table 'indicateurs_SGF').
#'
#' @return Renvoie sf dataframe contenant code et nom du territoire ainsi que les indicateurs sélectionnés.
#'
#' @importFrom dplyr tribble filter distinct pull mutate select left_join case_when group_by summarise ungroup rename mutate_if bind_rows
#' @importFrom janitor clean_names
#' @importFrom tidyr spread gather
#' @import sf
#'
#' @examples
#' \dontrun{
#' # Creation du sf dataframe contenant les indicateurs de cheptels (bovins, ovins, etc...) issus du recensement de 1872
#' DEP_cheptels_1872 <-
#' sgf_sfdf(TYPE_NIVGEO = "DEP",
#'          SRC ="REC_T17",
#'          LISTE_VAR_COD = c(52, 59, 65, 70, 83, 87, 94))
#'
#'}
#'
#' @details
#' Pour l'instant seul le niveau géographie du département (TYPE_NIVGEO = 'DEP') est disponible. \cr
#'
#'
#' @export

sgf_sfdf <- function(TYPE_NIVGEO, SRC, LISTE_VAR_COD) {
  
  df_data <- data_SGF %>%
    filter(NIVGEO %in% TYPE_NIVGEO) %>%
    filter(SRC_DATA %in% SRC & VAR_COD %in% LISTE_VAR_COD) %>%
    select(CODGEO,ANNEE_GEOGRAPHIE,VAR_LIB, VAL) %>%
    spread(VAR_LIB, VAL) %>%
    clean_names()
  
  
  annee_geo <- df_data %>% distinct(annee_geographie) %>% as.vector() %>% pull()
  
  data <- geo_DEP_SGF_histo %>%
    filter(ANNEE_GEOGRAPHIE %in% annee_geo) %>%
    left_join(df_data %>% select(-annee_geographie),
              by = c("CODGEO" = "codgeo")) 
  
}

