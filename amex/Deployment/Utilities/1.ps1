param 
(
[string]$name = $(throw "Please specify the database server using the -ServerName switch.")
)

$newText = $name
$newText > 'wynik.ini'
