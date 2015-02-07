<?php

$_POST = array(
  "mix_slug" => "bassfrogtcubrobrobro",
  "download_id" => "ffffssss"
);

foreach ($_POST as $key => $value) {
  $_POST[$key] = escapeshellarg(preg_replace("~/~", "", $value));
}

$path = "archives/" . $_POST["mix_slug"] . "/" . $_POST["download_id"];
$fileName = $_POST["mix_slug"] . ".zip";
shell_exec("cd $path && ../../../find . \! -name *.zip -exec ../../../zip -0 -D -r $fileName * \; -delete");
