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

### Additional Methods 1


```csharp
public decimal Add(decimal number1, decimal number2)
{
    return number1 + number2;
}

public long Multiply(int number1, int number2)
{
    return (long) number1 * number2;
}

public static int Subtract(int number1, int number2)
{
    return number1 - number2;
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

### Unit Testing Project



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
            var result = inst.HelloWorld("risck");
            

            Assert.IsNotNull(result);
            Console.WriteLine(result);
            Assert.IsTrue(result.Contains("rick"), "Doesn't match name");
        }

    }
}
```