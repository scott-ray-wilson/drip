import envoy
import filepath
import gleam/bytes_tree
import gleam/erlang/atom
import gleam/erlang/process
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/int
import gleam/result
import mist.{type Connection, type ResponseData}
import simplifile

// --- Temp Directories --------------------------------------------------------

// A path under the system temp dir for throwaway artifacts.
pub fn path(name: String) -> String {
  let base =
    envoy.get("TMPDIR")
    |> result.lazy_or(fn() { envoy.get("TMP") })
    |> result.lazy_or(fn() { envoy.get("TEMP") })
    |> result.unwrap("/tmp")
  filepath.join(base, name)
}

pub fn with_temp_directory(name: String, body: fn(String) -> a) -> a {
  let directory = path(name)
  let _ = simplifile.delete(directory)
  let assert Ok(Nil) = simplifile.create_directory_all(directory)
  let result = body(directory)
  let _ = simplifile.delete(directory)
  result
}

// --- Test HTTP Server --------------------------------------------------------

pub fn with_server(
  handler: fn(Request(Connection)) -> Response(ResponseData),
  body: fn(Int) -> a,
) -> a {
  let port = process.new_subject()
  let assert Ok(started) =
    mist.new(handler)
    |> mist.port(0)
    |> mist.bind("127.0.0.1")
    |> mist.after_start(fn(bound, _scheme, _interface) {
      process.send(port, bound)
    })
    |> mist.start
  let assert Ok(bound) = process.receive(port, within: 5000)
  let result = body(bound)

  // Unlink first so the teardown signal doesn't cascade back to the test
  // process, then ask the supervisor to shut down gracefully.
  process.unlink(started.pid)
  process.send_abnormal_exit(started.pid, atom.create("shutdown"))
  result
}

pub fn respond(status: Int, body: String) -> Response(ResponseData) {
  response.new(status)
  |> response.set_body(mist.Bytes(bytes_tree.from_string(body)))
}

pub fn redirect(location: String) -> Response(ResponseData) {
  response.new(302)
  |> response.set_header("location", location)
  |> response.set_body(mist.Bytes(bytes_tree.new()))
}

pub fn base_url(port: Int) -> String {
  "http://127.0.0.1:" <> int.to_string(port)
}
