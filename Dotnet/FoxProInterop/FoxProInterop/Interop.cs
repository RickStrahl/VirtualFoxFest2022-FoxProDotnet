using System;

namespace FoxProInterop
{
    public class Interop
    {
        public string DefaultName { get; set; } = "Mr. Anonymous";

        public string HelloWorld(string name)
        {
            if (string.IsNullOrEmpty(name))
                name = DefaultName;

            return "Hello World, " + name +
                   ". Time is: " +
                   DateTime.Now.ToString("HH:mm:ss");
        }

    }
}
