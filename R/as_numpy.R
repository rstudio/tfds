#' Converts a TensorFlow Dataset to an iterable of NumPy arrays.
#'
#' @param dataset a possibly nested structure of tf.data.Datasets and/or
#'   tf.Tensors.
#' @param graph optional, explicitly set the graph to use.
#'
#' @export
tfds_as_numpy <- function(dataset, graph = NULL) {
  tfds$as_numpy(dataset = dataset, graph = graph)
}
