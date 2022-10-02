CLEAR 

do wwDotNetBridge
LOCAL loBridge as wwDotNetBridge
loBridge = GetwwDotnetBridge()

LOCAL loProcesses as Westwind.WebConnnection.ComArray
loProcesses = loBridge.InvokeStaticMethod("System.Diagnostics.Process","GetProcesses")
? loProcesses
? loProcesses.Count

FOR x=0 TO loProcesses.Count -1
   loProcess = loProcesses.Item(x)
   ? loProcess.ProcessName + " " + TRANSFORM(loProcess.NonpagedSystemMemorySize)
ENDFOR

RETURN