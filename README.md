# shell-scripts
This repo contains a few shell scripts that make Android development a little easier. They are mainly wrappers around functionality ADB provides.  However, these scripts are smart enough to detect when multiple devices or emulators are running, and will prompt for which device to use.

## Setup instructions
Before using the scripts in this repo, define an environment variable that points to the directory that stores these scripts.  For example:
```
export SHELL_SCRIPTS_HOME=/Users/mitsnosrap/dev/shell-scripts
```

Also, be sure to have the following Android SDK paths set in your `PATH` environment variable (where $ANDROID_HOME points to your Android SDK installation directory):
- $ANDROID_HOME/tools
- $ANDROID_HOME/platform-tools
- $ANDROID_HOME/tools/bin
- $ANDROID_HOME/tools/proguard/bin
