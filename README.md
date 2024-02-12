# OBS Portable Launcher
## About
**OBS Studio** is software designed for capturing, compositing, encoding, recording, and streaming video content, efficiently. [Know More](https://obsproject.com)

**OBS Studio** is available in two forms on Windows OS: Installer and Portable ZIP. When we use the portable ZIP and run the OBS executable with the "-p" argument, OBS runs in portable mode. However, the problem is that on each new system, we have to repeatedly set the media paths, which makes it painful. This also undermines the convenience of portable use to some extent. Additionally, OBS does not support relative paths.

**OBS Portable Launcher** resolves this problem by making OBS completely portable without the need to set media paths repeatedly. This script is kept alongside the extracted OBS folder. It maps the OBS folder to a drive and mounts it. We can create a separate folder named "assets" or something similar within the OBS folder and move all the media to it. When the script is launched, it starts OBS, and only once is required to map the media with the mounted drive. Now, you can simply copy and paste this script with the OBS folder to a USB drive and go to any Windows device. Simply run the script, OBS will start, and there's no need to set the media paths again.
