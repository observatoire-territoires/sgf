#' Liste des indicateurs disponibles
#'
#' Description des plus de 40 000 indicateurs de la SGF publiées par l'Insee.
#'
#' @format Table (format data.frame) de 43 702 lignes et 7 variables.
#' \describe{
#'   \item{TABLEAU}{Identifiant du tableau de donnée d'origine}
#'   \item{NOM_TABLEAU}{Nom en clair du tableau de donnée d'origine}
#'   \item{VAR_COD}{Identifiant de l'indicateur (1 id unique par tableau de donnée d'origine)}
#'   \item{VAR_LIB}{Nom en clair de l'indicateur}
#'   \item{ANNEE_DONNEE}{Millésime de la donnée statistique}
#'   \item{ECHELLES_GEO}{Echelle(s) géographique(s) disponibles (DEP pour Département, 
#'   ARR pour Arrondissement, DEP_ARR pour Département+Arrondissement, CHL_VILLE pour Chef-lieu d'arrondissement)}
#'   \item{ANNEE_GEOGRAPHIE}{Millésime des contours géographiques correspondants (1801, 1826, 1866, 1876 ou 1918)}
#' }
#' @source \url{https://www.insee.fr/fr/statistiques/2591397}
"indicateurs_SGF"

#' Table des données de la SGF
#'
#' Données de la SGF (au format long) publiées par l'Insee.
#'
#' @format Table (format data.frame) de 4 627 598 lignes et 9 variables.
#' \describe{
#'   \item{NIVGEO}{Nom de l'échelle géographique (FR pour France entière, DEP pour Département, 
#'   ARR pour Arrondissement, CHL pour Chef-lieu d'arrondissement, VIL pour Ville)}
#'   \item{CODGEO}{Identifiant du territoire}
#'   \item{LIBGEO}{Libellé du territoire}
#'   \item{SRC_DATA}{Identifiant du tableau de donnée d'origine}
#'   \item{VAR_COD}{Identifiant de l'indicateur (1 id unique par tableau de donnée d'origine)}
#'   \item{VAR_LIB}{Nom en clair de l'indicateur}
#'   \item{ANNEE_DONNEE}{Millésime de la donnée}
#'   \item{ANNEE_GEOGRAPHIE}{Millésime des contours géographiques correspondants (1801, 1826, 1866, 1876 ou 1918)}
#'   \item{VAL}{Valeur de l'indicateur}
#' }
#' @source \url{https://www.insee.fr/fr/statistiques/2591397}
"data_SGF"

#' Géographies des départements  
#'
#' Contours et libellés des départements de France métropolitaine à plusieurs millésimes.
#'
#' @format Table géographique (format sf data.frame) de 437 lignes et 3 variables.
#' \describe{
#'   \item{CODGEO}{Identifiant du territoire}
#'   \item{LIBGEO}{Nom du territoire}
#'   \item{ANNEE_GEOGRAPHIE}{Millésime du contour géographique (1801, 1826, 1866, 1876 ou 1918)}
#'   \item{geometry}{Description des contours géographiques}
#' }
"geo_DEP_SGF_histo"

#' Géographies des arrondissements  
#'
#' Contours et libellés des arrondissements de France métropolitaine à plusieurs millésimes.
#'
#' @format Table géographique (format sf data.frame) de 1084 lignes et 3 variables.
#' \describe{
#'   \item{CODGEO}{Identifiant du territoire}
#'   \item{LIBGEO}{Nom du territoire}
#'   \item{ANNEE_GEOGRAPHIE}{Millésime du contour géographique (1801, 1826 ou 1876)}
#'   \item{geometry}{Description des contours géographiques}
#' }
"geo_ARR_SGF_histo"