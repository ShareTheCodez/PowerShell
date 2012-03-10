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

		$Terminal = (Get-Host).UI.RawUI
		$TerminalSize = $Terminal.WindowSize
		$TerminalWidth = $TerminalSize.Width
		$TerminalHeight = $TerminalSize.Height

		$Max_Page_Rows = $TerminalHeight - 9

function DisplayMonitorHeaderInfo
	{
		$HeaderBorderChar = "="
		

		
		$TerminalWidth = $TerminalWidth - 1
		$HeaderBorder = $HeaderBorderChar * $TerminalWidth		#Draw header border to fill window width - 1; -1 prevents blank line under header row
		
		Write-Host $HeaderBorder -ForegroundColor Yellow
		Write-Host "Command Execution Monitoring System" -ForegroundColor Yellow
		Write-Host "Monitoring Started: " $MonitoringStart "`tMonitoring Will Stop: " $StopDateTime "`tIt Is Now: " $Today -ForegroundColor Yellow
		Write-Host "Monitoring Command: " $MonitorCommand -ForegroundColor Yellow
		Write-Host "Refresh Interval (Seconds): " $RefreshSeconds -ForegroundColor Yellow
		Write-Host $HeaderBorder -ForegroundColor Yellow
	}
		
if ($MonitorCommand -eq $null)
	{Write-Host "No Command Indicated."}
if ($RefreshSeconds -eq $null)
	{$RefreshSeconds = 5}
if ($StopMonitoringHours -eq $null)
	{$StopMonitoringHours = 1}
else
	{
		# Indicated Command Exists,
		# Start Monitoring the Command
		
		$Today = Get-Date
		$MonitoringStart = $Today
		$StopDateTime = $Today.AddHours($StopMonitoringHours)
		
		
		
		Clear-Host
		DisplayMonitorHeaderInfo
		
		while ($true)
		{
			# Endless Loop Will Execute Command to Monitor, Sleep,
			# and Repeat; User Must CONTROL+C to Stop Monitoring and/or
			# Specify Date/Time to Stop Monitoring
			
			#Clear-Host
			#DisplayMonitorHeaderInfo
			
			Invoke-Expression $MonitorCommand > "D:\Monitor_Command.txt"
			
			$Monitor_Display = Get-Content "D:\Monitor_Command.txt"

			
			
			if ($Monitor_Display.Length -gt $Max_Page_Rows)
			{
				$Page_Count = [System.Math]::Ceiling($Monitor_Display.Length / $Max_Page_Rows)

				
				$Current_Range_Start = 0
				$Current_Range_End = $Max_Page_Rows
				
				for ($c = 1; $c -le $Page_Count; $c++)
				{
					Write-Host "Page $c of $Page_Count"
					$Current_Display_Set = $Monitor_Display[$Current_Range_Start..$Current_Range_End]
					if ($Current_Display_Set -ne $null)
					{
						$Current_Display_Set
					
						$Current_Range_Start += $Max_Page_Rows
						$Current_Range_End += $Max_Page_Rows
				
						#$Current_Page++
						Sleep 1
						Clear-Host
 						DisplayMonitorHeaderInfo

					}	
				}
								#Start-Sleep $RefreshSeconds
							 						Clear-Host
 						DisplayMonitorHeaderInfo
			}
			else
			{

				$Monitor_Display
				Start-Sleep $RefreshSeconds
						Clear-Host
 						DisplayMonitorHeaderInfo
			}
			
			
			$Today = Get-Date
			if ($Today -gt $StopDateTime)
				{break}
		}
	}