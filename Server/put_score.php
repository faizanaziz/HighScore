<?php
	// put_score.php
	/** MySQL database name */
	define('DB_NAME', 'TEMP');
	/** MySQL database username */
	define('DB_USER', 'tempdb');
	/** MySQL database password */
	define('DB_PASSWORD', 'testdbfunc');
	/** MySQL hostname */
	define('DB_HOST', 'localhost');
	
	define('MAXENTRIES', '100');
	$table = "highscores_gamename";
 
	// Initialization
	$conn = mysql_connect(DB_HOST,DB_USER,DB_PASSWORD);
	mysql_select_db(DB_NAME, $conn);
 
	// Error checking
	if(!$conn) {
		die('Could not connect ' . mysql_error());
	}
	if($_GET['secret'] != "dbsecret") {
		die('Nothing to see here...');
	}
 
	// Localize the GET variables
	$name   = isset($_GET['name']) ? $_GET['name']  : "";
	$score  = isset($_GET['score']) ? $_GET['score'] : "0";
 
	// Protect against sql injections
	$name  = mysql_real_escape_string($name);
	$score = mysql_real_escape_string($score);
 
	
	// Insert the score
	$retval = mysql_query("INSERT INTO 	$table ( name  , score  )
	 									VALUES ('$name','$score')", $conn);
	$countarray = mysql_query("SELECT * FROM $table");
	$count = mysql_num_rows($countarray);
	
	if($count>MAXENTRIES)
	{
		$minarray = mysql_query("SELECT MIN(score) FROM $table");
		$min = mysql_fetch_array($minarray);
		$minscore=$min['MIN(score)'];
		$deleteminscore=mysql_query("DELETE FROM $table WHERE score='$minscore'");
	}
 
	if($retval) {
		echo "Inserted score $score for $name";
	} else {
		echo "Unable to insert score " . mysql_error();
	}
 
	mysql_close($conn);
?>