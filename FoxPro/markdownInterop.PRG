CLEAR
DO setEnv

do wwDotNetBridge
LOCAL loBridge as wwDotNetBridge
loBridge = GetwwDotnetBridge()

? loBridge.LoadAssembly("FoxProInterop.dll")

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

* lcHtml = loBridge.InvokeStaticMethod("FoxProInterop.Interop", "MarkdownToHtml", lcMarkdown)

lcHtml = loBridge.InvokeStaticMethod("FoxProInterop.Markdown", "ToHtml", lcMarkdown)

? lcHtml
ShowHtml(lcHtml)

