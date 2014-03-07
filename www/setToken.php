<?php
	require('functions.php');
	$id = $_GET['number'];
	$token = $_GET['token'];
	query("INSERT INTO push(id,token) values(?,?)",$id,$token);
?> 
