<?php

$_POST = array(
  "song_id" => "324523423",
  "tag_song_title" => 1,
  "song_title" => "test",
  "song_artist" => "Song Artist",
  "song_album" => "Song $))Album",
  "song_artwork" => "http://www.online-image-editor.com/styles/2014/images/example_image.png",
  "song_genre" => "electronic",
  "song_url" => "http://cft.8tracks.com/tf/085/313/618/O2GbFU.48k.v3.m4a",
  "song_number" => 6,
  "total_songs" => 16,
  //"mix_artwork" => "http://upload.wikimedia.org/wikipedia/commons/b/bf/GOES-13_First_Image_jun_22_2006_1730Z.jpg",
  "mix_slug" => "bassfrogtcubrobrobro",
  "recursive" => 1,
  //"itunes_compilation" => 1,
  "img_ext" => "png",
  "download_id" => "ffffssss"
);

foreach ($_POST as $key => $value) {
  $_POST[$key] = escapeshellarg(html_entity_decode(trim($value))).PHP_EOL;
}

echo shell_exec("./download.sh " . json_encode($_POST, JSON_UNESCAPED_SLASHES));
