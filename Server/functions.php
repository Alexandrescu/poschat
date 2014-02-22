<?php

include 'db_connect.php';
include 'functions.php';


function add_query($source, $target, $lon, $lat, $expiry) {

	if($stmt = $mysqli->prepare("INSERT INTO location(source_id, target_id, lat, lon, length) values(?, ?, ?, ?, ?)")) {
		$stmt->bind_param('iiddi', $source, $target, $lat, $lon, $expiry);
		if ($stmt->execute()){
			
		}
		else { 
			echo $stmt->error;
		}
	}
	
}

add_query($_POST['type'], $title, $text, $mysqli);
	
function get_query($_userId) {
	$query = "SELECT FROM locations L WHERE user_id_source = ?"
	$result = $mysqli->query($query)
	echo json_encode($result)
}
	
?>