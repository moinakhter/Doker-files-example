#!/usr/bin/env bash

# Running Guide:
# In order to run the assistant face in 3d mode, you need to install chromium using the following command
# apt-get install chromium-browser
# now you can open chromium, move the chromium tab to the hologram and run this file.

chromium-browser --incognito --allow-file-access-from-files --window-position=0,0 --window-size=4480,2680 --start-fullscreen --no-default-browser-check --disable-infobars '../assistant/threejs/index.html'
