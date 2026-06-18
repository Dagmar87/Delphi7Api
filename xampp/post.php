<?php

$dados = [
 "id" => 5,
 "nome" => "Monitor",
 "preco" => 1200
];

$options = [
 'http' => [
   'method' => 'POST',
   'header' => 'Content-Type: application/json',
   'content' => json_encode($dados)
 ]
];

$context =
 stream_context_create($options);

echo file_get_contents(
 'http://localhost:8080/api/produtos',
 false,
 $context
);