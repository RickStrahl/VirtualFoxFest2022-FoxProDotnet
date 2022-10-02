CLEAR
DO setEnv

do wwDotNetBridge
LOCAL loBridge as wwDotNetBridge
loBridge = GetwwDotnetBridge()

? loBridge.LoadAssembly("FoxProInterop.dll")
*? loBridge.LoadAssembly("..\DotNet\FoxProInterop\FoxProInterop\bin\Debug\net472\FoxProInterop.dll")

loInterop = loBridge.CreateInstance("FoxProInterop.Interop")
? loInterop.HelloWorld("Rick")


RETURN



