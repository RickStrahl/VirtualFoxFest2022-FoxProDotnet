*** Demonstrates:
*** Reading an Enum Value
*** Loading a .NET CLR Type
*** Accessing an Array Property using GetPropertyEx()
*** Accessing nested properties with GetPropertyEx
CLEAR
*DO SETENV

*** Load library
DO wwDotNetBridge

*** Create instance of wwDotnetBridge
LOCAL loBridge as wwDotNetBridge
loBridge = CreateObject("wwDotNetBridge")

*** Create an instance of 509Store
loStore = loBridge.CreateInstance("System.Security.Cryptography.X509Certificates.X509Store")

*** Grab a static Enum value
leReadOnly = loBridge.GetEnumvalue("System.Security.Cryptography.X509Certificates.OpenFlags","ReadOnly")

*** Use the enum value
loStore.Open(leReadOnly) &&leReadOnly)

*** Alternately you can use the enum value if known
*loStore.Open(0) &&leReadOnly)

*** Collection of Certificates (custom collection not an array, not normal collection)
laCertificates = loStore.Certificates

*** This doesn't work: Inherited collection type
*? laCertificates.Count

*** so use indirect access
lnCount = loBridge.GetProperty(laCertificates,"Count")
? lnCount

*** Loop through Certificates
FOR lnX = 0 TO lnCount -1
	
	*** Access collection item indirectly using indexer string syntax
	loCertificate = loBridge.GetProperty(loStore,"Certificates[" + TRANSFORM(lnX) + "]")
	
	IF !ISNULL(loCertificate)
		? loCertificate.FriendlyName
		? "  " + loCertificate.Subject
		? "  " + loBridge.GetProperty(loCertificate,"IssuerName.Name")
		? "  " + TRANSFORM(loCertificate.NotAfter)
	ENDIF
ENDFOR

RETURN
