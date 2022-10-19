CLEAR
DO SetEnv

do wwDotNetBridge
LOCAL loBridge as wwDotNetBridge
loBridge = GetwwDotnetBridge()

? loBridge.LoadAssembly("FoxInterop.dll")
loDotnet = loBridge.CreateInstance("FoxProInterop.Interop")

loPerson = loDotnet.GetPerson()
? loPerson.Name
? loPerson.Company

*** This does not work
* loAddress = loPerson.Addresses[0]

*** This does but ugly
* loAddress = loBridge.GetProperty(loPerson,"Addresses[0]")

*** Recommended: ComArray instance
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
