using System;

namespace FoxProInterop
{
    public class Interop
    {        

        public string HelloWorld(string name) {
            return "Hello World, " + name +
                   ". Time is: " + 
                   DateTime.Now.ToString("HH:mm:ss");
        }        

    }
}
