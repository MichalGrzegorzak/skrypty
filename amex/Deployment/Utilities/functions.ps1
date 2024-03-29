$config = "config.ini"

#	declare global variable
# $script:thisIsAvailableInFunctions = "foo"

function Get-IniContent ($filePath)
{
    $ini = @{}
    switch -regex -file $filePath
    {
        "(.+?)\s*=(.*)" # Key
        {
            $name,$value = $matches[1..2]
            $ini[$name] = $value
        }
    }
    return $ini
}

function Replace-Value-Config ($fileName, $iniKey, $newValue)
{
	$cc = Get-IniContent $fileName
	$oldLine = $iniKey + "=" + $cc[$iniKey]
	$newLine = $iniKey + "=" + $newValue

	$newText =(gc $fileName).Replace($oldLine, $newLine)
	$newText > $fileName
}