<?php
define('BOOTSTRAP', true);
define('AREA', 'C');

require __DIR__ . '/../../../../vendor/autoload.php';
require __DIR__ . '/../../../../init.php';

// Load our service class so tests can see it:
require __DIR__ . '/../src/SignatureValidator.php';
