using System;
using FoxProInterop;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace InteropTests
{
    [TestClass]
    public class InteropTests
    {
        [TestMethod]
        public void HelloWorldTest()
        {
            var inst = new Interop();
            var result = inst.HelloWorld("ricsk");

            Assert.IsNotNull(result);
            Console.WriteLine(result);
            Assert.IsTrue(result.Contains("rick"), "Doesn't match name passed in.");
        }


    }
}