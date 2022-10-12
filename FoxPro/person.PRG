CLEAR
DO SetEnv

do wwDotNetBridge
LOCAL loBridge as wwDotNetBridge
loBridge = GetwwDotnetBridge()

? loBridge.LoadAssembly("FoxProInterop.dll")
loDotnet = loBridge.CreateInstance("FoxProInterop.Interop")

loPerson = loDotnet.GetPerson()
? loPerson.Name
? loPerson.Company

* loAddress = loPerson.Addresses[0]

* loAddress = loBridge.GetProperty(loPerson,"Addresses[0]")
loAddresses = loBridge.GetProperty(loPerson,"Addresses")
? loBridge.cErrorMsg

FOR lnX = 0 TO loAddresses.Count -1
	loAddress = loAddresses.Item(lnX)

	? loAddress.Id
	? loAddress.Street
	? loAddress.City
	? loAddress.PostalCode

	*** Enum - shows as an integer
	? loAddress.Type 
ENDFOR

RETURN
