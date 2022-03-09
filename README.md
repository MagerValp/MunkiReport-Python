# MunkiReport-Python 2 and 3

This repository provides packages that install Python 2 and Python 3 with PyObjC and a few other modules under `/Library/MunkiReport`. Symlinks are created at `/usr/local/munkireport` for `munkireport-python2` and `munkireport-python3`. The Python 2 package must be installed to continue running MunkiReport 5.x on macOS 12.3 and up. In the future the Python 3 package will be required as well.

| Package | Status | Description |
| --- | --- | --- |
| `MunkiReportPython2-2.7.18.pkg` | Required for 5.x | This package is required to run MunkiReport 5.x on macOS 12.3 |
| `MunkiReportMunkiPython3-1.0.pkg` | In Development | Install this package to use munki's included framework for Python 3 |
| `MunkiReportPython3-3.x.x.pkg` | In Development | This package is only required if you run MunkiReport *without* munki |
