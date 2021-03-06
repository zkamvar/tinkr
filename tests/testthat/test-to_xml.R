context("test-to_xml")

test_that("to_xml works", {
  path <- system.file("extdata", "example1.md", package = "tinkr")
  post_list <- to_xml(path)
  expect_equal(names(post_list)[1], "yaml")
  expect_equal(names(post_list)[2], "body")
  expect_is(post_list[[2]], "xml_document")
})

test_that("to_xml works for Rmd", {
  path <- system.file("extdata", "example2.Rmd", package = "tinkr")
  post_list <- to_xml(path)
  expect_equal(names(post_list)[1], "yaml")
  expect_equal(names(post_list)[2], "body")
  expect_is(post_list[[2]], "xml_document")

  blocks <- post_list[[2]] %>%
    xml2::xml_find_all(xpath = './/d1:code_block',
                       xml2::xml_ns(.)) %>%
    .[xml2::xml_has_attr(., "language")]

  expect_equal(length(blocks), 4)

})

test_that("to_xml works with sourcepos", {
  path <- system.file("extdata", "example1.md", package = "tinkr")
  post_list <- to_xml(path, sourcepos = TRUE)
  expect_equal(names(post_list)[1], "yaml")
  expect_equal(names(post_list)[2], "body")
  expect_is(post_list[[2]], "xml_document")
  expect_true(xml2::xml_has_attr(post_list[[2]], "sourcepos"))
  expect_match(xml2::xml_attr(post_list[[2]], "sourcepos"), "^1:1-\\d+?:\\d+$")
})

test_that("to_xml works with sourcepos for Rmd", {
  path <- system.file("extdata", "example2.Rmd", package = "tinkr")
  post_list <- to_xml(path, sourcepos = TRUE)
  expect_equal(names(post_list)[1], "yaml")
  expect_equal(names(post_list)[2], "body")
  expect_is(post_list[[2]], "xml_document")
  expect_true(xml2::xml_has_attr(post_list[[2]], "sourcepos"))
  expect_match(xml2::xml_attr(post_list[[2]], "sourcepos"), "^1:1-\\d+?:\\d+$")
  # code blocks retain their attributes
  first_block <- xml2::xml_find_first(post_list[[2]], ".//d1:code_block")

  expect_match(xml2::xml_attr(first_block, "space"), "preserve")
  expect_match(xml2::xml_attr(first_block, "sourcepos"), "^\\d+?:\\d+?-\\d+?:\\d+$")
  expect_match(xml2::xml_attr(first_block, "language"), "r")
  expect_match(xml2::xml_attr(first_block, "name"), "setup")
  expect_match(xml2::xml_attr(first_block, "include"), "FALSE")
  expect_match(xml2::xml_attr(first_block, "eval"), "TRUE")
})
