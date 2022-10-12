using System;
using System.IO;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using wwEncryption;

namespace wwEncryption.Test
{
    [TestClass]
    public class HashTests
    {
        private string OrignalValue { get; set; } = "A very approachable string with upper ASCII chars: ƒ¢ªÑº!";
    

    [TestMethod]
        public void SHA256HashTestNoSalt()
        {
            string encoded = EncryptionUtils.ComputeHash(OrignalValue, "SHA256", "");
            Assert.IsNotNull(encoded);

            Console.WriteLine(encoded);

        }
    }
}