% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{indicateurs_SGF}
\alias{indicateurs_SGF}
\title{Liste des indicateurs disponibles}
\format{Table (format data.frame) de 43 702 lignes et 7 variables.
\describe{
  \item{TABLEAU}{Identifiant du tableau de donnée d'origine}
  \item{NOM_TABLEAU}{Nom en clair du tableau de donnée d'origine}
  \item{VAR_COD}{Identifiant de l'indicateur (1 id unique par tableau de donnée d'origine)}
  \item{VAR_LIB}{Nom en clair de l'indicateur}
  \item{ANNEE_DONNEE}{Millésime de la donnée statistique}
  \item{ECHELLES_GEO}{Echelle(s) géographique(s) disponibles (DEP pour Département, 
  ARR pour Arrondissement, DEP_ARR pour Département+Arrondissement, CHL_VILLE pour Chef-lieu d'arrondissement)}
  \item{ANNEE_GEOGRAPHIE}{Millésime des contours géographiques correspondants (1801, 1826, 1866, 1876 ou 1918)}
}}
\source{
\url{https://www.insee.fr/fr/statistiques/2591397}
}
\usage{
indicateurs_SGF
}
\description{
Description des plus de 40 000 indicateurs de la SGF publiées par l'Insee.
}
\keyword{datasets}
