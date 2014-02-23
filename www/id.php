<?php
        require('db_connect.php');
	$count = $mysqli->query("SELECT COUNT(*) FROM users WHERE number = '".$_GET['number']."'");
	if($count->fetch_row()[0]==0)
	{
		$query = "INSERT INTO users (id,number) values(NULL,'".$_GET['number']."')";
		$mysqli -> query($query);
	}
	$result = $mysqli->query("SELECT id FROM users WHERE number = '".$_GET['number']."'");
	$r = $result->fetch_row();
	echo $r[0];
?>
