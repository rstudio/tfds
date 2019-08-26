
skip_if_no_tfds <- function() {
  if (!reticulate::py_module_available("tensorflow_datasets"))
    testthat::skip("TensorFlow Datasets is not available.")
}
