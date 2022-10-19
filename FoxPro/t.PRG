CLEAR
do wwDotNetBridge
LOCAL loBridge as wwDotNetBridge

loBridge = GetwwDotnetBridge()
? loBridge.GetDotnetversion()

? loBridge.LoadAssembly("FoxInterop.dll")

loInstance = loBridge.CreateInstance("FoxProInterop.Interop")
? loInstance.HelloWorld("Rick")

? loInstance.Add(12.2, 12.12)

? loBridge.InvokeMethod(loInstance,"Multiply",10, 20)