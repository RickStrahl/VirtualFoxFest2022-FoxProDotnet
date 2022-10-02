*** Unzips a Zip archive into a folder
*** Creates examples.zip of the archived data
*** and an EXTRACTED folder for the un-archived data
*** THIS EXAMPLE REQUIRES .NET 4.5!
CLEAR
DO wwUtils
do wwDotNetBridge

LOCAL loBridge as wwDotNetBridge
loBridge = GetwwDotNetBridge("V4")

loBridge.LoadAssembly("System.IO.Compression.FileSystem, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")

lcFolder = FULLPATH("examples")
lcZip = FULLPATH("Examples.zip")

? "Zipping Folder " + lcFolder  + " to " + lcZip + "..."

*** File cannot exist so delete first
ERASE (lcZip)

loBridge.InvokeStaticMethod("System.IO.Compression.ZipFile","CreateFromDirectory",;
                              lcFolder,lcZip)
IF !IsNullOrEmpty(loBridge.cErrorMsg)
	? loBridge.cErrORMSG
	RETURN
ENDIF	

lcFolder = FULLPATH("extracted")





*** Data in folder can't be overwritten
*** so delete folder first
DeleteTree(lcFolder)

loBridge.InvokeStaticMethod("System.IO.Compression.ZipFile","ExtractToDirectory",lcZip,lcFolder)
IF !IsNullOrEmpty(loBridge.cErrorMsg)
	? loBridge.cErrORMSG
	RETURN
ENDIF	

? "Done."