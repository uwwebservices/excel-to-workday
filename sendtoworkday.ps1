$settings = $PSScriptRoot + "\settings.txt"

Get-Content $settings | foreach-object -begin {$h=@{}} -process { $k = [regex]::split($_,'='); if(($k[0].CompareTo("") -ne 0) -and ($k[0].StartsWith("[") -ne $True)) { $h.Add($k[0], $k[1]) } }

$server = $h["Server"]
$sftpUser = $h["User"]
$sshHostKeyFingerprint = $h["HostKeyFingerprint"]
$sshPrivateKeyPath = $h["KeyPath"]

try
{
    Add-Type -Path $h["WinSCPnet"]  

    $sessionOptions = New-Object WinSCP.SessionOptions
    $sessionOptions.Protocol = [WinSCP.Protocol]::Sftp
    $sessionOptions.HostName = $server
    $sessionOptions.UserName = $sftpUser 
    $sessionOptions.Password = ""
    $sessionOptions.SshPrivateKeyPath = $sshPrivateKeyPath
    $sessionOptions.SshHostKeyFingerprint = $sshHostKeyFingerprint
    
    $session = New-Object WinSCP.Session
    
    try
    {
        $session.Open($sessionOptions)
        $sessionOptions = $null

        $transferOptions = New-Object WinSCP.TransferOptions
        $transferOptions.TransferMode = [WinSCP.TransferMode]::Binary
	$transferOptions.PreserveTimestamp = $False

        $transferResult = $session.PutFiles("D:\inbound\workdaysubmission.zip", "/wd-inbound-sftp/dev/workdaysubmission.zip", $False, $transferOptions)
        
        foreach ($transfer in $transferResult.Transfers){Write-Host "Upload of $($transfer.FileName) succeeded"}
 
        $transferResult.Check()
    }
    
    finally{$session.Dispose()}
    exit 0
}
catch
{
    Write-Error $_.Exception.Message
    exit 1
}
