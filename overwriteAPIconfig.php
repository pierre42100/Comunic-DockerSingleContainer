<?php

//Custom database configuration
$config->set("mysql", array(
    "host" => "localhost",
    "database" => "comunic",
    "user" => "comunic",
    "password" => "comunic"
));

//Storage configuration
$config->set("storage_path", "/data/user_data/");
$config->set("storage_url", "http://".$_SERVER["HTTP_HOST"]."/user_data/");