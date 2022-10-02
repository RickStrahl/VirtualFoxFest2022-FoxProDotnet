*** Unzips a Zip archive into a folder
*** THIS EXAMPLE REQUIRES .NET 4.5!
CLEAR
do wwDotNetBridge
LOCAL loBridge as wwDotNetBridge
loBridge = GetwwDotNetBridge("V4")

? loBridge.LoadAssembly("System.IO.Compression.FileSystem, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")

lcZip = FULLPATH("examples\wwClient.zip")
lcFolder = FULLPATH("examples\unzipped")

*** Files cannot exist so delete first
DeleteTree(lcFolder)

? loBridge.InvokestaticMethod("System.IO.Compression.ZipFile","ExtractToDirectory",lcZip,lcFolder)
? loBridge.cErrORMSG

RETURN
