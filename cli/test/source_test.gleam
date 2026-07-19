import drip/internal/error
import drip/internal/source
import helpers
import simplifile

// --- Parse -------------------------------------------------------------------

pub fn parse_rejects_invalid_url_test() {
  let assert Error(error.InvalidSourceUrl("http://has space")) =
    source.parse("http://has space")
}

pub fn parse_rejects_empty_source_test() {
  let assert Error(error.EmptySource) = source.parse("")
}

pub fn parse_rejects_whitespace_source_test() {
  let assert Error(error.EmptySource) = source.parse("   ")
}

// A trailing slash must not double up in the fetched URL's path.
pub fn parse_trims_trailing_slash_test() {
  use port <- helpers.with_server(fn(request) {
    helpers.respond(200, request.path)
  })
  let assert Ok(source) = source.parse(helpers.base_url(port) <> "/")
  assert source.fetch(source, "registry.json") == Ok("/registry.json")
}

// --- Filesystem Source -------------------------------------------------------

pub fn fetch_reads_local_file_test() {
  use directory <- helpers.with_temp_directory("drip_source_read")
  let assert Ok(Nil) =
    simplifile.write(to: directory <> "/registry.json", contents: "hello")
  let assert Ok(source) = source.parse(directory)
  assert source.fetch(source, "registry.json") == Ok("hello")
}

pub fn fetch_errors_when_file_missing_test() {
  use directory <- helpers.with_temp_directory("drip_source_missing")
  let assert Ok(source) = source.parse(directory)
  let assert Error(error.FailedToReadSourceFile(_, _)) =
    source.fetch(source, "registry.json")
}

// --- HTTP Source -------------------------------------------------------------

pub fn fetch_reads_http_file_test() {
  use port <- helpers.with_server(fn(_request) { helpers.respond(200, "hello") })
  let assert Ok(source) = source.parse(helpers.base_url(port))
  assert source.fetch(source, "registry.json") == Ok("hello")
}

pub fn fetch_maps_404_to_source_not_found_test() {
  use port <- helpers.with_server(fn(_request) { helpers.respond(404, "") })
  let assert Ok(source) = source.parse(helpers.base_url(port))
  let assert Error(error.SourceNotFound(location)) =
    source.fetch(source, "registry.json")
  assert location == helpers.base_url(port) <> "/registry.json"
}

pub fn fetch_maps_other_status_to_bad_status_test() {
  use port <- helpers.with_server(fn(_request) { helpers.respond(503, "") })
  let assert Ok(source) = source.parse(helpers.base_url(port))
  let assert Error(error.SourceReturnedBadStatus(status: 503, ..)) =
    source.fetch(source, "registry.json")
}

// The default source is a github releases/latest/download URL, which 302s to
// the asset, so follow_redirects must actually be honored end to end.
pub fn fetch_follows_redirects_test() {
  use port <- helpers.with_server(fn(request) {
    case request.path {
      "/registry.json" -> helpers.redirect("/dist/registry.json")
      _ -> helpers.respond(200, "hello")
    }
  })
  let assert Ok(source) = source.parse(helpers.base_url(port))
  assert source.fetch(source, "registry.json") == Ok("hello")
}
