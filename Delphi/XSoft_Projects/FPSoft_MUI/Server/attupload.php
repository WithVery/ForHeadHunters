<?php
$uploaddir = './atts';

$oid = $_POST['oid'];
$aid = $_POST['aid'];

print "Filename:".$_FILES['filename']['tmp_name']."\r\n";
print "Path:".$uploaddir."/".$oid."_".$aid."\r\n";

if (move_uploaded_file($_FILES['filename']['tmp_name'], $uploaddir."/".$oid."_".$aid)) {
	print $_FILES['filename']['tmp_name']."\r\n";
	print $uploaddir."/".$fid	."\r\n";	
	print "Succeeded.";
} 
else {
	print "Failed.";
}
?>