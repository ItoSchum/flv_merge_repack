# Merge & Repack flv to mp4

## Main Feature
- Merge flv fragment videos with repacking as mp4 using **FFmpeg**.
- Automatically remove the original fragment videos and some interim files.
- A sorted original fragment videos' filelist will be left.

## Requirement
1. `bash`, `ffmpeg`, `parallel` are required.
2. Only compatible with flv videos which are encoded by H.264.
3. Designed specifically for macOS App **Bilibili for Mac**. It may be not compatible with other filename formats.

## Usage
1. Put your flv fragment videos in `[some_directory]`.
2. Change your Teriminal's current directory to `[some_directory]`.
3. Run the script.
4. When **`Merge Mode: (1: Single-Pack; 2: Multi-Pack): `** Diasplayed, please enter `merge_mode` as tutorial  
   When **`OriginalFileKeep (Y/N): `** Displayed, please enter `file_mode` as tutorial

### Mode Code Ref:

- For **`Merge Mode`**: 
	- **1** - Single-Pack Mode (Vidoes will be merged all in one.)
	- **2** - Multi-Pack Mode (Videos will be merged by different Parts.)

- For **`File Mode`**: 
	- **Y** - File-Keeping Mode (The original downloads will be keeped.)
	- **V** - Verbose Mode (In addition to keep original downloads, it keeps some interim filelist as logs.)
	- **N & Others** - Don't Keep Original Files (The original downloads will not be keeped.)

	
## Attention
- Other `.txt, .flv, .mp4` files in the script-running folder may be deleted unintenedly.