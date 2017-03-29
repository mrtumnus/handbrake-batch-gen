# HandbrakeBatchScript
Generate a script for transcoding multiple videos with Handbrake

The $SRC path is used to find .mkv files to transcode. The script generates another script for actually running the transcode. This is done to allow tweaking the parameters of each transcode.

The default transcode options are as follows:
- x264 encoder, Profile high, level 4.1, quality 20
- Two audio tracks, first is pass-thru digital, second is AAC 160kbps

Folder structure for $SRC should be:
- $SRC
  - movie1
    - movie1.mkv
    - extra1.mkv
  - tvshow1
    - s01e01.mkv
    - s01e02.mkv
    - s00e03.mkv
    
With this example, $DEST will end up as:
- $DEST
  - movie1
    - movie1.mkv (transcoded)
    - extra1.mkv (transcoded)
    - original
      - movie1.mkv
      - extra1.mkv
  - tvshow1
    - s01e01.mkv
    - s01e02.mkv
    - s00e03.mkv
    - original
      - s01e01.mkv
      - s01e02.mkv
      - s00e03.mkv
      
Empty $SRC folders are deleted afterwards.
