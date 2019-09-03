library(usethis)
library(devtools)

#https://speakerdeck.com/colinfay/building-a-package-that-lasts-erum-2018-workshop
#https://www.hvitfeldt.me/blog/usethis-workflow-for-package-development/

unlink("DESCRIPTION")
my_desc <- desc::description$new("!new")
my_desc$set("Package","sgf")
my_desc$set("Title","sgf")
my_desc$set("Authors@R", "person('Observatoire des Territoires',email='observatoire@☺cget.gouv.fr', role=c('cre','aut'))")
#my_desc$set_authors()
my_desc$del("Maintainer")
my_desc$set_version("0.0.0.9000")
my_desc$set(Description = "Old French statistics")
my_desc$set("URL","https://github.com/observatoire-territoires/sgf")
my_desc$set("BugReports","https://github.com/observatoire-territoires/sgf/issues")

#use_gpl3_license()
use_mit_license(name = "Insee - SGF - ICPSR - Observatoire des territoires")

# save
my_desc$write(file = "DESCRIPTION")

# A FINIR
use_travis()

# ✔ Setting active project to 'C:/Users/mgarnier/Documents/diffusion_donnees/sgf'
# ✔ Writing '.travis.yml'
# ✔ Adding '^\\.travis\\.yml$' to '.Rbuildignore'
# ● Turn on travis for your repo at https://travis-ci.org/profile/observatoire-territoires
# ● Copy and paste the following lines into 'C:/Users/mgarnier/Documents/diffusion_donnees/sgf/README.Rmd':
#   <!-- badges: start -->
#   [![Travis build status](https://travis-ci.org/observatoire-territoires/sgf.svg?branch=master)](https://travis-ci.org/observatoire-territoires/sgf)
# <!-- badges: end -->
#   [Copied to clipboard]

# data-raw dir
devtools::use_data_raw()

# sauvegarde des dataframes dans dossier data
usethis::use_data(geo_DEP_SGF_histo, indicateurs_SGF, data_SGF, overwrite = T)
usethis::use_data( data_SGF, overwrite = T)
usethis::use_data( geo_DEP_SGF_histo, overwrite = T)

use_news_md()

use_version()

# fonction
use_r("sgf_sfdf")

# documentation des datasets
use_r("data")

# dependances
use_package("dplyr") 
use_package("dplyr") 
use_package("tidyr") 
use_package("janitor") 
use_package("sf") 


# doc

library(pkgdown)
library(roxygen2)

#générer doc .Rd
roxygen2::roxygenise()

# vérification de l'intégrité du package
devtools::check()
