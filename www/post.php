<?php
    include 'functions.php';
    $result = query("INSERT INTO location(source_id,target_id,lat,lon,length,comment) values(?,?,?,?,?,?)",
                       $_GET['source'], $_GET['target'], $_GET['lat'], $_GET['lon'], $_GET['expiry'],$_GET['comment']); 
    if ($result == [])
    {
      echo "{\"success\":true}";
      $comment = $_GET['comment'];
      $result = query("SELECT token FROM push WHERE id=?",$_GET['target']);
      if (isSet($result[0]['token']))
      {
	$message = (strlen($comment)>256-37)?substr($comment,0,216).'...':$comment;
	sendNotification($message,$result[0]['token']);
      }
    } 
    else
      echo "{\"success\":false}";
?>
