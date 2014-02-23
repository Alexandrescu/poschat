<?php
include 'db_connect.php';
if($stmt = $mysqli->prepare("INSERT INTO location(source_id, target_id, lat, lon, length) values(?, ?, ?, ?, ?)")) 
{
    $stmt->bind_param('iiddi', $_GET['source'], $_GET['target'], $_GET['lat'], $_GET['lon'], $_GET['expiry']);
    if ($stmt->execute())
    {
      echo "1";
      // push notifications
    } 
    else
    {
      echo "0";
       echo $stmt->error;
    }
}
	
?>
