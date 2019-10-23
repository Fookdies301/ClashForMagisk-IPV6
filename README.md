# Clash for Magisk IPV6

*this is a highly experimental version, moded mainly for my own use. You con use it at your own risk!*

this is based on Kr328's [Clash for Magisk](https://github.com/Kr328/ClashForMagisk).

A rule-based tunnel in Go. This module is wrapper for [clash](https://github.com/Dreamacro/clash)'s [folk by yuguorui](https://github.com/yuguorui/clash) that support IPV6 redir but haven't been merged into mainline.

[中文说明（未更新）](README_zh.md)

## Requirements

* arm64 ABI
* Android device running a kernel that has full support for ip6tables(CONFIG_IP6_NF_*), at most cases you must compile kernel yourself.

## License

See also [NOTICE](NOTICE) and [LICENSE](LICENSE)

## Feature

See also [clash](https://github.com/Dreamacro/clash)



## Configure

Data Path  `{InternalStorage}/Android/data/com.github.kr328.clash`

In data directory

* Clash configure file `config.yaml`
* Clash GEOIP database `Country.mmdb`
* Clash starter configure file `starter.yaml`
* Clash status file `RUNNING` or `STOPPED`
* Custom proxy mode directory `mode.d`



## Control

Data Path  `{InternalStorage}/Android/data/com.github.kr328.clash`

Create the following file to control clash, you can use `touch` from a terminal emulator.

* `START` - Start clash if stopped
* `STOP` - Stop clash if running
* `RESTART` - Restart clash



## Read logs

* On PC

  Run command

  `adb logcat -s Clash`

* On Android

  Run command

  `#logcat -s Clash`



## Custom Proxy Mode

Custom Mode Directory `{InternalStorage}/Android/data/com.github.kr328.clash/mode.d`

1. Create directory with mode name

2. Create script `on-start.sh` and `on-stop.sh`

   Example for thus script [link](module/src/main/raw/magisk/core/mode.d/)

3. Change `mode` in `starter.yaml`



## Build

1. Install JDK ,Gradle ,Android SDK ,Android NDK

2. Create `local.properties` on project root directory
   ```properties
   sdk.dir=/path/to/android-sdk
   ndk.dir=/path/to/android-ndk
   cmake.dir=/path/to/android-cmake/*version*
   ```

3. Run command
   ```bash
   ./gradlew build
   ```

4. Pick clash-for-magisk.zip from module/build/outputs
