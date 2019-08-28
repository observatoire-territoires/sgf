library(usethis)
library(devtools)

#https://speakerdeck.com/colinfay/building-a-package-that-lasts-erum-2018-workshop
#https://thinkr.fr/creer-package-r-quelques-minutes/

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

#use_gpl3_license(name="mtmx")

# save
my_desc$write(file = "DESCRIPTION")


# data-raw dir
devtools::use_data_raw()

# sauvegarde des dataframes dans dossier data
usethis::use_data(geo_DEP_SGF_histo, indicateurs_SGF, data_SGF, overwrite = T)


# vérification de l'intégrité du package
devtools::check()
