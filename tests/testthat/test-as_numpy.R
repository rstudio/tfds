test_that("as_numpy works", {
  mnist <- tfds_load("mnist")
  np <- tfds::tfds_as_numpy(mnist)

  nxt <- reticulate::iter_next(np$train)

  expect_equal(class(nxt), "list")
  expect_equal(class(nxt[[1]]), "array")
})
