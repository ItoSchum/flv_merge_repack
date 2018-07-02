# Merge & Repack flv to mp4

## Main Feature
- Merge flv fragment videos with repacking as mp4 using **FFmpeg**.
- Automatically remove the original fragment videos and some interim files.
- A sorted original fragment videos' filelist will be left.

## Requirement
1. `sh` and `ffmpeg` are required.
2. The flv videos which are encoded by H.264.
3. Designed specifically for macOS App **Bilibili for Mac**. It may be not compatible for other Apps.

## Usage
1. Put your flv fragment videos in `[some_directory]`.
2. Change your Teriminal's current directory to `[some_directory]`.
3. Run the script.

## Attention
- The original flv videos will be removed.