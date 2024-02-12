# OBS Portable Launcher

<font color="red">**Use at your own risk. I am not responsible for any consequences.**</font>

## About
**OBS Studio** is software designed for capturing, compositing, encoding, recording, and streaming video content, efficiently. [Know More](https://obsproject.com)

**OBS Studio** is available in two forms on Windows OS: Installer and Portable ZIP. When we use the portable ZIP and run the OBS executable with the "-p" argument, OBS runs in portable mode. However, the problem is that on each new system, we have to repeatedly set the media paths, which makes it painful. This also undermines the convenience of portable use to some extent. Additionally, OBS does not support relative paths.

**OBS Portable Launcher** resolves this problem by making OBS completely portable without the need to set media paths repeatedly. This script is kept alongside the extracted OBS folder. It maps the OBS folder to a drive and mounts it. We can create a separate folder named "assets" or something similar within the OBS folder and move all the media to it. When the script is launched, it starts OBS, and only once is required to map the media with the mounted drive. Now, you can simply copy and paste this script with the OBS folder to a USB drive and go to any Windows device. Simply run the script, OBS will start, and there's no need to set the media paths again.

## Limitations
- Only Windows supported.

## Download
The script can be downloaded by either cloning it or downloading it from the releases section.

## Installation & Quick Start
1. This script does not require any formal installation process.
2. Create a new folder with any name, for example "stream", and copy the script into the "stream" folder.
3. Download the latest OBS portable ZIP from the website and extract it to a new folder. Let's name this folder "obs".
4. Copy the "obs" folder to the "stream" folder.
5. Open the script with any text editor and verify the configurable fields. If the configurable fields are invalid, the script will not run and will display errors. If there are no errors, the script will launch the OBS executable after mounting the "obs" folder as a drive letter. In my case, it's "O:".
6. Keep OBS open, then create a new folder named "assets" in the drive letter assigned to the "obs" folder (in this case, "O:"). Next, copy all media files to this "assets" folder.
7. Now, while keeping OBS open, create your scenes and provide the asset paths using the drive letter "O:". This ensures that OBS references the media files from the "assets" folder located on the mounted drive.
8. You're done! Simply copy and paste the "stream" folder to your USB drive, and you can use it on other Windows devices without any hassle.

9. ## Contributions
- Report bugs, ask questions and suggest new features by creating a new issue.
- Donate to [**Solifice**](https://linktr.ee/solifice).

## Credits
1. This script utilizes OBS (Open Broadcaster Software) for streaming and recording. We acknowledge and appreciate the contribution of the OBS team and community. For more information about OBS, visit [OBS Website](https://obsproject.com).
2. This script is written in VBScript (Visual Basic Scripting Edition). We acknowledge and appreciate the functionality provided by VBScript. For more information about VBScript, visit [Microsoft's VBScript documentation](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/legacy/mt829240(v=vs.85)).
