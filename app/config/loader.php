<?php

use Phalcon\Loader;

$loader = new Loader();

$loader->registerNamespaces([
    'CrearyDB\Models'      => $config->application->modelsDir,
    'CrearyDB\Controllers' => $config->application->controllersDir,
    'CrearyDB\Helpers'     => $config->application->helpersDir,
    'CrearyDB'             => $config->application->libraryDir
]);

$loader->registerDirs(array(
    '../app/helpers'
));

$loader->register();

// Use composer autoloader to load vendor classes
require_once BASE_PATH . '/vendor/autoload.php';
