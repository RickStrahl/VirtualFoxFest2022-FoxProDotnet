DO wwdotnetBridge
SET PROCEDURE TO MarkDownParser ADDITIVE

* See FoxUnit: Tests\MarkdownParserTests.prg

#IF .T.

TEXT TO lcMarkdown NOSHOW
This is some sample Markdown text. This text is **bold** and *italic*.

* List Item 1
* List Item 2
* List Item 3

Great it works!

> ### ![](https://upload.wikimedia.org/wikipedia/commons/thumb/d/d0/Commons-emblem-legal.svg/45px-Commons-emblem-legal.svg.png) Examples are great
> This is a block quote with a header
ENDTEXT

lcHtml = Markdown(lcMarkdown)
? lcHtml

lcHtml = Markdown(lcMarkdown)
? lcHtml
#ENDIF


************************************************************************
*  Markdown
****************************************
***  Function: Converts Markdown to HTML
***    Assume: Caches instance in __MarkdownParser
***      Pass: lcMarkdown  - text to convert to HTML from Markdown
***            lnMode      - 0/.F. - standard, 2 extended, 1 - standard, leave scripts, 3 - extended leave scripts
***    Return:
************************************************************************
FUNCTION Markdown(lcMarkdown, lnMode, llReload, llUtf8, llNoSanitizeHtml, llNoHtmlAllowed)
LOCAL loMarkdown, lcClass

IF llReload OR VARTYPE(__MarkdownParser) != "O" 
	IF EMPTY(lnMode)
	   lnMode = 0
	ENDIF   

	lcClass = "MarkdownParser"
	IF lnMode = 2
	   lcClass = "MarkdownParserExtended"
	ENDIF
	
	loMarkdown = CREATEOBJECT(lcClass)
	PUBLIC __MarkdownParser
	__MarkdownParser = loMarkdown
	
	IF lnMode = 1 OR lnMode = 3
	   __MarkdownParser.lEncodeScriptBlocks = .F.  	  	   	  
	ENDIF	
	
	__MarkdownParser.lSanitizeHtml = !llNoSanitizeHtml
	__MarkdownParser.lNoHtmlAllowed = llNoHtmlAllowed
ELSE
    loMarkdown = __MarkdownParser
ENDIF

RETURN loMarkdown.Parse(lcMarkdown, llUtf8)
ENDFUNC
*   Markdown


*************************************************************
DEFINE CLASS MarkDownParser AS Custom
*************************************************************
*: Author: Rick Strahl
*:         (c) West Wind Technologies, 2013
*:Contact: http://www.west-wind.com
*:Created: 01/03/2013
*************************************************************
#IF .F.
*:Help Documentation
*:Topic:
Class MarkDownParser

*:Description:
Class that parses markdown style documents into 
HTML. Includes custom post processing for Help Builder
style formatting.

*:Example:

*:Remarks:

*:SeeAlso:


*:ENDHELP
#ENDIF

oPipeline = null

oBridge = null
lEncodeScriptBlocks = .T.
lSanitizeHtml = .T.
lNoHtmlAllowed = .F.

************************************************************************
*  Init
****************************************
***  Function:
***    Assume:
***      Pass:
***    Return:
************************************************************************
FUNCTION Init()
LOCAL loBridge as wwDotNetBridge

loBridge = GetwwDotnetBridge("V4")

this.oBridge = loBridge
IF ISNULL(THIS.oBridge)
   RETURN .F.
ENDIF

IF !loBridge.LoadAssembly("markdig.dll")
   RETURN .F.
ENDIF   


ENDFUNC
*   Init

************************************************************************
*  CreateParser
****************************************
***  Function:
***    Assume:
***      Pass:
***    Return:
************************************************************************
FUNCTION CreateParser(llForce, llPragmaLines)
LOCAL loBuilder, loValue, loBridge

IF llForce OR ISNULL(this.oPipeline)
	loBridge = this.oBridge
	loBuilder = loBridge.CreateInstance("Markdig.MarkdownPipelineBuilder")

	loValue = loBridge.Createcomvalue()
	loValue.SetEnum("Markdig.Extensions.EmphasisExtras.EmphasisExtraOptions.Default")	
	loBuilder = loBridge.Invokestaticmethod("Markdig.MarkdownExtensions","UseEmphasisExtras",loBuilder,loValue)

	loBuilder = loBridge.Invokestaticmethod("Markdig.MarkdownExtensions","UseListExtras",loBuilder)	
	loBuilder = loBridge.Invokestaticmethod("Markdig.MarkdownExtensions","UseCustomContainers",loBuilder)

	loBuilder = loBridge.Invokestaticmethod("Markdig.MarkdownExtensions","UseFooters",loBuilder)
	loBuilder = loBridge.Invokestaticmethod("Markdig.MarkdownExtensions","UseFigures",loBuilder)
	loBuilder = loBridge.Invokestaticmethod("Markdig.MarkdownExtensions","UseFootnotes",loBuilder)
	loBuilder = loBridge.Invokestaticmethod("Markdig.MarkdownExtensions","UseCitations",loBuilder)	
	
	loBuilder = loBridge.Invokestaticmethod("Markdig.MarkdownExtensions","UsePipeTables",loBuilder,null)
	loBuilder = loBridge.Invokestaticmethod("Markdig.MarkdownExtensions","UseGridTables",loBuilder)

	loValue = loBridge.Createcomvalue()
	loValue.SetEnum("Markdig.Extensions.AutoIdentifiers.AutoIdentifierOptions.GitHub")
	loBridge.Invokestaticmethod("Markdig.MarkdownExtensions","UseAutoIdentifiers",loBuilder,loValue)

	loOptions = loBridge.CreateInstance("Markdig.Extensions.AutoLinks.AutoLinkOptions")
	loBuilder = loBridge.Invokestaticmethod("Markdig.MarkdownExtensions","UseAutoLinks",loBuilder,loOptions)
	
	loBuilder = loBridge.Invokestaticmethod("Markdig.MarkdownExtensions","UseYamlFrontMatter",loBuilder)
	loBuilder = loBridge.Invokestaticmethod("Markdig.MarkdownExtensions","UseEmojiAndSmiley",loBuilder,.T.)

	IF this.lNoHtmlAllowed
	   loBuilder = loBridge.Invokestaticmethod("Markdig.MarkdownExtensions","DisableHtml",loBuilder)
	ENDIF

	IF llPragmaLines
	  loBuiler = loBridge.Invokestaticmethod("Markdig.MarkdownExtensions","UsePragmaLines",loBuilder)
	ENDIF

	THIS.oPipeline = loBuilder.Build()
ENDIF

RETURN this.oPipeline
ENDFUNC
*   CreateParser

************************************************************************
*  Parse
****************************************
***  Function:
***    Assume:
***      Pass:
***    Return:
************************************************************************
FUNCTION Parse(lcMarkdown, llUtf8, llDontSanitizeHtml)
LOCAL lcHtml, loScriptTokens, loPipeline, lnOldCodePage

IF !this.lEncodeScriptBlocks
   loScriptTokens = TokenizeString(@lcMarkdown,"<%","%>","@@SCRIPT")
ENDIF

loPipeline = this.CreateParser()

*** result always comes back as UTF-8 encoded
IF (llUtf8)
   lnOldCodePage = SYS(3101)
   SYS(3101,65001)
   lcMarkdown = STRCONV(lcMarkdown,9)
ENDIF

lcHtml = this.oBridge.InvokeStaticMethod("Markdig.Markdown","ToHtml",lcMarkdown,loPipeline,null)

IF llUtf8
  SYS(3101,lnOldCodePage)  
ENDIF

IF !THIS.lEncodeScriptBlocks
  lcHtml = DetokenizeString(lcHtml,loScriptTokens,"@@SCRIPT")
ENDIF

IF PCOUNT() < 3
   llDontSanitizeHtml = !THIS.lSanitizeHtml
ENDIF   

IF !llDontSanitizeHtml
  lcHtml = THIS.SanitizeHtml(lcHtml)
ENDIF

lcHtml = TRIM(lcHtml,0," ",CHR(13),CHR(10),CHR(9))

RETURN lcHTML   
ENDFUNC
*   Parse


************************************************************************
*  SanitizeHtml
****************************************
***  Function: Removes scriptable code from HTML. 
***    Assume: 
***      Pass:
***    Return:
************************************************************************
FUNCTION SanitizeHtml(lcHtml, lcHtmlTagBlacklist)

IF EMPTY(lcHtmlTagBlackList)
	lcHtmlTagBlackList = "script|iframe|object|embed|form"
ENDIF
IF EMPTY(lcHtml)
   RETURN lcHtml	
ENDIF

RETURN THIS.oBridge.InvokeStaticMethod("Westwind.WebConnection.StringUtils","SanitizeHtml",lcHtml, lcHtmlTagBlacklist)
ENDFUNC
*   SanitizeHtml

ENDDEFINE

*************************************************************
DEFINE CLASS MarkDownParserExtended AS MarkDownParser
*************************************************************
*: Author: Rick Strahl
*:         (c) West Wind Technologies, 2013
*:Contact: http://www.west-wind.com
*:Created: 01/03/2013
*************************************************************
#IF .F.
*:Help Documentation
*:Topic:
Class MarksDownAndCodeParser
*:Description:
Adds additional functionality to the MarkdownParser for 
customizing syntax colored code output and for FontAwesome
icons.

*:Example:

*:Remarks:

*:SeeAlso:


*:ENDHELP
#ENDIF

*** Internal list of codeblocks temporarily handled
PROTECTED oCodeBlocks
oCodeBlocks = null

*** Start HTML block for code blocks. use ###language### to replace language
*** if blank default parsing format is used which is 
*** <pre><code class="language-html">code here (html encoded)
*** more code (html encoded)
*** </code></pre>
cCodeBlockStartHtml = ""
cCodeBlockEndHtml = ""

*** Ace Editor format
*cCodeBlockStartHtml = [<pre lang="###language###">]  + CHR(13) + CHR(10) 
*cCodeBlockEndHtml = [</pre>]

*** Highlight.js
* cCodeBlockStartHtml = [<pre class="no-container"><code class="###language###">]
* cCodeBlockEndHtml = [</code></pre>]

*** If set applies this target to all links
cLinkTarget = ""

************************************************************************
*  Init
****************************************
***  Function:
***    Assume:
***      Pass:
***    Return:
************************************************************************
FUNCTION Init()

DODEFAULT()

this.oCodeBlocks = CREATEOBJECT("Collection")

ENDFUNC
*   Init

************************************************************************
*  Parse
****************************************
***  Function:
***    Assume:
***      Pass:
***    Return:
************************************************************************
FUNCTION Parse(lcMarkdown, llUtf8, llDontSanitizeHtml)
LOCAL lcHtml

IF PCOUNT() < 3
   llDontSanitizeHtml = !THIS.lSanitizeHtml
ENDIF

this.FixCodeBlocks(@lcMarkdown)
lcHtml = DODEFAULT(lcMarkDown,llUtf8, llDontSanitizehtml)      

*** Must fix these before codeblocks to avoid potential html with icon-  syntax
this.FixIcons(@lcHtml)

IF !EMPTY(this.cLinkTarget)
	this.AddLinkTarget(@lcHtml)
ENDIF

*** Push codeblocks back in
*!*	FOR lnX = 1 TO this.oCodeblocks.Count
*!*	   lcHtml = STRTRAN(lcHtml,"@@@codeblock_" + TRANSFORM(lnX) + "@@@",this.oCodeBlocks.Item(lnX))
*!*	ENDFOR

RETURN lcHtml
ENDFUNC
*   Parse


************************************************************************
*  AddLinkTarget
****************************************
***  Function:
***    Assume:
***      Pass:
***    Return:
************************************************************************
FUNCTION AddLinkTarget(lcHtml)

lcHtml = STRTRAN(lcHtml,"<a ",[<a target="] + this.cLinkTarget + [" ])

ENDFUNC
*   FixLinks

************************************************************************
*  FixIcons
****************************************
***  Function: Checks for @icon-ICONNAME and creates FontAwesome Icon
***            in its place.
***    Assume:
***      Pass: 
***    Return:
************************************************************************
FUNCTION FixIcons(lcHtml)
LOCAL lcText

DO WHILE .T.
	lcText = STREXTRACT(lcHtml,[@icon-],[ ],1,5)
	IF (EMPTY(lcText))
	    RETURN lcHtml
	ENDIF
	lcIcon = STREXTRACT(lcText,"@icon-"," ",1,1)
	lcHtml = STRTRAN(lcHtml,lcText,[<i class="fa fa-] + lcIcon + ["></i> ])
ENDDO

RETURN lcHtml
ENDFUNC
*   FixIcons

************************************************************************
*  FixCodeBlocks
****************************************
***  Function:
***    Assume:
***      Pass:
***    Return:
************************************************************************
FUNCTION FixCodeBlocks(lcHtml)
LOCAL lcLang, lcExtract, lcOrigExtract,lcCode, lcReplaceHtml,lcLang, lnx

*** If we don't override the rendering just return the original value
IF EMPTY(this.cCodeBlockStartHtml)
   RETURN lcHtml
ENDIF

this.oCodeBlocks = CREATEOBJECT("Collection")

lnx = 0
*** Handle ``` code blocks
DO WHILE .T.

	lcOrigExtract = STREXTRACT(lcHtml,[```],[```],1,5)
	lcExtract = lcOrigExtract
	IF EMPTY(lcExtract)
		EXIT
	ENDIF

    *** Normalize linefeeds
    lcExtract = STRTRAN(lcExtract,CHR(13)+CHR(10),"%%$$")
    lcExtract = STRTRAN(lcExtract,CHR(13),CHR(10))
    lcExtract = STRTRAN(lcExtract,"%%$$",CHR(10))
    

    lcFirstLine = EXTRACT(lcExtract,"```",CHR(10),.F.,.t.,.T.)
    lcLang = STREXTRACT(lcFirstLine,"```","",1)
    lcLang = LOWER(CHRTRAN(lcLang,CHR(10)+CHR(13),""))
    
	DO CASE	
	CASE lcLang = "vfp"
	   lcLang = "foxpro"
	CASE lcLang = "c#"
	   lcLang = "csharp"
	CASE lcLang == "vbscript"
	   lcLang = "vbscript"
	CASE lcLang = "vb"
	   lcLang = "vbscript"
	CASE lcLang = "c++"
	   lcLang = "c_cpp"
	CASE lcLang = "txt" OR EMPTY(lcLang)
	   lcLang = "text"
	   WAIT WINDOW lcLang    
	ENDCASE

	lcCode = STREXTRACT(lcExtract,lcFirstLine,"```",1,2)

	lcReplaceHtml = STRTRAN(this.cCodeBlockStartHtml,"###language###",lcLang) + ;
			EncodeHtml( TRIM(lcCode,0," ",CHR(13),CHR(10),CHR(9)) ) + ;
			THIS.cCodeBlockEndHtml
       
	this.oCodeBlocks.Add(lcReplaceHtml)    
	lnX = lnX + 1 
	lcHtml = STRTRAN(lcHtml,lcOrigExtract,"@@@codeblock_" + TRANSFORM(lnX) + "@@@")
ENDDO

RETURN lcHtml
ENDFUNC
*   FixCodeBlocks

ENDDEFINE
*EOC wwHelpMarkDownParser 
