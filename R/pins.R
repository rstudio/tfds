board_initialize.tfds <- function(board, ...) {
  board
}

board_pin_create.tfds <- function(board, path, name, ...) {
  stop("You can't create pins in this board.", call. = FALSE)
}

board_pin_get.tfds <- function(board, name, ...) {
  tfds_load(name, ...)
}

board_pin_find.tfds <- function(board, text, ...) {

  results <- data.frame(
    name = tfds$list_builders(),
    description = "TensorFlow dataset",
    type = "tensorflow dataset",
    metadata = "",
    board = "tfds",
    stringsAsFactors = F
    )

  if (is.character(text)) {
    results <- results[grepl(text, results$name),,drop=FALSE]
  }

  if (nrow(results) == 1) {

    info <- jsonlite::fromJSON(
      tfds$builder(results$name)$info$as_json,
      simplifyDataFrame = FALSE
    )

    results$description <- info$description

    results$metadata <- jsonlite::toJSON(
      list(
        columns = get_feature_names(info)
      ),
      auto_unbox = TRUE
    )
  }

  results
}

get_feature_names <- function(info) {

  if (is.null(info$schema))
    return(list(unknow = "schema not provided"))

  names <- sapply(info$schema$feature, function(x) x$name)
  dimensions <- sapply(info$schema$feature, function(x) get_dimensions(x))
  types <- sapply(info$schema$feature, function(x) get_type(x))


  as.list(setNames(paste(types, dimensions), names))
}

get_dimensions <- function(feature) {

  if (is.null(feature$shape$dim))
    return("[]")

  paste0("[",paste(unlist(feature$shape$dim), collapse=","), "]")

}

get_type <- function(feature) {


  if (is.null(feature$type))
    return("UNK")

  feature$type
}

board_pin_remove.tfds <- function(board, name, ...) {
  stop("You can't remove pins from this board.", call. = FALSE)
}
