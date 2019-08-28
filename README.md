
<!-- README.md is generated from README.Rmd. Please edit that file -->

# SGF

La SGF (pour *Statistique Générale de la France*) est [l’ancêtre de
l’Insee](https://www.insee.fr/fr/information/1300622), à savoir un
service ministériel chargé de collecter et analyser des statistiques
pour le gouvernement français entre 1833 et 1940.

Une partie de ces données a été saisie dans les années 1980 par une
équipe de chercheurs franco-américains à l’Inter-University Consortium
for Political and Social Research (ICPSR), situé à Ann Arbor, Michigan,
États-Unis. L’Insee a [publié
ici](https://www.insee.fr/fr/statistiques/2591397) 200 tableurs au
format dbf portant sur les recensements de la population, la démographie
et l’enseignement primaire, entre 1800 et 1925.

Le package `sgf` regroupe, normalise et documente ces indicateurs
disponibles dans la plupart des cas à l’échelon géographique du
département (des arrondissements voire des chefs-lieux
d’arrondissements dans quelques rares cas). Il permet également de
cartographier ces indicateurs au millésime géographique du département
correspondant au millésime de la donnée.

`sgf` est composé de :

  - 2 tables de données (format dataframe) :
      - **indicateurs\_SGF** : description des 40 000 indicateurs
        disponibles (libellé, identifiant, millésime de la donnée,
        échelles géographiques disponibles et millésime de la
        géographie)
      - **data\_SGF** : table contenant l’ensemble des données en format
        long (libellés, identifiants, millésime de la donnée et
        millésime de la géographie)
  - 1 table géographique (format sf dataframe) :
      - **geo\_DEP\_SGF\_histo** : contours géographiques des
        départements (avec leur code et libellé) selon le millésime de
        la géographie (cf. "géographie ci-dessous)
  - 1 fonction :
      - **sgf\_sfdf** : après avoir identifié les indicateurs de son
        choix dans la table **indicateurs\_SGF**, cette fonction permet
        de créer un sf dataframe avec les indicateurs en format large

## Installation

Le package `sgf` peut être installé depuis
[github](https://github.com/observatoire-territoires/sgf) via la
commande suivante :

``` r
remotes::install_github("observatoire-territoires/sgf")
```

## Géographie

Les contours des départements de France métropolitaine ont évolués sur
la période que couvre les données de la SGF. Les 5 millésimes de cette
géographie départementale sont disponibles dans la table
`geo_DEP_SGF_histo` :

<img src="man/figures/README-example -1.png" width="100%" />

## Exemple
