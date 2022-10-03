do wwDotNetBridge
LOCAL loBridge as wwDotNetBridge
loBridge = GetwwDotnetBridge()

? loBridge.LoadAssembly("FoxProInterop.dll")


LOCAL loInterop
loInterop = loBridge.CreateInstance("FoxProInterop.Interop")

? loInterop.HelloWorld("Frederik")

RETURN




