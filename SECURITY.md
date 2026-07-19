# Security Policy

## Reporting a vulnerability

Please report security vulnerabilities **privately**, not through public issues.

Use GitHub's [private vulnerability reporting](https://docs.github.com/en/code-security/security-advisories/guidance-on-reporting-and-writing-information-about-vulnerabilities/privately-reporting-a-security-vulnerability)
on this repository: open the **Security** tab and choose **Report a
vulnerability**.

Please include enough detail to reproduce the issue. We aim to acknowledge a
report within a few days, then work with you on a fix and credit you in the
release notes unless you prefer otherwise.

## Supported versions

Only the latest release receives security fixes. Vendored elements are copied
into your project and do not change when you upgrade Drip, so a fix reaches
code you have already added only after you re-vendor it with `add --force`.

## Trust model

Vendored elements become part of your project: `add` and `init` write Gleam and
CSS that your toolchain then compiles and runs. Whatever the source serves is
code you execute, so the source is Drip's entire security surface.

Drip trusts that source through the transport, not by verifying its contents:

- The default source is this project's GitHub Release, fetched over HTTPS with
  your system's standard TLS verification.
- Files carry no signatures or per-file hashes. Integrity rests on HTTPS plus
  GitHub's control of the Release; Drip cannot detect a file that was tampered
  with and still served under a valid certificate.
- A custom source, set through `init --source` or `[tools.drip].source` in
  `gleam.toml`, is trusted as-is, so point it only at a source you would run
  code from. An `http://` base is additionally unauthenticated and sent in the
  clear, so prefer `https://` or a local path for anything but a throwaway
  fixture.

This is how comparable vendoring tools work (shadcn/ui does not verify contents
either) and is sufficient while the source is a first-party Release. Per-file
hashes in the index would catch corruption or a mirror serving the wrong bytes,
but not a compromised source, since the index travels the same channel as the
files it lists; signing the Release is the real path to tamper resistance, and
the natural next step if these assumptions change.

Weaknesses in this model are in scope for a report. Malicious code served by a
custom source you configured yourself is not: such a source is trusted by
design, so vetting it is your responsibility.