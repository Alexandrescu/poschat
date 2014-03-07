<?php
	require('functions.php');
	header('Content-Type: text/html; charset=UTF-8');
	$result = query("SELECT source_id,UNIX_TIMESTAMP(start),length,comment,id FROM location WHERE target_id = ? GROUP BY start DESC",$_GET['target']);
	foreach ($result as $r)
		$rows[] = Array("id"=>$r['id'],"source"=>$r['source_id'],"start"=>$r['UNIX_TIMESTAMP(start)'],"length"=>$r['length'],"comment"=>$r['comment']);
	print json_encode($rows);
?>
