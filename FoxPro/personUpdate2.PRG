CLEAR
DO SetEnv

do wwDotNetBridge
LOCAL loBridge as wwDotNetBridge
loBridge = GetwwDotnetBridge()

? loBridge.LoadAssembly("FoxProInterop.dll")
loDotnet = loBridge.CreateInstance("FoxProInterop.Interop")

*** Important: In order to pass an object that object
***            must be created in .NET!

*** Update an existing person
loPerson = loBridge.CreateInstance("FoxProInterop.Person")

loPerson.Name = "Rick Strahl New"
loPerson.Company = "Easter Egg"
loPerson.Email = "test@easteregg.com"

*** Create a new Address instance
loAddresses = loBridge.GetProperty(loPerson,"Addresses")
loAddress = loBridge.CreateInstance("FoxProInterop.Address")
loAddress.Street = "321 Somewhere Lane"
loAddress.City = "Somewhere"
loAddress.PostalCode = "44444"

*** Use indirect syntax - required because .NET Generic (List<Address>)
loBridge.InvokeMethod(loPerson, "Addresses.Clear")  
loBridge.InvokeMethod(loPerson, "Addresses.Add", loAddress)

*** Access the list get back a ComArray
loAddresses = loBridge.GetProperty(loPerson,"Addresses")


*** Now push that to .NET
? loDotnet.SetPerson(loPerson)

loPerson = .F.

? "*** DefaultPerson from .NET"


*** Updated in the Set operation
loPerson2 = loDotnet.DefaultPerson

? loPerson2.Name
? loPerson2.Company
? loPerson2.Email

loAddresses = loBridge.GetProperty(loPerson2,"Addresses")

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