<?php
	$resp = "";
	if (!empty($_SERVER['HTTPS']) && ('on' == $_SERVER['HTTPS']) && !empty($_POST['oid']) && !empty($_POST['pn']) && !empty($_POST['cv'])) {
		$g_hostn = '127.0.0.1';
		$g_login = ''; 
		$g_pwd	 = '';
		$g_db_name = 'systems';
		$g_table = $_POST['pn'];
		$mysqli = mysqli_init();
		if (!$mysqli) {
			die('');
		}	
		if (!$mysqli->real_connect($g_hostn, $g_login, $g_pwd, $g_db_name, 0, '', MYSQLI_CLIENT_SSL)) { 
			die('');
		}

		list($v1, $v2, $v3, $v4) = split("\.", $_POST['cv'], 4);
		$v4i = intval($v4);
		$v4s = sprintf("%02d", $v4i);
		$v0 = $v1.'.'.$v2.'.'.$v3.'.'.$v4s;
		$qry = 'SELECT ver FROM '.$g_table.' WHERE uid="'.$_POST['oid'].'" AND ver>"'.$v0.'" LIMIT 1';

		if ($result = $mysqli->query($qry)) {
			while ($row = $result->fetch_row()) {
				$resp = $row[0];
			}
			$result->close();
		}
		$mysqli->close();		
	}
	echo "<html><header>$resp</header></html>";
?>

