using Microsoft.VisualStudio.TestTools.UnitTesting;
using FoxProInterop;
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
            Assert.IsTrue(result.Contains("rick"), "Doesn't match name passed in.");
        }

        [TestMethod]
        public void MarkdownTest()
        {
            var markdown = "This is **Markdown**.";

            var result = Markdown.ToHtml(markdown);

            Assert.IsTrue(result.Contains("<strong>"), "markdown expansion failed.");
            Console.WriteLine(result);
        }
    }
}
