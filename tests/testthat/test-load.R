source("utils.R")

test_that("Can load a dataset", {

  skip_if_no_tfds()

  mnist <- tfds_load("mnist")
  it <- reticulate::as_iterator(mnist$train)
  batch <- reticulate::iter_next(it)

  expect_equal(class(batch), "list")
  expect_s3_class(batch[[1]], "tensorflow.python.framework.ops.Tensor")
})

test_that("Can use splits", {

  skip_if_no_tfds()

  mnist <- tfds_load("mnist:3.*.*", split = "train[10:20]")
  it <- reticulate::as_iterator(mnist)
  batch <- reticulate::iter_next(it)

  expect_equal(class(batch), "list")
  expect_s3_class(batch[[1]], "tensorflow.python.framework.ops.Tensor")
})
