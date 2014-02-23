<?php
	require('db_connect.php');
	header('Content-Type: text/html; charset=UTF-8');
	$query = "SELECT source_id,UNIX_TIMESTAMP(start),length FROM location L WHERE target_id = " . $_GET['target'];
        $result = $mysqli->query($query);
	while($r = $result->fetch_row()) {
		$rows[] = $r;
	}        
	print json_encode($rows,JSON_FORCE_OBJECT);
?>
