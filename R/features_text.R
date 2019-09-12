#' Token Text Encoder
#'
#' Constructs a TokenTextEncoder.
#'
#' @param vocab_list list of tokens
#' @param oov_buckets the number of integers to reserve for OOV hash buckets.
#'  Tokens that are OOV will be hash-modded into a OOV bucket in `encode`.
#' @param oov_token the strings to use for OOV ids in decode.
#' @param lowercase whether to make all text and tokens lowercase.
#' @param tokenizer `Tokenizer` responsible for converting incoming text into a
#'  list of tokens.
#' @param strip_vocab  whether to strip whitespace from the beggining and end of
#'  elements of `vocab_list`.
#' @param decode_token_separator the string used to separate tokens when decoding.
#'
#' @seealso [save_token_text_encoder()], [load_token_text_encoder()], [encode()]
#'  and [decode()]
#'
#' @export
token_text_encoder <- function(vocab_list,
                               oov_buckets = 1,
                               oov_token = "UNK",
                               lowercase = FALSE,
                               tokenizer = NULL,
                               strip_vocab = TRUE,
                               decode_token_separator = " ") {
  tfds$features$text$TokenTextEncoder(
    vocab_list,
    oov_buckets = as.integer(oov_buckets),
    oov_token = oov_token,
    lowercase = lowercase,
    tokenizer = tokenizer,
    strip_vocab = strip_vocab,
    decode_token_separator = decode_token_separator
  )
}

#' Byte Text Encoder
#'
#' Byte encodes text
#'
#' @param additional_tokens list of additional tokens. These will be assigned
#'  vocab ids [1, 1+len(additional_tokens)]. Useful for things like "end-of-string"
#'  tokens (e.g. "").
#'
#' @seealso [save_byte_text_encoder()], [load_byte_text_encoder()], [encode()]
#'  and [decode()]
#'
#' @export
byte_text_encoder <- function(additional_tokens =  NULL) {
  tfds$features$text$ByteTextEncoder(additional_tokens = additional_tokens)
}

#' Saves a token text encoder to a file
#'
#' @param token_text_encoder a Token Text Encoder created with `token_text_encoder()`
#' @param path path to save the text encoder.
#'
#' @seealso [token_text_encoder()]
#'
#' @export
save_token_text_encoder <- function(token_text_encoder, path) {
  token_text_encoder$save_to_file(path.expand(path))
}

#' Loads a Token Text Encoder
#'
#' @param path path of a saved token text encoder.
#'
#' @seealso [token_text_encoder()]
#'
#' @export
load_token_text_encoder <- function(path) {
  tfds$features$text$TokenTextEncoder$load_from_file(path.expand(path))
}

#' Saves a token text encoder to a file
#'
#' @param token_text_encoder a Token Text Encoder created with `token_text_encoder()`
#' @param path path to save the text encoder.
#'
#' @seealso [byte_text_encoder()]
#'
#' @export
save_byte_text_encoder <- function(byte_text_encoder, path) {
  byte_text_encoder$save_to_file(path.expand(path))
}

#' Loads a Token Text Encoder
#'
#' @param path path of a saved token text encoder.
#'
#' @seealso [byte_text_encoder()]
#'
#' @export
load_byte_text_encoder <- function(path) {
  tfds$features$text$ByteTextEncoder$load_from_file(path.expand(path))
}

#' Encode text
#'
#' @inheritParams save_token_text_encoder
#' @param text string to encode using the Token Text encoder
#' @seealso [token_text_encoder()]
#' @export
encode <- function(token_text_encoder, text) {
  token_text_encoder$encode(text)
}

#' Decode text
#'
#' @inheritParams save_token_text_encoder
#' @param ids ids to decode using the Token Text encoder.
#' @seealso [token_text_encoder()]
#' @export
decode <- function(token_text_encoder, ids) {
  token_text_encoder$decode(ids)
}
