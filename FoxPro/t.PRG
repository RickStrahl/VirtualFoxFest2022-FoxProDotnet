do wwDotNetBridge
LOCAL loBridge as wwDotNetBridge
loBridge = GetwwDotnetBridge()

? loBridge.LoadAssembly("FoxProInterop.dll")


LOCAL loInterop
loInterop = loBridge.CreateInstance("FoxProInterop.Interop")

loInterop.DefaultName = "Jane Anonymous"

? loInterop.HelloWorld(null)
? loInterop.HelloWorld("Frederik")

? loInterop.Add(10, 20)



*? loInterop.Multiply(20, 10)

lnResult = loBridge.InvokeMethod(loInterop, "Multiply", 20, 10)
? lnResult

* loInterop.Add( "www", "Test")

? loBridge.InvokeMethod(loInterop,"Add","www","TEST")

RETURN




