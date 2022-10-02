CLEAR
DO setEnv
? SET("PATH")

do wwDotNetBridge
LOCAL loBridge as wwDotNetBridge
loBridge = GetwwDotnetBridge()


? loBridge.LoadAssembly("FoxProInterop.dll")  
? loBridge.cErrorMsg


*** instantiate class by full .NET type name: namespace.class
loInterop = loBridge.CreateInstance("FoxProInterop.Interop")   

? loInterop.HelloWorld("Rick")






