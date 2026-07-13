wrapper_names_from_namespace <- function() {
  exports <- getNamespaceExports("ahritre")
  wrappers <- exports[vapply(exports, function(name) {
    fn <- get(name, envir = asNamespace("ahritre"), mode = "function")
    fml <- names(formals(fn))
    identical(fml, c("client", "...", ".body", ".protocol_version"))
  }, logical(1))]
  sort(unique(wrappers))
}

test_that("all generated wrappers are present", {
  wrappers <- wrapper_names_from_namespace()

  expect_gt(length(wrappers), 0L)
  expect_equal(length(wrappers), 123L)
})

test_that("generated wrappers map function names to protocol kinds", {
  wrappers <- wrapper_names_from_namespace()

  for (fn in wrappers) {
    wrapper <- get(fn, mode = "function")

    captured <- testthat::with_mocked_bindings(
      execute_json = function(client, request) {
        list(client = client, request = request)
      },
      wrapper(list(client = "ok"), token = "abc")
    )

    expect_equal(captured$request$kind, gsub("_", ".", fn, fixed = TRUE), info = fn)
    expect_equal(captured$request$protocol_version, TRE_PROTOCOL_VERSION, info = fn)
    expect_equal(captured$request$body$token, "abc", info = fn)
  }
})

test_that("explicit body overrides variadic body fields", {
  captured <- testthat::with_mocked_bindings(
    execute_json = function(client, request) {
      request
    },
    asset_list(
      list(client = "ok"),
      ignored = TRUE,
      .body = list(study = "demo"),
      .protocol_version = "9.9.9"
    )
  )

  expect_equal(captured$kind, "asset.list")
  expect_equal(captured$protocol_version, "9.9.9")
  expect_equal(captured$body, list(study = "demo"))
})