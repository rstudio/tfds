source("utils.R")

test_that("Can encode and decode using token_text_encoder", {

  skip_if_no_tfds()

  encoder <- token_text_encoder(letters)

  orig_text <- "a b c d"
  ids <- encode_text(encoder, orig_text)
  dec_text <- decode_text(encoder, ids)

  expect_equal(orig_text, dec_text)
  expect_equal(ids, 1:4)
})

test_that("Can save and reload a token_text_encoder", {

  skip_if_no_tfds()

  fname <- tempfile()

  encoder <- token_text_encoder(letters)
  save_token_text_encoder(encoder, fname)

  r_encoder <- load_token_text_encoder(fname)

  expect_equal(encode_text(encoder, "a b c d"), encode_text(r_encoder, "a b c d"))
})




