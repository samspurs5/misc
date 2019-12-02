
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
	If  (-NOT (Test-Path .\revision)){
		Write-Host "creating revision folder"
		New-Item -Path . -Name "revision" -ItemType "directory"
	}
	Else{
		Write-Host "revision folder exists"
	}

	If  (-NOT (Test-Path .\revision\$ModuleCode)){
		Write-Host "creating module:"$ModuleCode" folder"
		New-Item -Path ".\revision" -Name "$ModuleCode" -ItemType "directory"
	}
	Else{
		Write-Host "module:"$ModuleCode" folder exists"
	}

	If  (-NOT (Test-Path .\revision\$ModuleCode\past-papers)){
		Write-Host "creating past-papers folder"
		New-Item -Path .\revision\$ModuleCode -Name "past-papers" -ItemType "directory"
	}
	Else{
		Write-Host  "past-papers folder exists"
	}
	for($j=1 ; $j -le 2; $j++){
		for($i=15 ; $i -le 18; $i++){

			$PaperName = $ModuleCode +"-"+ $i +".pdf"
			$PaperPath = ".\revision\${ModuleCode}\past-papers\${j}${PaperName}"
			Invoke-WebRequest -uri "https://www.aber.ac.uk/en/media/departmental/examinations/pastpapers/pdf/compsci/sem${j}-${i}/${ModuleCode}-${i}.pdf" -Headers $headers -OutFile $PaperPath
			if ((Get-Item($PaperPath)).length -eq 0){
				Remove-Item $PaperPath
			}
		}
	}
	$repeat = Read-Host -Prompt "Enter Y to enter another module"
}