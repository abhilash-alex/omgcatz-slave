<?php

$filePath = $_GET["p"];
$fileName = $_GET["s"];

$ext = pathinfo($filePath, PATHINFO_EXTENSION);

switch ($ext) {
  case "mp3":
  case "m4a":
  case "zip":
    header("Access-Control-Allow-Origin: *");
    header("Content-Length: ".filesize($filePath));
    header("Content-Type: application/octet-stream");
    header('Content-Disposition: attachment; filename="'.$fileName.'"');
    readfile($filePath);
}
