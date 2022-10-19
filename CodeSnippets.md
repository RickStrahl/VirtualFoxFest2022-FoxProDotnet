### Initial Commands

```ps
dotnet --info
dotnet --help
```

```ps
dotnet new --list
dotnet new classlib --help
```

### Interop Project File

```xml
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <TargetFramework>NET472</TargetFramework>

  	<OutputPath>..\..\FoxPro\bin</OutputPath>
    <AppendTargetFrameworkToOutputPath>false</AppendTargetFrameworkToOutputPath>
  </PropertyGroup>

</Project>
```

### Interop.cs

```cs
using System;

namespace FoxProInterop
{
    public class Interop
    {
        public string DefaultName { get; set; } = "Ms. Anonymous";

        public string HelloWorld(string name)
        {
            if (string.IsNullOrEmpty(name))
                name = DefaultName;

            return "Hello World, " + name +
                   ". Time is: " + DateTime.Now.ToString("HH:mm:ss");
        }
    }
}    
```        

### Additional Methods


```csharp
public decimal Add(decimal number1, decimal number2)
{
    return number1 + number2;
}

public long Multiply(int number1, int number2)
{
    return (long) number1 * number2;
}
```

### Static Method (markdig)

```cs
dotnet add package markdig
```

```cs
public static string MarkdownToHtml(string markdownText)
{   
    var builder = new MarkdownPipelineBuilder();
    var pipeline = builder.Build();
    return Markdown.ToHtml(markdownText, pipeline, null);
}
```

### Refactored Markdown class

```csharp
using Markdig;

namespace FoxProInterop
{
    public class Markdown
    {
        // cached pipeline
        private static MarkdownPipeline Pipeline { get; set; }

        // static constructor runs EXACTLY ONCE on first access of a static member
        static Markdown()
        {
            var builder = new MarkdownPipelineBuilder()
                            .UseAdvancedExtensions()
                            .UseDiagrams()
                            .UseGenericAttributes();
        
            // create and cache the pipeline
            Pipeline = builder.Build();
        }

        public static string ToHtml(string markdownText)
        {   
            return Markdig.Markdown.ToHtml(markdownText, Pipeline, null);
        }
    }
}
```

### Debug Profile

```json
{
  "profiles": {
    "Profile 1": {
      "commandName": "Executable",
      "executablePath": "c:\\programs\\vfp9\\vfp9.exe",
      "workingDirectory": "C:\\wwapps\\Conf\\FoxProDotNet\\FoxPro"
    }
  }
}
```


### Additional Class Methods


```csharp
public Person GetPerson()
{
    var person = new Person();
    return person;
}

public bool SetPerson(Person person)
{
    DefaultPerson = person;
    return true;
}
```


### Person.cs

```csharp
using System.Collections.Generic;

namespace FoxProInterop
{
    public class Person
    {
        public Person()
        {
            var addr = new Address();
            Addresses.Add(addr);

            addr = new Address()
            {
                Street = "111 Somewhere Lane",
                City = "Doomsville",
                PostalCode = "22222",
                Type = AddressTypes.Shipping
            };
            Addresses.Add(addr);
        }

        public string Name { get; set; } = "Rick Strahl";
        public string Company { get; set; } = "West Wind";
        public string Email { get; set; } = "rickstrahl@bogus.com";
        public List<Address> Addresses { get; set; } = new List<Address>();
    }

    public class Address
    {
        private static int IdCounter = 0;   

        public int Id = ++IdCounter;
        
        public string Street { get; set; } = "101 Nowhere Lane";
        public string City { get; set; } = "Paia";
        public string PostalCode { get; set; } = "11111";

        public AddressTypes Type { get; set; } = AddressTypes.Billing;
    }

    public enum AddressTypes
    {
        Billing,
        Shipping
    }
}
```

### Unit Testing Class

```cs
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;

namespace FoxProInterop.Test
{
    [TestClass]
    public class FoxProInteropTests
    {
        [TestMethod]
        public void HelloWorldTest()
        {
            var inst = new Interop();
            var result = inst.HelloWorld("rick");
            

            Assert.IsNotNull(result);
            Console.WriteLine(result);
            Assert.IsTrue(result.Contains("rick"), "Doesn't match name");
        }

    }
}
```