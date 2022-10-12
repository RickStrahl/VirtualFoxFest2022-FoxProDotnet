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
loPerson = loDotnet.GetPerson()
loPerson.Name = "Rick Strahl Updated"

loAddress = loBridge.GetProperty(loPerson,"Addresses[0]")
loAddress.City = "New City"

*** Send the updated object to .NET
loDotnet.SetPerson(loPerson)


*** Now let's look at the DefaultPerson that was updated from what we passed
? loDotnet.DefaultPerson.Name
loAddress = loBridge.GetProperty(loDotnet.DefaultPerson,"Addresses[0]")
? loAddress.City

RETURN
