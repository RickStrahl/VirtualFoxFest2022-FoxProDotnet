do wwDotNetBridge
SET PROCEDURE TO wwEncryption ADDITIVE

* Sample
#IF .T.
CLEAR
DO setEnv
o = CREATEOBJECT("wwEncryption")

*** Return BinHex instead of Base64 for encrypt or hash
*o.SetBinHexMode()


lcSecret = "seekrit10!"

*** Optional Fixed Salt
*** NOTE: you can also use non-fixed salt. For generating PWs 
***       it's often useful to use a Customer ID as salt
lcSecretSalt = "#@Sek|+!223"

? "Encryption with explicit key:"
lcOriginal = "A very approachable Test String with upper ASCII chars: ƒ¢ªÑº!"
lcOriginal2 = "Saksdj asdklajs dlaksjd aslkdj alksdjalkd jalskdj asdjasld kalksdjlaksjdkljasd"

? lcOriginal
lcEncrypted =  o.Encryptstring(lcOriginal,lcSecret)
? lcEncrypted
*? STRCONV(lcEncrypted,14)
lcDecrypted =  o.Decryptstring(lcEncrypted,lcSecret)
? lcDecrypted

?
? "Encryption using globally assigned key:"
o.SetEncryptionKey(lcSecret + "_explicit")
? lcOriginal
lcEncrypted =  o.Encryptstring(lcOriginal) && no key
? lcEncrypted
lcDecrypted =  o.Decryptstring(lcEncrypted) && no key
? lcDecrypted


?
? "Hash using no Salt:"
? o.ComputeHash(lcOriginal,"MD5")
? o.ComputeHash(lcOriginal,"SHA256")
? o.ComputeHash(lcOriginal,"SHA512")

?
? "Hash using explicit Salt:"
? o.ComputeHash(lcOriginal,"MD5",lcSecretSalt)
? o.ComputeHash(lcOriginal,"SHA256",lcSecretSalt)
? o.ComputeHash(lcOriginal,"SHA512",lcSecretSalt)

?
? "Checksum From File:"
lcFileName = LOWER(FULLPATH("wwdotnetbridge.prg"))
? lcFileName

? "SHA256: " + o.GetChecksumFromFile(lcFilename, "SHA256")
? "MD5: " + o.GetChecksumFromFile(lcFilename, "MD5")

?
? "Checksum From string (same file as above as string)"
lcData = FILETOSTR(FULLPATH("wwDotnetBridge.prg"))
? "SHA256: " + o.GetChecksum(lcData, "SHA256")
? "MD5: " + o.GetChecksum(lcData, "MD5")

?
? "Checksum From Bytes:"
lqBytes = CreateBinary("#UltraSecretText#") && CAST("xxx" as blob)
? "SHA256: " + o.GetChecksum(lqBytes, "SHA256")
? "MD5: " + o.GetChecksum(lqBytes, "MD5")

#ENDIF

*************************************************************
DEFINE CLASS wwEncryption AS Custom
*************************************************************
*: Author: Rick Strahl
*:         (c) West Wind Technologies, 2015
*:Contact: http://www.west-wind.com
*:Created: 04/22/2015
*************************************************************
#IF .F.
*:Help Documentation
*:Topic:
Class wwEncryption

*:Description:
Provides a number of helper functions to encrypt and decrypt
strings as well as providing Hash functions.

*:Example:

*:Remarks:
Relies on .NET and wwDotnetBridge

*:SeeAlso:
Class wwDotnetBridge

*:ENDHELP
#ENDIF

oBridge = null

************************************************************************
*  Init
****************************************
***  Function:
***    Assume:
***      Pass:
***    Return:
************************************************************************
FUNCTION Init()

this.oBridge = GetwwDotNetBridge()
IF (this.oBridge == null)
   ERROR "Unable to load wwDotnetBridge"
ENDIF   

IF (!this.oBridge.LoadAssembly("wwEncryption.dll"))
  ERROR this.oBridge.cErrorMsg
ENDIF  

ENDFUNC
*   Init


************************************************************************
*  EncryptString
****************************************
***  Function: Encrypts a string with a pass phrase using TripleDES
***            or AES encryption.
***    Assume: 
***      Pass: lcInput         - String to encrypt
***            lcEncryptionKey - pass phrase to encrypt string with
***                              Optional - if not uses global EncryptionKey
***            llUseBinHex     - opt. BinHex encoding of binary, otherwise Base64
***            lcProvider      - opt. TripleDES*, AES 
***            lcCipherMode    - opt. ECB*, CBC, CTS, OFB
***            lcHashAlgo      - opt. hash algorith for for key hash (using HASH names)
***            lcEncryptipKeyHashSalt - opt. Key Salt 
***            lcIvKey         - opt. Iv Key for AES
***    Return: Encrypted string in Base64 or BinHex Empty on Error
************************************************************************
FUNCTION EncryptString(lcInput, lcEncryptionKey, llUseBinHex, ;
                       lcProvider, lcCipherMode, ;
                       lcEncryptionKeyHashAlgo, lcEncryptionKeyHashSalt,;
                       lcIvKey)
LOCAL lcError, lcResult

IF EMPTY(lcEncryptionKey)
  lcEncryptionKey = null
ENDIF  

IF VARTYPE(lcProvider) # "C"
   lcProvider = null
ENDIF
IF VARTYPE(lcCipherMode) # "C"
  lcCipherMode = null
ENDIF
IF VARTYPE(lcEncryptionKeyHashAlgo) # "C"
  lcEncryptionKeyHashAlgo = "MD5"   && legacy mode - pass empty string for none
ENDIF  
IF VARTYPE(lcEncryptionKeyHashSalt) # "C"
  lcEncryptionKeyHashSalt = null
ENDIF
IF VARTYPE(lcIvKey) # "C"
  lcIvKey = null
ENDIF

lcError = ""
lcResult = ""
TRY 
	lcResult =this.oBridge.InvokeStaticMethod(;
                   "wwEncryption.EncryptionUtils",;
                   "EncryptString",;
                   lcInput,lcEncryptionKey, llUseBinHex,;
                   lcProvider, lcCipherMode, ;
                   lcEncryptionKeyHashAlgo, lcEncryptionKeyHashSalt,;
                   lcIvKey)
CATCH TO loException
	lcError = THIS.oBridge.FixComErrorMessage(loException.Message)
ENDTRY


*** Rethrow Error
IF !EMPTY(lcError)
   ERROR lcError
ENDIF

RETURN lcResult                                   
ENDFUNC
*   EncryptString

************************************************************************
*  DecryptString
****************************************
***  Function: Decrypts a string with a pass phrase using TripleDES
***            encryption. The Decrypt function should use the same
***            encryption key that was used to encrypt the string.
***      Pass: lcEncryptedText  -  Encrypted text
***            lcEncryptionKey  -  Same key that was used to encrypt
***    Return:
************************************************************************
FUNCTION DecryptString(lcEncryptedText, lcEncryptionKey, llUseBinHex,;
                       lcProvider, lcCipherMode, ;
                       lcEncryptionKeyHashAlgo, lcEncryptionKeyHashSalt,;
                       lcIvKey)
LOCAL lcError, lcResult                       

IF EMPTY(lcEncryptionKey)
  lcEncryptionKey = null
ENDIF  

IF VARTYPE(lcProvider) # "C"
   lcProvider = null
ENDIF
IF VARTYPE(lcCipherMode) # "C"
  lcCipherMode = null
ENDIF
IF VARTYPE(lcEncryptionKeyHashAlgo) # "C"
  lcEncryptionKeyHashAlgo = "MD5"   && legacy mode - pass empty string for none
ENDIF  
IF VARTYPE(lcEncryptionKeyHashSalt) # "C"
  lcEncryptionKeyHashSalt = null
ENDIF
IF VARTYPE(lcIvKey) # "C"
  lcIvKey = null
ENDIF

lcError = ""
lcResult = ""
TRY 
	lcResult = this.oBridge.InvokeStaticMethod(;
                   "wwEncryption.EncryptionUtils","DecryptString",;
                   lcEncryptedText,lcEncryptionKey, llUseBinHex,;
                   lcProvider, lcCipherMode,;
                   lcEncryptionKeyHashAlgo, lcEncryptionKeyHashSalt,;
                   lcIvKey)
CATCH TO loException
	lcError = this.oBridge.FixComErrorMessage(loException.Message)
ENDTRY


*** Rethrow Error
IF !EMPTY(lcError)
   ERROR lcError
ENDIF

RETURN lcResult                   
ENDFUNC
*  DecryptString

************************************************************************
*  ComputeHash
****************************************
***  Function:
***      Pass:  lcText      - Text to hash, or binary data (type Q)
***             lcAlgorithm - MD5*,SHA1,SHA256, HMACSHA256  etc.
***             llBinHex    - if .T. returns binHex, base64 is default
***    Return:  Hashed value as string
************************************************************************
FUNCTION ComputeHash(lcText, lcAlgorithm, lvHashSalt, llUseBinHex)
LOCAL lcSaltType, lcResult, llOldBinHex

llOldBinHex = this.GetBinHexMode()
IF PCOUNT() < 4 AND llOldBinhex 
   llUseBinHex = llOldBinHex
ENDIF   

IF EMPTY(lcAlgorithm)
   lcAlgorithm = "MD5"
ENDIF   

lcSaltType = VARTYPE(lvHashSalt)
IF lcSaltType != "Q" AND lcSaltType != "C"
  lvHashSalt = "" 
ENDIF

this.SetBinHexMode(llUseBinHex)

lcResult = this.oBridge.InvokeStaticMethod(;
                   "wwEncryption.EncryptionUtils",;
                   "ComputeHash",lcText,lcAlgorithm,lvHashSalt)                   

this.SetBinHexMode(llOldBinHex)

RETURN lcResult
ENDFUNC
*   ComputeHash


************************************************************************
*  GetCheckSumFromFile
****************************************
***  Function: Calculates a CheckSum from a file using MD5 or SHA256
***    Assume:
***      Pass: lcFilename -  File to check
***            lcMode     -  "SHA256","MD5"*
***    Return:
************************************************************************
FUNCTION GetCheckSumFromFile(lcFilename, lcMode)

IF EMPTY(lcMode)
   lcMode = "MD5"
ENDIF

RETURN this.oBridge.InvokeStaticMethod(;
                   "wwEncryption.EncryptionUtils",;
                   "GetChecksumFromFile",lcFilename, lcMode)
ENDFUNC
*   GetCheckSumFromFile


************************************************************************
*  GetChecksum
****************************************
***  Function: Calculates a CheckSum from a string or binary blob using MD5 or SHA256
***    Assume:
***      Pass: lqBytes    -  Binary data to check
***            lcMode     -  "SHA256","MD5"*
***    Return:
************************************************************************
FUNCTION GetChecksum(lqBytes, lcMode)

IF VARTYPE(lqBytes) = "C"
   lqBytes = CAST(lqBytes as Blob)
ENDIF
IF EMPTY(lcMode)
   lcMode = "MD5"
ENDIF

RETURN this.oBridge.InvokeStaticMethod(;
                   "wwEncryption.EncryptionUtils",;
                   "GetChecksumFromBytes",lqBytes, lcMode)
ENDFUNC
*   GetChecksum



************************************************************************
*  SetEncryptionKey
****************************************
***  Function: Sets the default Encryption key for the EncryptString
***            DecryptString methods if the pass phrase is not passed.
***    Assume: Set during application startup which makes the key 
***            global for the application.
***      Pass: lcKey  -    The pass phrase key to use
***    Return: nothing
************************************************************************
FUNCTION SetEncryptionKey(lcKey)

RETURN this.oBridge.SetStaticProperty(;
				   "wwEncryption.EncryptionUtils",;
                   "EncryptionKey",lckey)
ENDFUNC
*   SetEncryptionKey

************************************************************************
*  SetEncryptionProvider
****************************************
***  Function: Switches the Encryption provider used by the 
***            EncryptString() and DecryptString() methods.
***      Pass: lcProvider  - "TripleDES" "AES"
***    Return: nothing
************************************************************************
FUNCTION SetEncryptionProvider(lcProvider, lldontUseMd5EncryptionKey)

IF EMPTY(lcProvider)
   lcProvider = "TripleDES"
ENDIF   

this.oBridge.SetStaticProperty(;
				   "wwEncryption.EncryptionUtils",;
                   "EncryptionProvider",lcProvider)

this.oBridge.SetStaticProperty(;
				   "wwEncryption.EncryptionUtils",;
                   "EncryptionUseMd5EncryptionKey",!lldontUseMd5Encryption)


ENDFUNC
*   SetEncryptionProvider

************************************************************************
*  SetBinHexMode
****************************************
***  Function:
***    Assume:
***      Pass:
***    Return:
************************************************************************
FUNCTION SetBinHexMode(llMode)

llValue = .F.
IF PCOUNT() = 0 OR llMode
   llValue = .T.
ENDIF

RETURN this.oBridge.SetStaticProperty(;
				   "wwEncryption.EncryptionUtils",;
                   "UseBinHex",llValue)
ENDFUNC
*   SetBinHexMode

************************************************************************
*  GetBinHexMode
****************************************
***  Function:
***    Assume:
***      Pass:
***    Return:
************************************************************************
FUNCTION GetBinHexMode() 
RETURN this.oBridge.GetStaticProperty(;
				   "wwEncryption.EncryptionUtils",;
                   "UseBinHex")
ENDFUNC
*   GetBinHexMode

ENDDEFINE
*EOC wwEncryption 