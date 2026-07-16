# IPCV Tests

IPCV OpenCV 5.0.0 development uses a manifest-driven runner. Every `.tst` file under
`tests/unit_tests` receives a suite, family, requirement list, and supported
platform declaration from `test_manifest.sce`.

## Suites

| Suite | Purpose | External requirement |
| --- | --- | --- |
| `core` | Deterministic function and category regressions. | Built and loadable IPCV toolbox. |
| `integration` | Local codecs, bundled models/assets, video, stitching, and native handle lifecycles. | Bundled repository assets. |
| `stability` | Focused release signal spanning critical core and integration paths. | Bundled repository assets. |
| `release` | All `core` and `integration` tests. | Bundled repository assets. |
| `gui` | Plotting and image-display behavior. | Scilab GUI/graphics session. |
| `network` | Trusted external model download and inference. | Network access and disk space. |
| `hardware` | Physical camera open/read/close behavior. | A working camera; index defaults to 0. |
| `all` | Every classified test. | All requirements above. |

Network, GUI, and hardware tests are intentionally excluded from `release` so
an unavailable service or device cannot disguise a deterministic regression.

## Windows

Run the focused stability suite:

```powershell
powershell -ExecutionPolicy Bypass -File tests/run_tests.ps1 -ScilabExecutable "C:\Tools\scilab-2026.1.0\bin\WScilex-cli.exe" -Suite stability
```

Run selected tests regardless of their normal suite:

```powershell
powershell -ExecutionPolicy Bypass -File tests/run_tests.ps1 -ScilabExecutable "C:\Tools\scilab-2026.1.0\bin\WScilex-cli.exe" -TestNames "ipcv_image_io,ipcv_codec_matrix"
```

Use `WScilex.exe` for the `gui` suite. Set `IPCV_CAMERA_INDEX` before running
the `hardware` suite when the desired camera index is not 0.

Run static validation and the complete deterministic release suite:

```powershell
powershell -ExecutionPolicy Bypass -File tests/run_release_checks.ps1 -ScilabExecutable "C:\Tools\scilab-2026.1.0\bin\WScilex-cli.exe"
```

The optional `-Build` switch runs `builder.sce` first. Launch that command from
a Visual Studio x64 native tools prompt so MSVC and the linker are available.

## Linux And macOS

```sh
sh ./tests/run_tests.sh /path/to/scilab-cli stability
```

The second argument is the suite and the optional third argument is a
comma-separated list of test names. Set `IPCV_TEST_TIMEOUT` to change the
default 600-second watchdog.

## Results

Wrappers write semicolon-delimited CSV reports under `tests/results`. Each row
contains the test name, suite, family, platforms, requirements, result,
duration, and error message. The directory is ignored by git.

Both wrappers monitor a progress file. If Scilab blocks in native code or stays
at its prompt after an error, the wrapper terminates that process and reports
the last test that started.

## Adding A Test

1. Add a uniquely named `.tst` file under `tests/unit_tests`.
2. Add a matching `.dia.ref`, or include `<!-- NO CHECK REF -->` using Scilab's
   test marker form `// <-- NO CHECK REF -->` when output comparison is not used.
3. Add tests with GUI, network, hardware, or integration requirements to the
   matching list in `test_manifest.sce`. New deterministic tests default to
   `core`.
4. Keep network, hardware, and large-model behavior out of deterministic tests.
5. Use `TMPDIR` for generated files and remove them before the test completes.
6. Add critical regressions to the stability list only when they are fast and
   deterministic or use bundled local assets.
7. Run `validate_repository.ps1`, the affected named tests, and the `stability`
   suite before committing.
