#'@export
tfds <- NULL

.onLoad <- function(libname, pkgname) {
  tfds <<- reticulate::import("tensorflow_datasets", delay_load = list(
    priority = 10,
    environment = "r-reticulate"
  ))
}

#' TensorFlow Datasets version
#'
#' @export
tfds_version <- function() {
  string_version <- tfds$version$`__version__`
  sub_version <- sub("([0-9]+\\.[0-9]+\\.[0-9]+).*", "\\1", string_version)
  numeric_version(sub_version)
}
