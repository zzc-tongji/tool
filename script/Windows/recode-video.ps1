$ErrorActionPreference = "Stop"
#
param (
  [Parameter(Mandatory = $true, Position = 1, HelpMessage = "input file path")]
  [string]$i,
  [Parameter(Position = 2, HelpMessage = "accelerator (support: cuda)")]
  [string]$acc = "cuda"
)
#
$data = (ffprobe.exe -v quiet -print_format json -show_format -show_streams "$i" | ConvertFrom-JSON)
$output_file = ($i + ".recode." + $data.format.filename.Split(".")[-1])
$video_stream = $data.streams[0]
$audio_stream = $data.streams[1]
#
$decoder = $video_stream.codec_name
$encoder = $video_stream.codec_name
#
if ($acc -eq "cuda") {
  switch ($video_stream.codec_name) {
    "av1" { $decoder = ($video_stream.codec_name + "_cuvid"); $encoder = ($video_stream.codec_name + "_nvenc") }
    "h264" { $decoder = ($video_stream.codec_name + "_cuvid"); $encoder = ($video_stream.codec_name + "_nvenc") }
    "hevc" { $decoder = ($video_stream.codec_name + "_cuvid"); $encoder = ($video_stream.codec_name + "_nvenc") }
    "mjpeg" { $decoder = ($video_stream.codec_name + "_cuvid") }
    "mpeg1" { $decoder = ($video_stream.codec_name + "_cuvid") }
    "mpeg2" { $decoder = ($video_stream.codec_name + "_cuvid") }
    "mpeg4" { $decoder = ($video_stream.codec_name + "_cuvid") }
    "vc1" { $decoder = ($video_stream.codec_name + "_cuvid") }
    "vp8" { $decoder = ($video_stream.codec_name + "_cuvid") }
    "vp9" { $decoder = ($video_stream.codec_name + "_cuvid") }
  }
}
else {
  $acc = ""
}
if ($acc) {
  ffmpeg.exe -hwaccel $acc -c:v $decoder -i "$i" -c:a $audio_stream.codec_name -b:a $audio_stream.bit_rate -ar $audio_stream.sample_rate -ac $audio_stream.channels -channel_layout $audio_stream.channel_layout -c:v $encoder -b:v $video_stream.bit_rate -level $video_stream.level -r $video_stream.avg_frame_rate "$output_file"
}
else {
  ffmpeg.exe -c:v $video_stream.codec_name -i "$i" -c:a $audio_stream.codec_name -b:a $audio_stream.bit_rate -ar $audio_stream.sample_rate -ac $audio_stream.channels -channel_layout $audio_stream.channel_layout -c:v $video_stream.codec_name -b:v $video_stream.bit_rate -level $video_stream.level -r $video_stream.avg_frame_rate "$output_file"
}
