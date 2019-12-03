function buildPath{
	Param ($Path,
	$PathName, 
	$Name
	)
	If  (-NOT (Test-Path $PathName)){
		Write-Host "creating ${name} folder"
		Write-Host $Path
		Write-Host $PathName
		Write-Host $Name
		New-Item -Path $Path -Name $name -ItemType "directory"
	}
	Else{
		Write-Host "${Name} folder exists"
	}
}

$Credentials = Get-Credential
$user =  $Credentials.Username
$pass =  $Credentials.GetNetworkCredential().Password
$pair = "${user}:${pass}"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$base64 = [System.Convert]::ToBase64String($bytes)
$basicAuthValue = "Basic $base64"
$headers = @{ Authorization = $basicAuthValue }
$repeat = "Y"

while ($repeat -eq "Y"){
	$ModuleCode = Read-Host -Prompt "Input module code"
	buildPath -Path . -PathName .\revision -Name "revision"
	buildPath -Path .\revision -PathName .\revision\$ModuleCode -Name $ModuleCode
	buildPath -Path .\revision\$ModuleCode -PathName .\revision\$ModuleCode\past-papers -Name "past-papers"
	for($j=1 ; $j -le 2; $j++){
		for($i=15 ; $i -le 18; $i++){
			$PaperName = $ModuleCode +"-"+ $i +".pdf"
			$PaperPath = ".\revision\${ModuleCode}\past-papers\${ModuleCode}-${j}-${i}.pdf"
			Invoke-WebRequest -uri "https://www.aber.ac.uk/en/media/departmental/examinations/pastpapers/pdf/compsci/sem${j}-${i}/${ModuleCode}-${i}.pdf" -Headers $headers -OutFile $PaperPath
			if ((Get-Item($PaperPath)).length -eq 0){
				Remove-Item $PaperPath
			}
		}
	}
	$repeat = Read-Host -Prompt "Enter Y to enter another module"
}