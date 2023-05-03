# ⚠ Unofficial support

You should really be using the integrated OBS Virtual Camera over this plugin. This is used as a stop-gap for things that don't yet work with the integrated Virtual Camera (like https://github.com/obsproject/obs-studio/issues/3635 and https://github.com/opencv/opencv/issues/19746). I do not plan on supporting this fork outside of necessary updates if OBS breaks the plugin. And will only do so until the aforementionned issue is fixed.

I modified this plugin so that it can auto start when used as a filter

# OBS-VirtualCam

![CI Windows Release](../../workflows/CI%20Windows%20Release/badge.svg) ![CI Windows On-Push](../../workflows/CI%20Windows%20On-Push/badge.svg)

obs-virutalcam is a plugin for obs-studio , transforming the output video to a virtual directshow device.
Modify to autostart on the filter plugin

**Supported Platforms** : Windows 10+

**Supported OBS Studio version** : 28.0.0+

# Features

* **virtual output** : A output plugin sink raw video & audio to directshow interface.
* **virtual filter output** : A filter plugin sink obs source video to directshow interface.
* **virtual source** : Four directshow Interfaces which can use in 3rd party software.

# Install

The installer and compressed file can be found in [Release Page](../../releases). Using installer is recommended, but if you want to use compressed file to install manually , please follow these instructions.

1. Unzip OBS-VirtualCam.zip and put it to your obs-studio install folder.
2. Run CMD as Administrator and register 64bit directshow source

```bat
regsvr32 "C:\Program Files\obs-studio\bin\64bit\obs-virtualsource.dll"
```

* If you want to Remove the directshow filter , you can also use regsvr32 to do this

```bat
regsvr32 /u "C:\Program Files\obs-studio\bin\64bit\obs-virtualsource.dll"
```

# Register specific number of virtual cameras

Unregister then register 2 directshow camera (up to 4)

```bat
regsvr32 /u "C:\Program Files\obs-studio\bin\64bit\obs-virtualsource.dll" 
regsvr32 /n /i:"2" "C:\Program Files\obs-studio\bin\64bit\obs-virtualsource.dll"
```

# Build

You first need to install [cmake](https://cmake.org/download/), [Visual Studio](https://visualstudio.microsoft.com/), and [build OBS project](https://github.com/obsproject/obs-studio/wiki/Install-Instructions#building-obs-studio).
Run cmake with the following variables:

* **QTDIR** (path): QT folder
* **DepsPath** (path): FFmpeg folder in OBS dependencies package
* **LIBOBS_INCLUDE_DIR** (path) : Libobs  include folder
* **LIBOBS_LIB** (filepath) : obs.lib path
* **OBS_FRONTEND_LIB** (filepath): obs-frontend-api.lib path
* **PTHREAD_LIB** (filepath): w32-pthread.lib path

ie:

```powershell
cmake -S . -B build64 `
  -DQTDIR=<...>/obs-deps/windows-deps-qt6-2022-08-02-x64 `
  -DDepsPath=<...>/obs-deps/windows-deps-2022-08-02-x64 `
  -DLIBOBS_INCLUDE_DIR=<...>/obs-studio/libobs `
  -DLIBOBS_LIB=<...>/obs-studio/build64/libobs/RelWithDebInfo/obs.lib `
  -DOBS_FRONTEND_LIB=<...>/obs-studio/build64/UI/obs-frontend-api/RelWithDebInfo/obs-frontend-api.lib `
  -DPTHREAD_LIB=<...>/obs-studio/build64/deps/w32-pthreads/RelWithDebInfo/w32-pthreads.lib
```

Run msbuild: `msbuild /m /p:Configuration=RelWithDebInfo ./build64/obs-virtualcam.sln`

# Donate

If you like this plugin, you can donate to the original author (Fenrirthviti) via [Paypal.me](https://www.paypal.me/obsvirtualcam)
