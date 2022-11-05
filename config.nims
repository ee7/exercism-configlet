switch("styleCheck", "hint")
hint("Name", on)
# switch("experimental", "strictEffects") # TODO: re-enable when possible with `parsetoml`
switch("experimental", "strictFuncs")
switch("define", "nimStrictDelete")
when defined(nimHasOutParams):
  switch("experimental", "strictDefs")

# Replace the stdlib JSON modules with our own stricter versions.
patchFile("stdlib", "json", "src/patched_stdlib/json")
patchFile("stdlib", "parsejson", "src/patched_stdlib/parsejson")

if defined(zig) and findExe("zigcc").len > 0:
  switch("cc", "clang")
  # We can't write `zig cc` below, because the value cannot contain a space.
  switch("clang.exe", "zigcc")
  switch("clang.linkerexe", "zigcc")
  const target {.strdefine.} = block:
    const zigCpu =
      case hostCPU
      of "amd64": "x86_64"
      of "arm64": "aarch64"
      of "powerpc64el": "powerpc64le"
      else: hostCPU
    zigCpu & "-linux-musl"
  switch("passC", "-target " & target)
  switch("passL", "-target " & target)

if defined(release):
  switch("opt", "size")
  switch("passC", "-flto")
  switch("passL", "-flto")

  if defined(linux) or defined(windows):
    switch("passL", "-s")
    switch("passL", "-static")

  if defined(linux) and not defined(zig):
    if defined(gcc):
      switch("gcc.exe", "musl-gcc")
      switch("gcc.linkerexe", "musl-gcc")
    elif defined(clang):
      switch("clang.exe", "musl-clang")
      switch("clang.linkerexe", "musl-clang")
