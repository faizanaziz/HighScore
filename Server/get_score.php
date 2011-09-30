<?php
    // get_scores.php
	/** MySQL database name */
	define('DB_NAME', 'TEMP');
	/** MySQL database username */
	define('DB_USER', 'tempdb');
	/** MySQL database password */
	define('DB_PASSWORD', 'testdbfunc');
	/** MySQL hostname */
	define('DB_HOST', 'localhost');
	
	$table = "highscores_gamename";
 
	// Initialization
	$conn = mysql_connect(DB_HOST,DB_USER,DB_PASSWORD);
	mysql_select_db(DB_NAME, $conn);
 
	// Error checking
	if(!$conn) {
		die('Could not connect ' . mysql_error());
	}
 
	$offset = isset($_GET['offset']) ? $_GET['offset'] : "0";
	$count  = isset($_GET['count']) ? $_GET['count'] : "20";
	$sort   = isset($_GET['sort']) ? $_GET['sort'] : "score DESC";
 
	// Protect against sql injections
	$offset = mysql_real_escape_string($offset);
	$count  = mysql_real_escape_string($count);
	$sort   = mysql_real_escape_string($sort);
 
	// Build the sql query
	$sql = "SELECT * FROM $table ";
	$sql .= "ORDER BY score DESC ";
	$sql .= "LIMIT $offset,$count ";
 
	$result = mysql_query($sql,$conn);
	if(!$result) {
		die("Error retrieving scores " . mysql_error());
	}

	$rank=0;
	// Display the table	
	echo '<highscores>';
    while ($row = mysql_fetch_object($result)) {
    	$rank=$rank+1;
		echo 
		'<highscore>
			<rank>'.$rank.'</rank>
			<name>'.$row->name.'</name>
			<score>'.$row->score.'</score>
		</highscore>';
	}
	echo '</highscores>';
	mysql_free_result($result);
	mysql_close($conn);
?>