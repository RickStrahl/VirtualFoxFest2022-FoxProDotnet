using System;
using Markdig;

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

        public decimal Add(decimal num1, decimal num2)
        {
            return num1 + num2;
        }

        public long Multiply(int num1, int num2)
        {
            return num1 * num2;
        }


        public static string MarkdownToHtml(string markdownText)
        {   
            var builder = new MarkdownPipelineBuilder();
            var pipeline = builder.Build();
            return Markdig.Markdown.ToHtml(markdownText, pipeline, null);
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
