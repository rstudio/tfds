#' Loads the named dataset into a TensorFlow Dataset
#' @param name `str`, the registered name of the `DatasetBuilder` (the snake case
#'                                                           version of the class name). This can be either `"dataset_name"` or
#' `"dataset_name/config_name"` for datasets with `BuilderConfig`s.
#' As a convenience, this string may contain comma-separated keyword
#' arguments for the builder. For example `"foo_bar/a=True,b=3"` would use
#' the `FooBar` dataset passing the keyword arguments `a=True` and `b=3`
#' (for builders with configs, it would be `"foo_bar/zoo/a=True,b=3"` to
#'   use the `"zoo"` config and pass to the builder keyword arguments `a=True`
#'   and `b=3`).
#' @param split `tfds.Split` or `str`, which split of the data to load. If None,
#' will return a `dict` with all splits (typically `tfds.Split.TRAIN` and
#'                                       `tfds.Split.TEST`).
#' @param data_dir `str` (optional), directory to read/write data.
#' Defaults to "~/tensorflow_datasets".
#' @param batch_size `int`, if set, add a batch dimension to examples. Note that
#' variable length features will be 0-padded. If
#' `batch_size=-1`, will return the full dataset as `tf.Tensor`s.
#' @param download `bool` (optional), whether to call
#' `tfds.core.DatasetBuilder.download_and_prepare`
#' before calling `tf.DatasetBuilder.as_dataset`. If `False`, data is
#' expected to be in `data_dir`. If `True` and the data is already in
#' `data_dir`, `download_and_prepare` is a no-op.
#' @param shuffle_files  `bool`, whether to shuffle the input files.
#' Defaults to `False`.
#' @param as_supervised `bool`, if `True`, the returned `tf.data.Dataset`
#' will have a 2-tuple structure `(input, label)` according to
#' `builder.info.supervised_keys`. If `False`, the default,
#' the returned `tf.data.Dataset` will have a dictionary with all the
#' features.
#' @param decoders Nested dict of `Decoder` objects which allow to customize the
#' decoding. The structure should match the feature structure, but only
#' customized feature keys need to be present. See
#' [the guide](https://github.com/tensorflow/datasets/tree/master/docs/decode.md)
#' for more info.
#' @param builder_kwargs `dict` (optional), keyword arguments to be passed to the
#' `tfds.core.DatasetBuilder` constructor. `data_dir` will be passed
#' through by default.
#' @param download_and_prepare_kwargs `dict` (optional) keyword arguments passed to
#' `tfds.core.DatasetBuilder.download_and_prepare` if `download=True`. Allow
#' to control where to download and extract the cached data. If not set,
#' cache_dir and manual_dir will automatically be deduced from data_dir.
#' @param as_dataset_kwargs `dict` (optional), keyword arguments passed to
#' `tfds.core.DatasetBuilder.as_dataset`.
#' @param try_gcs `bool`, if True, tfds.load will see if the dataset exists on
#' the public GCS bucket before building it locally.
#' @param ... Additional parameters, currently not used.
#'
#'
#' @export
tfds_load <- function(name,
                      split = NULL,
                      data_dir = NULL,
                      batch_size = NULL,
                      download = TRUE,
                      shuffle_files = FALSE,
                      as_supervised = FALSE,
                      decoders = NULL,
                      builder_kwargs = NULL,
                      download_and_prepare_kwargs = NULL,
                      as_dataset_kwargs = NULL,
                      try_gcs = FALSE,
                      ...) {
  ds <- tfds$load(
    name = name,
    split = split,
    data_dir = data_dir,
    batch_size = batch_size,
    download = download,
    shuffle_files = shuffle_files,
    as_supervised = as_supervised,
    decoders = decoders,
    builder_kwargs = builder_kwargs,
    download_and_prepare_kwargs = download_and_prepare_kwargs,
    as_dataset_kwargs = as_dataset_kwargs,
    try_gcs = try_gcs,
    with_info = TRUE,
    ...
  )

  info <- ds[[length(ds)]]
  ds <- ds[[-length(ds)]]
  class(ds) <- c("tfds_dataset", class(ds))
  attr(ds, "info") <- jsonlite::fromJSON(
    info$as_json,
    simplifyDataFrame = FALSE,
    simplifyMatrix = FALSE
  )
  ds
}

#' @export
summary.tfds_dataset <- function(object, ...) {
  info <- attr(object, "info")

  cli::cat_rule(info$description)

  cat_info("Name: ", cli::col_grey(info$name))
  cat_info("Version: ", cli::col_grey(info$version))
  cat_info("URLs: ", cli::col_grey(info$location %||% NA))
  cat_info("Size: ", cli::col_grey(R.utils::hsize(as.numeric(info$sizeInBytes))))
  cat_split(info$splits)
  cat_schema(info$schema)

  invisible(info)
}

cat_info <- function(...) {
  cli::cat_line(cli::symbol$pointer, " ", ...)
}

cat_split <- function(splits) {
  cat_info("Splits:")
  for (s in splits) {
    cli::cat_line(
      cli::col_grey(
        " ",
        cli::symbol$em_dash,
        " ", s$name,
        " (",
        s$statistics$numExamples,
        " examples)"
      )
    )
  }
}

cat_schema <- function(schema) {

  cat_info("Schema:")
  for (f in schema$feature) {
    cli::cat_line(
      cli::col_grey(
        " ",
        cli::symbol$em_dash,
        " ", f$name,
        " ", cat_dim(f$shape),
        " ", f$type
      )
    )
  }

}

cat_dim <- function(shape) {

  if (is.null(shape))
    dim <- ""
  else
    dim <- shape$dim

  paste0(
    "[",
    paste(unlist(dim), collapse = ", "),
    "]"
  )
}


