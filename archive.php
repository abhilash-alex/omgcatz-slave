<?php

foreach ($_POST as $key => $value) {
  $_POST[$key] = escapeshellarg(preg_replace("~/~", "", $value));
}

$path = "archives/" . $_POST["slug"] . "/" . $_POST["download_id"];
$fileName = $_POST["slug"] . ".zip";
shell_exec("cd $path && ../../../find . \! -name *.zip -exec ../../../zip -0 -D -r $fileName * \; -delete");
