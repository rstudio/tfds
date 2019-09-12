source("utils.R")

test_that("Can encode and decode using token_text_encoder", {

  skip_if_no_tfds()

  encoder <- token_text_encoder(letters)

  orig_text <- "a b c d"
  ids <- encode(encoder, orig_text)
  dec_text <- decode(encoder, ids)

  expect_equal(orig_text, dec_text)
  expect_equal(ids, 1:4)
})

test_that("Can save and reload a token_text_encoder", {

  skip_if_no_tfds()

  fname <- tempfile()

  encoder <- token_text_encoder(letters)
  save_token_text_encoder(encoder, fname)

  r_encoder <- load_token_text_encoder(fname)

  expect_equal(encode(encoder, "a b c d"), encode(r_encoder, "a b c d"))
})

test_that("Can encode and decode using byte_text_encoder", {

  skip_if_no_tfds()

  encoder <- byte_text_encoder()

  orig_text <- "a b c d"
  ids <- encode(encoder, orig_text)
  dec_text <- decode(encoder, ids)

  expect_equal(orig_text, dec_text)
})

test_that("Can save and reload a byte_text_encoder", {

  skip_if_no_tfds()

  fname <- tempfile()

  encoder <- byte_text_encoder()

  save_byte_text_encoder(encoder, fname)

  r_encoder <- load_byte_text_encoder(fname)

  expect_equal(encode(encoder, "a b c d"), encode(r_encoder, "a b c d"))
})

test_that("Can encode and decode using subword_text_encoder", {

  skip_if_no_tfds()

  encoder <- subword_text_encoder(vocab_list = letters)

  orig_text <- "a b c d sajhsjhasj sjaha"
  ids <- encode(encoder, orig_text)
  dec_text <- decode(encoder, ids)

  expect_equal(orig_text, dec_text)
})

test_that("Can save and reload a subword_text_encoder", {

  skip_if_no_tfds()

  fname <- tempfile()

  encoder <- subword_text_encoder(vocab_list = letters)
  save_byte_text_encoder(encoder, fname)

  r_encoder <- load_subword_text_encoder(fname)

  expect_equal(encode(encoder, "a b c d"), encode(r_encoder, "a b c d"))
})



