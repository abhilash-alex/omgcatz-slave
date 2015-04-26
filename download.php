<?php

header("Access-Control-Allow-Origin: *");

foreach ($_POST as $key => $value) {
  if (empty($value)) {
    unset($_POST[$key]);
  } else {
    $_POST[$key] = escapeshellarg(str_replace(array("`",chr(96)),array("'","'"),html_entity_decode(trim($value)))).PHP_EOL;
  }
}

echo shell_exec("./download.sh " . json_encode($_POST, JSON_UNESCAPED_SLASHES));
