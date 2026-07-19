import drip/internal/error.{type Error}
import filepath
import gleam/http/request
import gleam/httpc
import gleam/result
import gleam/string
import simplifile

// --- Source ------------------------------------------------------------------

pub opaque type Source {
  Http(base: String)
  Local(root: String)
}

pub fn parse(raw: String) -> Result(Source, Error) {
  case string.trim(raw) |> trim_trailing_slash {
    "" -> Error(error.EmptySource)
    source ->
      case is_http(source) {
        True ->
          case request.to(source) {
            Ok(_) -> Ok(Http(source))
            Error(Nil) -> Error(error.InvalidSourceUrl(source))
          }
        False -> Ok(Local(source))
      }
  }
}

fn is_http(raw: String) -> Bool {
  let lower = string.lowercase(raw)
  string.starts_with(lower, "http://") || string.starts_with(lower, "https://")
}

fn trim_trailing_slash(raw: String) -> String {
  case string.ends_with(raw, "/") {
    True -> trim_trailing_slash(string.drop_end(raw, 1))
    False -> raw
  }
}

// --- Fetch -------------------------------------------------------------------

pub fn fetch(source: Source, filename: String) -> Result(String, Error) {
  case source {
    Http(base) -> http_get(base <> "/" <> filename)
    Local(root) -> read_file(filepath.join(root, filename))
  }
}

fn read_file(path: String) -> Result(String, Error) {
  case simplifile.read(path) {
    Ok(content) -> Ok(content)
    Error(cause) -> Error(error.FailedToReadSourceFile(path:, cause:))
  }
}

fn http_get(url: String) -> Result(String, Error) {
  use request <- result.try(case request.to(url) {
    Ok(request) -> Ok(request.set_header(request, "user-agent", "drip-cli"))
    Error(Nil) -> Error(error.InvalidSourceUrl(url))
  })

  let config =
    httpc.configure()
    |> httpc.follow_redirects(True)
    |> httpc.timeout(30_000)

  case httpc.dispatch(config, request) {
    Ok(response) -> {
      case response.status {
        status if status >= 200 && status < 300 -> Ok(response.body)
        404 -> Error(error.SourceNotFound(url))
        status -> Error(error.SourceReturnedBadStatus(url, status))
      }
    }
    Error(cause) -> Error(error.FailedToFetchSourceFile(url, cause))
  }
}
