<?php
return [
	'fetch' => PDO::FETCH_CLASS,
	'default' => env('DB_CONNECTION', 'dev'),
	'connections' => [
		'prod' => [
			'driver'	  => 'mysql',
			'host'	    => env('DB_HOST', 'localhost'),
			'database'  => env('DB_DATABASE', 'sandbox'),
			'username'  => env('DB_USERNAME', 'sandbox'),
			'password'  => env('DB_PASSWORD', 'pass'),
			'charset'   => 'utf8',
			'collation' => 'utf8_unicode_ci',
			'prefix'	  => '',
			'strict'	  => false,
		],
		'dev' => [
			'driver'	  => 'mysql',
			'host'	    => env('DB_HOST', 'localhost'),
			'database'  => env('DB_DATABASE', 'sandbox'),
			'username'  => env('DB_USERNAME', 'sandbox'),
			'password'  => env('DB_PASSWORD', 'pass'),
			'charset'   => 'utf8',
			'collation' => 'utf8_unicode_ci',
			'prefix'	=> '',
			'strict'	=> false,
		],
	]
];
