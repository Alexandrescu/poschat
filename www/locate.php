<?php
	require('db_connect.php');
        $query = "SELECT lat,lon,comment FROM location L WHERE id= '".$_GET['id']."'";
        $result = $mysqli->query($query);
	while($r = $result->fetch_row()) {
		$rows[] = $r;
	}        
	print json_encode($rows[0]);
?>
