<?php

$filePath = $_GET["p"];
$fileName = $_GET["s"];

$ext = pathinfo($filePath, PATHINFO_EXTENSION);

switch ($ext) {
  case "mp3":
  case "m4a":
  case "zip":
    header("Access-Control-Allow-Origin: *");
    header("Content-Type: application/octet-stream");
    header('Expires: 0');
    header("Content-Length: ".filesize($filePath));
    header('Content-Disposition: attachment; filename="'.$fileName.'"');
    
    // http://stackoverflow.com/questions/22934420/apache-php-large-file-download-2gb-failing

    @ob_end_flush();
    flush();

    $fileDescriptor = fopen($filePath, 'rb');

    while ($chunk = fread($fileDescriptor, 8192)) {
      echo $chunk;
      @ob_end_flush();
      flush();
    }

    fclose($fileDescriptor);
}
