CLEAR
do wwDotNetBridge
LOCAL loBridge as wwDotNetBridge

loBridge = GetwwDotnetBridge()
? loBridge.GetDotnetversion()



loBridge.LoadAssembly("bin\FoxProInterop.dll")
? loBridge.cErrorMsg
loInterop = loBridge.CreateInstance("FoxProInterop.Interop")
? loBridge.cErrorMsg
? loInterop.HelloWorld("Rick")

? loInterop.Add(20, 30.20)
* ? loBridge.InvokeStaticMethod("FoxProInterop.Interop","Add", 20, 30)

? loInterop.Multiply(10.2,20.1)


RETURN 



? loBridge.GetStaticProperty("System.Net.ServicePointManager","ServerCertificateValidationCallback")


loClient = loBridge.CreateInstance("Westwind.WebConnection.HttpClient")
? loBridge.cErrorMsg

loClient.IgnoreCertificateErrorrs = .T.
loClient.Dispose()

*loBridge.SetStaticProperty("System.Net.ServicePointManager","ServerCertificateValidationCallback",.null.)
? loBridge.GetStaticProperty("System.Net.ServicePointManager","ServerCertificateValidationCallback")





RETURN

RETURN

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




