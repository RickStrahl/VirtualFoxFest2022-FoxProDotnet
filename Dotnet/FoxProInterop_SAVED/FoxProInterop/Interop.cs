using System;
using System.Security.Cryptography.X509Certificates;

namespace FoxProInterop
{
    public class Interop
    {
        public string DefaultName { get; set; } = "Jane C. Anonymous";

        public Person DefaultPerson { get; set; }

        
        public string HelloWorld(string name)
        {
            if (string.IsNullOrEmpty(name))
                name = DefaultName;

            return "Hello World, " + name +
                   ". Time is: " +
                   DateTime.Now.ToString("HH:mm:ss");
        }

        public decimal Add(decimal number1, decimal number2)
        {
            return number1 + number2;
        }

        public int Multiply(int number1, int number2)
        {
            return (long)number1 * number2;
        }
        
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
    }

}
