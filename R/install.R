#' Installs TensorFlow Datasets
#'
#' @inheritParams reticulate::conda_list
#'
#' @param method Installation method. By default, "auto" automatically finds a
#'   method that will work in the local environment. Change the default to force
#'   a specific installation method. Note that the "virtualenv" method is not
#'   available on Windows (as this isn't supported by TensorFlow). Note also
#'   that since this command runs without privilege the "system" method is
#'   available only on Windows.
#'
#' @param version By default the latest PyPi version will be installed.
#'
#'   Alternatively, you can provide the full URL to an installer binary (e.g.
#'   for a nightly binary).
#'
#' @param envname Name of Python environment to install within
#'
#' @param restart_session Restart R session after installing (note this will
#'   only occur within RStudio).
#'
#' @param conda_python_version the python version installed in the created conda
#'   environment. Python 3.6 is installed by default.
#'
#' @param ... other arguments passed to [reticulate::conda_install()] or
#'   [reticulate::virtualenv_install()].
#'
#' @export
install_tfds <- function(method = c("auto", "virtualenv", "conda"),
                         conda = "auto",
                         version = "default",
                         envname = NULL,
                         restart_session = TRUE,
                         conda_python_version = NULL,
                         ...) {

  package_string <- "tensorflow_datasets"

  if (version != "default")
    package_string <- paste0(package_string, "==", version)

  reticulate::py_install(
    packages = package_string,
    method = method,
    envname = envname,
    pip = TRUE,
    conda = conda,
    python_version = conda_python_version,
    ...
  )

  if (restart_session && rstudioapi::hasFun("restartSession"))
    rstudioapi::restartSession()

  invisible(NULL)
}
