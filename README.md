# Visual FoxFest Session: Revisiting  modern .NET for the FoxPro Interop Developer

<small>*prepared for [Virtual FoxFest 2022](https://virtualfoxfest.com/2022October/Sessions.aspx)*</small>

This is the session repository that provides access to:

* [Session White Paper PDF](Documents/Strahl_FoxProDotnet.pdf) ([html](Documents/Markdown/FoxProDotnet.md))
* [Session Slides](Documents/Strahl_FoxProDotNet.pptx)
* [YouTube Session](https://www.youtube.com/watch?v=RrMe1KwSnF4)
* .NET and FoxPro Examples
   * [FoxPro](./FoxPro)
   * [.NET](./DotNet)

**Additional Resources** 

* [wwDotnetBridge Source Code on Github](https://github.com/rickstrahl/wwdotnetbridge)
* [wwDotnetBridge Documentation](https://client-tools.west-wind.com/docs/_24n1cfw3a.htm)
* [Original wwDotnetBridge White Paper](https://west-wind.com/presentations/wwdotnetbridge/wwDotnetBridge.pdf)
* [West Wind Client Tools (commercial version)](https://client-tools.west-wind.com)

## Session Description

If you're building modern applications that need to interface with various system or operating system features, you'll likely need external functionality that isn't available natively in FoxPro. Whatever your needs are, you can probably find this functionality in .NET either via built-in features, or by way of open source or third party libraries. With the wwDotnetBridge Interop library you can access most features directly, or you can build small .NET components that often make those interfaces easier to use.

While wwDotnetBridge can directly call .NET code, if your code requires a number of calls or accesses complex types it's often much easier to create a small wrapper library in .NET and call that from your FoxPro code.

In this session you'll learn how you can easily create small .NET components and use them from your FoxPro code, using both new lightweight tools like Visual Studio Code to create, build and run your code from the command line, as well as using full development IDEs like Visual Studio or Rider to build, debug and test .NET code and then call it from your FoxPro application. You'll find out about useful tools like LINQPad to quickly experiment with .NET code, and decompilers like Reflector, ILSpy, DotPeek and JustDecompile to examine API signatures so you know what's available to call for your FoxPro code.

You will learn:

* How to create a .NET project
* How to use NuGet to work with third party components
* How to figure out what dependencies are required
* How to build and compile .NET code into an assembly
* How to test code interactively with LINQPad
* How to use decompilers like Reflector, DotPeek, JustDecompile to figure out API signatures
* How to call your assemblies using the open source version of wwDotNetBridge
* Prerequisites: Some familiarity with .NET is helpful but not required
