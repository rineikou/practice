# 视频
## mkv
>mp4永久嵌入字幕。
ffmpeg -i input.mp4 -vf "ass=subtitles.ass" output.mp4
mkv 添加字幕。
ffmpeg -i input.mkv -i subtitles.ass -c copy -c:s ass -metadata:s:s:0 language=chi -metadata:s:s:0 title=English-中文 output.mkv
mkv 提取字幕。
ffmpeg -i input.mkv -map 0:s:0 output.ass
- 压制视频
```shell
for file in *.mkv; do
    title="${file%.mkv}"
    ffmpeg -i "$file" -c:v h264_amf completed/"${title}_tmp.mp4"
    ffmpeg -i "$file" -map 0:v -map -0:V -c copy completed/"${file%.mp4}.jpg"
    ffmpeg -i completed/"${title}_tmp.mp4" -i "$title.jpg" -map 0 -map 1 -c copy -disposition:v:1 attached_pic completed/"${title}.mp4"
    rm completed/"${title}_tmp.mp4" completed/"${file%.mp4}.jpg"
    fi
done
```

```ass
[Script Info]
; 中英双字幕
Title: <视频标题>
ScriptType: v4.00+
PlayResX: 1920
PlayResY: 1080

[V4+ Styles]
Format: Name, Fontname, Fontsize, PrimaryColour, SecondaryColour, OutlineColour, BackColour, Bold, Italic, Underline, StrikeOut, ScaleX, ScaleY, Spacing, Angle, BorderStyle, Outline, Shadow, Alignment, MarginL, MarginR, MarginV, Encoding
Style: Default, Arial, 28, &H00FFFFFF, &H000000FF, &H00000000, &H80000000, -1, 0, 0, 0, 100, 100, 0, 0, 1, 2, 2, 2, 10, 10, 10, 1
Style: zh, Arial, 28, &H00FFFFFF, &H000000FF, &H00000000, &H80000000, -1, 0, 0, 0, 100, 100, 0, 0, 1, 2, 2, 2, 10, 10, 10, 1
Style: ja, Arial, 28, &H00FFFFFF, &H000000FF, &H00000000, &H80000000, -1, 0, 0, 0, 100, 100, 0, 0, 1, 2, 2, 2, 10, 10, 10, 1
Style: en, Arial, 28, &H00FFFFFF, &H000000FF, &H00000000, &H80000000, -1, 0, 0, 0, 100, 100, 0, 0, 1, 2, 2, 2, 10, 10, 10, 1

[Events]
Format: Layer, Start, End, Style, Name, MarginL, MarginR, MarginV, Effect, Text
Dialogue: 0,0:00:01.00,0:00:05.00,en,,0000,0000,0000,,I love you.\N{\rCN}我爱你
Dialogue: 0,0:00:01.00,0:00:05.00,ja,,0000,0000,0000,,君を愛してる\N{\rCN}我爱你
```
## mp4
> 拼接视频文件。LIST.TXT为视频列表文件，回车隔开每个视频 
`ffmpeg -f concat -safe 0 -i LIST.TXT -c copy output.mp4`
 裁剪视频。-ss开始时间，-t持续时间
`ffmpeg -i INPUT.MP4 -ss 00:00:10 -t 00:00:20 -c copy OUTPUT.MP4`
 添加封面。
`ffmpeg -i INPUT.MP4 -i COVER.JPG -map 0 -map 1 -c copy -disposition:v:1 attached_pic OUTPUT.MP4`
 提取封面。
`ffmpeg -i INPUT.MP4 -map v -map -V -c copy COVER.JPG`
 提取音频。
`ffmpeg -i input.mp4 -map a -c copy OUTPUT.MP4`
 压缩画质。
`ffmpeg -i INPUT.MP4 -b:v 1024k -vf "scale=1280:720" -r 30 -c:v h264_nvenc OUTPUT.MP4 //-b比特率,-vf分辨率,-r帧率`
 生成字幕。
`whisper -l ja -osrt -m C:\PortableTools\Whisper\ggml-base.bin input.mp4`
- 压制并添加封面
```shell
#!/bin/sh
mkdir -p completed
for file in *.mp4; do
    title="${file%.mp4}"
    ffmpeg -i "$file" -b:v 1024k -vf "scale=-2:720" -c:v h264_amf -c:a copy completed/"${title}_tmp.mp4"
    if [ -f "$title.jpg" ]; then
        ffmpeg -i completed/"${title}_tmp.mp4" -i "$title.jpg" -map 0 -map 1 -c copy -disposition:v:1 attached_pic completed/"$file"
        rm completed/"${title}_tmp.mp4"
    fi
done
```

```batch
@echo off
if not exist "completed" mkdir completed
REM 原始文件名（%~nf）,原始文件扩展名（%~xf）
for %%f in (*.mp4) do (
    set "title=%%~nf"
    ffmpeg -i "%%f" -b:v 1024k -vf "scale=-2:720" -c:v h264_nvenc -c:a copy "completed\%%~nf_tmp.mp4"
    if exist "%%~nf.jpg" (
        ffmpeg -i "completed\%%~nf_tmp.mp4" -i "%%~nf.jpg" -map 0 -map 1 -c copy -disposition:v:1 attached_pic "completed\%%f"
        del "completed\%%~nf_tmp.mp4"
    )
)
```
- 合并视频文件
```shell
#!/bin/sh
echo -e "file '1.mp4'\nfile '2.mp4'\nfile '3.mp4'">|concat_list
ffmpeg -f concat -safe 0 -i concat_list -c copy temp.mp4
if [ -f temp.mp4 ]; then
    rm -f 1.mp4 2.mp4 3.mp4
if
```

```batch
@echo off
(echo file '1.mp4' & echo file '2.mp4' & echo file '3.mp4') > concat_list.txt
ffmpeg -f concat -safe 0 -i concat_list.txt -c copy temp.mp4
if exist temp.mp4 (
    del 1.mp4 2.mp4 3.mp4
)
```
- 提取封面
```shell
#!/bin/sh
for file in *.mp4; do
    ffmpeg -i "$file" -map 0:v -map -0:V -c copy "${file%.mp4}.jpg"
```

```batch
@echo off
for %%f in (*.mp4) do ffmpeg -i "%%f" -map 0:v -map -0:V -c copy "%%~nf.jpg"
```

## flac

```lrc
[ti:<标题>]
[ar:<歌手>]
[al:<专辑>]
[by:<歌词编辑>]
[00:00]歌：レミオロメン
[00:00]作詞：藤巻亮太
[00:00]作曲：藤巻亮太
[00:22.869]两只老虎爱跳舞
```
## mp3

## 资源
```shell
# yt-dlp下载视频
yt-dlp -f ba+bv \
--merge-output-format mkv \
--embed-subs \
--all-subs \
--embed-thumbnail \
--convert-thumbnails png \
--embed-chapters \
--add-metadata \
--compat-options no-live-chat \
--download-archive videos.txt \
--cookies cookies.txt \
--proxy <Proxy URL> \
-o "youtube_%(title)s_%(channel)s(%(channel_id)s)_%(id)s.mkv" \
<VideoURL>
```

# 图片
>常用的**图片格式**，按照质量和功能从高到低排列：    
`SVG`：是一种无损的、矢量的、支持动画和交互的图片格式，可以保持图片的清晰度和无限缩放，适合用于绘制图形、图标、Logo等。    
`PSD`：是Photoshop的默认格式，是一种无损的、点阵的、支持图层、路径、通道等信息的图片格式，可以保持图片的编辑性和复杂性，适合用于存储源文件和工作文件。    
`TIFF`：是一种无损的、点阵的、支持多种颜色模式和透明度的图片格式，可以保持图片的高质量和打印性，适合用于印刷或打印输出。    
`PNG`：是一种无损的、点阵的、支持多种色深和透明度的图片格式，可以保持图片的无损压缩和透明效果，适合用于保存色彩简单和线条清晰的图片，例如图标或文字。PNG又分为PNG-8和PNG-24两种，其中PNG-8只支持256种颜色和单一透明色，而PNG-24支持真彩色和alpha通道的半透明。    
`JPEG`：是一种有损的、点阵的、支持多种压缩率和色彩度的图片格式，可以在有损压缩的情况下，尽可能地减小图片的体积，同时保持较好的显示效果，适合用于保存彩色的、色彩丰富和渐变平滑的图片，例如照片或写实画。    
`GIF`：是一种无损的、点阵的、支持256种颜色和单一透明色的图片格式，可以支持动画效果和无损压缩，适合用于保存色彩简单和线条清晰的动态图片或表情包。    
`ICO`：是Windows的图标文件格式，它可以存储多个不同尺寸和色深的位图，用于显示文件和文件夹的图标。ico文件通常只能在Windows系统中使用。    
`ICNS`：是macOS的图标文件格式，它也可以存储多个不同尺寸和色深的位图，用于显示应用程序和其他类型的图标。icns文件通常只能在macOS系统中使用。    
`BMP`：是Windows操作系统中的标准图像文件格式，是一种无损的、点阵的、支持多种颜色模式和位深度的图片格式，可以保持图片的高质量和真实性，但同时也导致了它占用很大的存储空间。    
`WebP`：是谷歌开发的一种新图片格式，是一种同时支持有损和无损压缩、直接色、点阵图、动画和透明度等特性的图片格式，可以在相同质量的情况下，具有更小的体积，适合用于在Web上展示或传输 。不过WebP格式目前还不被所有浏览器或设备所支持。    

>**图像处理软件**     
GIMP+Darktable+Krita (ps+lightroom+sai)