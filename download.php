<?php

foreach ($_POST as $key => $value) {
  $_POST[$key] = escapeshellarg(html_entity_decode(trim($value))).PHP_EOL;
}

echo shell_exec("./download.sh " . json_encode($_POST, JSON_UNESCAPED_SLASHES));
