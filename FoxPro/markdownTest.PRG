*** Markdown Parser Example
*** Uses Open Source MarkDig .NET library: 
CLEAR
DO setEnv


*** Raw wwDotnetBridge
#IF .T.

do wwDotNetBridge
LOCAL loBridge as wwDotNetBridge
loBridge = CreateObject("wwDotNetBridge")

? loBridge.LoadAssembly("markdig.dll")

TEXT TO lcMarkdown NOSHOW
# Markdown Parsing with wwDotnetBridge

![](https://west-wind.com/Images/wwDotnetBridge_Logo.png)

Render Markdown into HTML for embedding into document centric applications 
that can display content as HTML. 

This sample uses **Markdown Text** that is parsed using the 
[Open Source .NET MarkDig Library](https://github.com/xoofx/markdig),
accessed using a small bit of [wwDotnetBridge](https://github.com/RickStrahl/wwDotnetBridge) code.


* Full featured Markdown Parser
* Support for many optional Markdown Flavors
* GitHub formatted Markdown
* and much more...

It's easy to use and quick to get started with.

> ####  Examples are great
> Markdown is a popular format used for many types of documentation, 
> message boards, social media sites and many popular editors

*&copy; West Wind Technologies*


### Markdown Text
ENDTEXT

lcMarkdown = lcMarkdown + CHR(13) + CHR(10) + "```markdown"  +  CHR(13) + CHR(10) + lcMarkdown + CHR(13) + CHR(10) + "```"


*** Create an object instance - pipeline parameter for ToHtml
LOCAL loBuilder, loPipeline
loBuilder = loBridge.CreateInstance("Markdig.MarkdownPipelineBuilder")
loPipeline = loBuilder.Build()

*** Invoke a static method
lcHtml =  loBridge.InvokeStaticMethod("Markdig.Markdown","ToHtml",lcMarkdown,loPipeline, null)

? lcHtml
_cliptext = lcHtml

ShowHtml(lcHtml)

RETURN
#ENDIF


