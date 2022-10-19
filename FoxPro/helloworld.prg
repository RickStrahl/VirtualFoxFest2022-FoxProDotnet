CLEAR
DO setEnv

do wwDotNetBridge
LOCAL loBridge as wwDotNetBridge
loBridge = GetwwDotnetBridge()

? loBridge.LoadAssembly("FoxProInterop.dll")  
? loBridge.cErrorMsg


*** instantiate class by full .NET type name: namespace.class
loInterop = loBridge.CreateInstance("FoxProInterop.Interop")   

? loInterop.HelloWorld("Rick")

? loInterop.ADd(10.10, 20.20)

*lnResult = loInterop.Multiply(1000, 20000)


lnResult = loBridge.invokemethod(loInterop, "Multiply", 1000, 20000)
? lnResult




