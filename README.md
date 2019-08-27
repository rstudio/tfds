
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tfds

<!-- badges: start -->

<!-- badges: end -->

tfds is an R interface to TensorFlow Datasets and provides a collection
of datasets ready to use with TensorFlow and Keras. It handles
downloading and preparing the data and constructing a TensorFlow
Dataset.

## Installation

tfds is not currently on CRAN. The development version can be installed
from [GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("rstudio/tfds")
```

After installing the R package, you need to install the
`tensorflow_datasets` python module with:

``` r
tfds::install_tfds()
```

## Example

`tfds_load` is a convenience method that’s the simplest way to build and
load a `tf_dataset`.

Below, we load the MNIST training data. It downloads and prepares the
data, unless you specify `download=FALSE`. Note that once data has been
prepared, subsequent calls of load will reuse the prepared data. You can
customize where the data is saved/loaded by specifying `data_dir=`
(defaults to `~/tensorflow_datasets/`).

``` r
library(tfds)
mnist <- tfds_load("mnist")
mnist
#> $test
#> <_OptionsDataset shapes: {image: (28, 28, 1), label: ()}, types: {image: tf.uint8, label: tf.int64}>
#> 
#> $train
#> <_OptionsDataset shapes: {image: (28, 28, 1), label: ()}, types: {image: tf.uint8, label: tf.int64}>
```

This will use the default version of the dataset. It’s however
recommended to specify the dataset version when loading:

``` r
minst <- tfds_load("mnist:1.*.*")
```

We can build a simple model using `mnist` and Keras with:

``` r
library(keras)
library(tfdatasets)

model <- keras_model_sequential() %>% 
layer_flatten(input_shape = c(28,28,1)) %>% 
  layer_dense(512, activation = "relu") %>% 
  layer_dense(10, activation = "softmax")

model %>% 
  compile(
    loss = "sparse_categorical_crossentropy", 
    optimizer = "adam", 
    metric = "accuracy"
  )

train_dataset <- mnist$train %>% 
  dataset_shuffle(1024) %>% 
  dataset_batch(32) %>% 
  dataset_map(unname)

test_dataset <- mnist$test %>% 
  dataset_batch(32) %>% 
  dataset_map(unname)

model %>% 
  fit(train_dataset, validation_data = test_dataset, epochs = 5)
```
