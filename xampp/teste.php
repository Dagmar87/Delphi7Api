<?php

$url =
'http://localhost:8080/api/produtos';

$resposta =
file_get_contents($url);

echo $resposta;