#!/bin/bash


function get_file_type() {
  file_output="$(file "$1")"

  if [ -n "$(echo "$file_output" | grep -i -E "(MPEG ADTS|Audio file with ID3)")" ]; then
    echo "mp3"
  elif [ -n "$(echo "$file_output" | grep -i "MPEG v4")" ]; then
    echo "m4a"
  elif [ -n "$(echo "$file_output" | grep -i "WAVE audio")" ]; then
    echo "wav"
  elif [ -n "$(echo "$file_output" | grep -i "Adaptive Multi-Rate")" ]; then
    echo "amr"
  elif [ -n "$(echo "$file_output" | grep -i "Microsoft ASF")" ]; then
    echo "wma"
  elif [ -n "$(echo "$file_output" | grep -i "AIFF")" ]; then
    echo "aif"
  elif [ -n "$(echo "$file_output" | grep -i "AIFF-C")" ]; then
    echo "aifc"
  elif [ -n "$(echo "$file_output" | grep -i "FLAC")" ]; then
    echo "flac"
  elif [ -n "$(echo "$file_output" | grep -i "Ogg")" ]; then
    echo "ogg"
  elif [ -n "$(echo "$file_output" | grep -i "layer II,")" ]; then
    echo "mp2"
  fi
}

function download_artwork() {
  [ ! -f "$artwork_save" ] && curl -Lso "$artwork_save" "$artwork_url"
}


while read -r line; do
  key="$(echo "$line" | grep -o "[^\:]*")"
  value="$(echo "$line" | grep -o "'.*'")"
  eval $key="$value"
done <<< "$(echo -en "$@")"

ARCHIVES="archives"
SONGS="songs"
ARTWORK="artwork"

if [ -n "$mix_artwork" ]; then
  artwork_url="$mix_artwork"
  artwork_save="$ARTWORK/$mix_slug.$img_ext"
elif [ -n "$song_artwork" ]; then
  artwork_url="$song_artwork"
  artwork_save="$ARTWORK/$song_id.$img_ext"
fi

if [ -n "$song_number" ]; then
  song_number_fancy="$(printf "%02d" "$song_number"). "
fi

song_name_clean="$(echo "$song_title" | iconv -f utf-8 -t ASCII -c)"
song_save_client="$song_number_fancy$song_name_clean"
song_save_server="$SONGS/$song_id"
zip_dir="$ARCHIVES/$mix_slug/$download_id"
zip_save="$mix_slug.zip"

if [ -f "$song_save_server.m4a" ]; then
	song_ext="m4a"
elif [ -f "$song_save_server.mp3" ]; then
	song_ext="mp3"
else
	curl -Lso "$song_save_server.part" "$song_url"
  song_ext="$(get_file_type "$song_save_server.part")"
	mv "$song_save_server.part" "$song_save_server.$song_ext"
fi

song_save_server="$song_save_server.$song_ext"
song_save_client="$song_save_client.$song_ext"
touch "$song_save_server"

if [ "$song_ext" == "mp3" ]; then
	./eyeD3 --remove-all-objects -t "$song_title" -a "$song_artist" -A "$song_album" -n "$song_number" -N "$total_songs" "$song_save_server" &> /dev/null

	if [ -n "$artwork_save" ]; then
		download_artwork
		./eyeD3 --add-image="$artwork_save":FRONT_COVER "$song_save_server" &> /dev/null
	fi
elif [ "$song_ext" == "m4a" ]; then
	[ -n "$total_songs" ] && slash_total_songs="/$total_songs"

	./AtomicParsley "$song_save_server" -o "$song_save_server.temp" --title "$song_title" --artist "$song_artist" --album "$song_album" --tracknum "$song_number$slash_total_songs" --artwork "REMOVE_ALL" &> /dev/null

	if [ -n "$artwork_save" ]; then
		download_artwork
		./AtomicParsley "$song_save_server.temp" -o "$song_save_server" --artwork "$artwork_save" &> /dev/null
		rm -f "$song_save_server.temp"
	else
		mv "$song_save_server.temp" "$song_save_server"
	fi
fi

if [ -n "$recursive" ]; then
	mkdir -p "$zip_dir"
	cp "$song_save_server" "$zip_dir/$song_save_client"
	echo -n "{\"path\": \"$zip_dir/$zip_save\", \"save\": \"$mix_slug.zip\"}"
else
	echo -n "{\"path\": \"$song_save_server\", \"save\": \"$song_save_client\"}"
fi
