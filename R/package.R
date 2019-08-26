# main tfhub module
tfds <- NULL

.onLoad <- function(libname, pkgname) {
  tfds <<- reticulate::import("tensorflow_datasets", delay_load = list(
    priority = 10,
    environment = "r-reticulate"
  ))
}
