<?php
    define("DATABASE", "poschat");

    // your database's password
    define("PASSWORD", "kings");

    // your database's server
    define("SERVER", "localhost");

    // your database's username
    define("USERNAME", "root");

    function query(/* $sql [, ... ] */)
    {
        // SQL statement
        $sql = func_get_arg(0);

        // parameters, if any
        $parameters = array_slice(func_get_args(), 1);

        // try to connect to database
        static $handle;
        if (!isset($handle))
        {
            try
            {
                // connect to database
                $handle = new PDO("mysql:dbname=" . DATABASE . ";host=" . SERVER, USERNAME, PASSWORD);

                // ensure that PDO::prepare returns false when passed invalid SQL
                $handle->setAttribute(PDO::ATTR_EMULATE_PREPARES, false); 
            }
            catch (Exception $e)
            {
                // trigger (big, orange) error
                trigger_error($e->getMessage(), E_USER_ERROR);
                exit;
            }
        }

        // prepare SQL statement
        $statement = $handle->prepare($sql);
        if ($statement === false)
        {
            // trigger (big, orange) error
            trigger_error($handle->errorInfo()[2], E_USER_ERROR);
            exit;
        }

        // execute SQL statement
        $results = $statement->execute($parameters);

        // return result set's rows, if any
        if ($results !== false)
        {
            return $statement->fetchAll(PDO::FETCH_ASSOC);
        }
        else
        {
            return false;
        }
    }
    function sendNotification($message, $deviceToken)
    {
	$passphrase = '';
	$ctx = stream_context_create();
	stream_context_set_option($ctx, 'ssl', 'local_cert', 'pushcert.pem');
	stream_context_set_option($ctx, 'ssl', 'passphrase', $passphrase);

	// Open a connection to the APNS server
	$fp = stream_socket_client('ssl://gateway.sandbox.push.apple.com:2195', $err,
		$errstr, 60, STREAM_CLIENT_CONNECT|STREAM_CLIENT_PERSISTENT, $ctx);

	if (!$fp)
		return false;

	// Create the payload body
	$body['aps'] = array('alert' => $message,'sound' => 'default');

	// Build the binary notification
	$msg = chr(0) . pack('n', 32) . pack('H*', $deviceToken) . pack('n', strlen($payload)) . json_encode($body);

	// Send it to the server
	$result = fwrite($fp, $msg, strlen($msg));

	// Close the connection to the server
	fclose($fp);

	// Return
	if (!$result)
	    return false;
	else
	   return true;
}	 
?>
