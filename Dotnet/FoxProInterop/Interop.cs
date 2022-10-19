using System;

namespace FoxProInterop
{
    public class Interop
    {
        public Person DefaultPerson { get; set; } = new Person();


        public string HelloWorld(string name) 
        {
            if (string.IsNullOrEmpty(name))
                name = "n/a";

            string result = "Goodbye cruel World " + name +
                            ". Time is: " +
                            DateTime.Now.ToString("HH:mm:ss");

            return result;
        }

        public int Add(int num1, int num2)
        {
            return num1 + num2;
        }

        public decimal Multiply(decimal num1, decimal num2)
        {
            return num1 * num2;
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
