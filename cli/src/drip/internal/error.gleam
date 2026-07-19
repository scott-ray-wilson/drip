import gleam/dynamic/decode
import gleam/httpc.{type ConnectError, type HttpError}
import gleam/int
import gleam/json.{type DecodeError}
import gleam/list
import gleam/string
import simplifile.{type FileError}
import tomlet.{
  type EditError, type ExpectedType, type GetError, type ParseError,
  type SyntaxErrorKind,
}

// --- Error -------------------------------------------------------------------

pub type Error {
  // CLI
  InvalidUsage(message: String)
  NoElementsRequested(command: String)

  // Project
  FailedToFindProjectRoot(path: String)
  FailedToReadGleamToml(cause: FileError)
  FailedToParseGleamToml(cause: ParseError)
  FailedToGetGleamTomlValue(cause: GetError)
  FailedToEditGleamToml(cause: EditError)
  InvalidPrefix(got: String)
  FailedToCheckIfProjectFileExists(path: String, cause: FileError)
  FailedToReadProjectDirectory(path: String, cause: FileError)
  FailedToCreateProjectDirectory(path: String, cause: FileError)
  FailedToWriteProjectFile(path: String, cause: FileError)
  FailedToReadProjectFile(path: String, cause: FileError)
  FailedToDeleteProjectFile(path: String, cause: FileError)
  ProjectFileAlreadyExists(path: String)
  FailedToFindIndexStylesheet(path: String)

  // Source
  EmptySource
  InvalidSourceUrl(url: String)
  SourceNotFound(location: String)
  SourceReturnedBadStatus(url: String, status: Int)
  FailedToFetchSourceFile(url: String, cause: HttpError)
  FailedToReadSourceFile(path: String, cause: FileError)

  // Registry
  UnsupportedRegistrySchemaVersion(found: Int, supported: Int)
  FailedToDecodeRegistryFile(path: String, cause: DecodeError)
  UnknownElement(name: String)
  UnsupportedRegistryFile(element: String, file: String)
}

// --- Error Descriptions ------------------------------------------------------

pub fn describe(error: Error) -> String {
  case error {
    // CLI
    InvalidUsage(message) -> message
    NoElementsRequested(command) ->
      "No elements requested. "
      <> string.capitalise(command)
      <> " one or more elements by name using gleam run -m drip -- "
      <> command
      <> " <element>."

    // Project
    FailedToFindProjectRoot(path) -> {
      let location = case path {
        "./" -> "the current directory"
        _ -> quote(path)
      }
      "Failed to find gleam.toml in "
      <> location
      <> " or any parent directory. Ensure you're inside a Gleam project."
    }
    FailedToReadGleamToml(cause) ->
      "Failed to read gleam.toml: " <> simplifile.describe_error(cause) <> "."
    FailedToParseGleamToml(cause) ->
      "Failed to parse gleam.toml: " <> describe_parse_error(cause)
    FailedToGetGleamTomlValue(cause) ->
      "Failed to get gleam.toml value: " <> describe_get_error(cause)
    FailedToEditGleamToml(cause) ->
      "Failed to update gleam.toml: " <> describe_edit_error(cause)
    InvalidPrefix(got) ->
      "The prefix "
      <> quote(got)
      <> " isn't a valid module path. Use lowercase identifier segments like"
      <> " ui or lib/ui."
    FailedToCheckIfProjectFileExists(path, cause) ->
      "Failed to check whether a file exists at "
      <> quote(path)
      <> ": "
      <> simplifile.describe_error(cause)
      <> "."
    FailedToReadProjectDirectory(path, cause) ->
      "Failed to list the contents of "
      <> quote(path)
      <> ": "
      <> simplifile.describe_error(cause)
      <> "."
    FailedToCreateProjectDirectory(path, cause) ->
      "Failed to create the parent directory for "
      <> quote(path)
      <> ": "
      <> simplifile.describe_error(cause)
      <> "."
    FailedToWriteProjectFile(path, cause) ->
      "Failed to write "
      <> quote(path)
      <> ": "
      <> simplifile.describe_error(cause)
      <> "."
    FailedToReadProjectFile(path, cause) ->
      "Failed to read "
      <> quote(path)
      <> ": "
      <> simplifile.describe_error(cause)
      <> "."
    FailedToDeleteProjectFile(path, cause) ->
      "Failed to delete "
      <> quote(path)
      <> ": "
      <> simplifile.describe_error(cause)
      <> "."
    ProjectFileAlreadyExists(path) ->
      quote(path) <> " already exists. Pass --force to overwrite."
    FailedToFindIndexStylesheet(path) ->
      "Failed to find index stylesheet at "
      <> quote(path)
      <> ". Initialize your project with gleam run -m drip -- init."

    // Source
    EmptySource ->
      "The source is empty. Set it to a URL or path, or remove it to use the"
      <> " default."
    InvalidSourceUrl(url) ->
      "The source isn't a valid URL: " <> quote(url) <> "."
    SourceNotFound(location) ->
      "Failed to find the source file at "
      <> quote(location)
      <> ". Check that the source points at a valid registry."
    SourceReturnedBadStatus(url, status) ->
      "Failed to fetch the source file at "
      <> quote(url)
      <> ": received HTTP status code "
      <> int.to_string(status)
      <> "."
    FailedToFetchSourceFile(url, cause) ->
      "Failed to fetch the source file at "
      <> quote(url)
      <> ": "
      <> describe_http_error(cause)
    FailedToReadSourceFile(path, cause) ->
      "Failed to read the source file at "
      <> quote(path)
      <> ": "
      <> simplifile.describe_error(cause)
      <> "."

    // Registry
    UnsupportedRegistrySchemaVersion(found, supported) ->
      "This registry is on schema version "
      <> int.to_string(found)
      <> ", but this version of drip only supports schema versions up to "
      <> int.to_string(supported)
      <> ". Update drip to use this registry."
    FailedToDecodeRegistryFile(path, cause) ->
      "Failed to decode the registry file at "
      <> quote(path)
      <> ": "
      <> describe_decode_error(cause)
    UnknownElement(name) ->
      "No element named "
      <> quote(name)
      <> " in the registry. See what's available with gleam run -m drip -- list."
    UnsupportedRegistryFile(element, file) ->
      "The registry entry "
      <> quote(element)
      <> " lists an unsupported file path "
      <> quote(file)
      <> ". Registry file names must be plain names, without \"/\", \"\\\", or \"..\"."
  }
}

fn describe_parse_error(error: ParseError) -> String {
  case error {
    tomlet.InvalidEncoding -> "the file is not valid UTF-8."
    tomlet.InvalidSyntax(kind:, offset:) ->
      describe_syntax_error(kind)
      <> " at byte offset "
      <> int.to_string(offset)
      <> "."
    tomlet.DuplicateKey(key:, offset: _) ->
      "the key " <> quote_key(key) <> " is defined more than once."
  }
}

fn describe_syntax_error(kind: SyntaxErrorKind) -> String {
  case kind {
    tomlet.ExpectedValue -> "expected a value"
    tomlet.ExpectedKey -> "expected a key"
    tomlet.ExpectedTableHeader -> "expected a table header"
    tomlet.InvalidToml -> "invalid TOML"
  }
}

fn describe_get_error(error: GetError) -> String {
  case error {
    tomlet.KeyNotFound(key:) ->
      "missing the required key " <> quote_key(key) <> "."
    tomlet.WrongType(key:, expected:) ->
      "expected "
      <> quote_key(key)
      <> " to be "
      <> describe_expected_type(expected)
      <> "."
  }
}

fn describe_expected_type(expected: ExpectedType) -> String {
  case expected {
    tomlet.ExpectedString -> "a string"
    tomlet.ExpectedInt -> "an integer"
    tomlet.ExpectedBool -> "a boolean"
    tomlet.ExpectedFloat -> "a float"
    tomlet.ExpectedDate -> "a date"
    tomlet.ExpectedTime -> "a time"
    tomlet.ExpectedDateTime -> "a date-time"
  }
}

fn describe_edit_error(error: EditError) -> String {
  case error {
    tomlet.EmptyKeyPath -> "the edit key path was empty."
    tomlet.InvalidKeySegment(segment:) ->
      "the key segment " <> quote(segment) <> " cannot be written as TOML."
    tomlet.InvalidCommentText -> "a comment spanned more than one line."
    tomlet.MissingEditKey(key:) ->
      "no value exists at " <> quote_key(key) <> "."
    tomlet.KeyConflict(key:) ->
      quote_key(key) <> " conflicts with an existing value."
    tomlet.InlineTableInsertUnsupported(key:) ->
      "cannot insert "
      <> quote_key(key)
      <> " into an existing inline table; rewrite it as a [tools.drip] section."
    tomlet.InvalidValue -> "the value can't be represented here."
  }
}

fn describe_http_error(error: HttpError) -> String {
  case error {
    httpc.InvalidUtf8Response -> "response body was not valid UTF-8."
    httpc.ResponseTimeout -> "response timed out."
    httpc.FailedToConnect(ip4, ip6) ->
      "failed to connect (ipv4: "
      <> describe_connect_error(ip4)
      <> ", ipv6: "
      <> describe_connect_error(ip6)
      <> ")."
  }
}

fn describe_connect_error(error: ConnectError) -> String {
  case error {
    httpc.Posix(code) -> code
    httpc.TlsAlert(code, detail) -> code <> " (" <> detail <> ")"
  }
}

fn describe_decode_error(error: DecodeError) -> String {
  case error {
    json.UnexpectedEndOfInput -> "the file ended unexpectedly."
    json.UnexpectedByte(byte) -> "unexpected byte " <> quote(byte) <> "."
    json.UnexpectedSequence(sequence) ->
      "unexpected sequence " <> quote(sequence) <> "."
    json.UnableToDecode(errors) ->
      "the contents don't match the expected registry format ("
      <> { errors |> list.map(describe_field_error) |> string.join(", ") }
      <> ")."
  }
}

fn describe_field_error(error: decode.DecodeError) -> String {
  let decode.DecodeError(expected:, found:, path:) = error
  let location = case path {
    [] -> ""
    _ -> " at " <> quote(string.join(path, "."))
  }
  "expected " <> expected <> " but found " <> found <> location
}

// --- Formatting --------------------------------------------------------------

fn quote(value: String) -> String {
  "\"" <> value <> "\""
}

fn quote_key(key: List(String)) -> String {
  quote(string.join(key, "."))
}
