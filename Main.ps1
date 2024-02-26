# Initialize an empty array to store the results
$compiledResults = @()

# Prompt the user to enter host names or IP addresses until they are done
do {
    # Prompt the user to enter the host name or IP address
    $input = Read-Host "Enter the host name or IP address (or type 'done' to finish)"

    # Check if the user wants to finish entering host names
    if ($input -ne "done") {
        # Determine if the input is an IP address
        $ipAddress = $null
        if ([System.Net.IPAddress]::TryParse($input, [ref]$ipAddress)) {
            # Check if the host is reachable within 1 second
            if (Test-Connection -ComputerName $input -Count 1 -Quiet) {
                # Construct the folder path
                $folderPath = "\\$input\c`(path)"

                # Check if the folder exists on the remote host
                if (Test-Path -Path $folderPath) {
                    $result = "$input - Yes"
                } else {
                    $result = "$input - No"
                }

                # Perform nslookup to get the hostname from the IP address
                try {
                    $hostEntry = [System.Net.Dns]::GetHostEntry($input)
                    $hostName = $hostEntry.HostName
                    $result += " - $hostName"
                } catch {
                    $result += " - nslookup failed"
                }

                # Add the result to the compiled results array
                $compiledResults += $result
            } else {
                $result = "$input - Not Pinging"
                $compiledResults += $result
            }
        } else {
            # If the input is a hostname, proceed with the existing logic
            # Check if the host is reachable within 1 second
            if (Test-Connection -ComputerName $input -Count 1 -Quiet) {
                # Construct the folder path
                $folderPath = "\\$input\c`$\Program Files (x86)\Foresight"

                # Check if the folder exists on the remote host
                if (Test-Path -Path $folderPath) {
                    $result = "$input - Yes"
                } else {
                    $result = "$input - No"
                }

                # Add the result to the compiled results array
                $compiledResults += $result
            } else {
                $result = "$input - Not Pinging"
                $compiledResults += $result
            }
        }
    }
} until ($input -eq "done")

# Output the compiled results in list format
$compiledResults | Out-File -FilePath "C:\REFRESHES\compiled_results.txt"
