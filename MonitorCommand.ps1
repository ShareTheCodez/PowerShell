# ####################################################################
# PowerShell
# 6 Feb 2012
# Smith, Jason Alan
# Monitoring Shell
# ####################################################################
param (	[string]$MonitorCommand = (Read-Host "Command To Monitor"),
		$RefreshSeconds = (Read-Host "Refresh (Seconds)"),
		$StopMonitoringHours = (Read-Host "Hours To Stop Monitoring")
		)

function DisplayMonitorHeaderInfo
	{
		$HeaderBorderChar = "="
		$HeaderBorder = $HeaderBorderChar * 139		#PowerShell Console Size: 140 Wide x 35 High
		
		Write-Host $HeaderBorder -ForegroundColor Yellow
		Write-Host "Command Execution Monitoring System" -ForegroundColor Yellow
		Write-Host "Monitoring Started: " $MonitoringStart "`tMonitoring Will Stop: " $StopDateTime "`tIt Is Now: " $Today -ForegroundColor Yellow
		Write-Host "Monitoring Command: " $MonitorCommand -ForegroundColor Yellow
		Write-Host "Refresh Interval (Seconds): " $RefreshSeconds -ForegroundColor Yellow
		Write-Host $HeaderBorder -ForegroundColor Yellow
	}
		
if ($MonitorCommand -eq "")
	{Write-Host "No Command Indicated."}
if ($RefreshSeconds -eq "")
	{$RefreshSeconds = 10}
if ($StopMonitoringHours -eq "")
	{$StopMonitoringHours = 1}
else
	{
		# Indicated Command Exists,
		# Start Monitoring the Command
		
		$Today = Get-Date
		$MonitoringStart = $Today
		$StopDateTime = $Today.AddHours($StopMonitoringHours)
		
		$Max_Page_Rows = 10
		
		#Clear-Host
		#DisplayMonitorHeaderInfo
		
		while ($true)
		{
			# Endless Loop Will Execute Command to Monitor, Sleep,
			# and Repeat; User Must CONTROL+C to Stop Monitoring and/or
			# Specify Date/Time to Stop Monitoring
			
			Clear-Host
			DisplayMonitorHeaderInfo
			
			Invoke-Expression $MonitorCommand > "D:\Monitor_Command.txt"
			
			$Monitor_Display = Get-Content "D:\Monitor_Command.txt"

			
			
			if ($Monitor_Display.Length -gt $Max_Page_Rows)
			{
				$Page_Count = [System.Math]::Ceiling($Monitor_Display.Length / $Max_Page_Rows)

				
				$Current_Range_Start = 0
				$Current_Range_End = 9
				
				for ($c = 1; $c -le $Page_Count; $c++)
				{
					Write-Host "Page $c of $Page_Count"
					$Current_Display_Set = $Monitor_Display[$Current_Range_Start..$Current_Range_End]
					$Current_Display_Set
					
					$Current_Range_Start += 10
					$Current_Range_End += 10
				
				$Current_Page++
				Sleep 5
 						Clear-Host
 						DisplayMonitorHeaderInfo
						

 						
				}
			}
			else
			{
				$Monitor_Display
			}
			Start-Sleep $RefreshSeconds
			
			$Today = Get-Date
			if ($Today -gt $StopDateTime)
				{break}
		}
	}