<?php
	require('db_connect.php');
        $query = "SELECT lat,lon FROM location L WHERE source_id = " . $_GET['source'];
        $result = $mysqli->query($query);
	while($r = $result->fetch_row()) {
		$rows[] = $r;
	}        
	print json_encode($rows[0]);
?>
