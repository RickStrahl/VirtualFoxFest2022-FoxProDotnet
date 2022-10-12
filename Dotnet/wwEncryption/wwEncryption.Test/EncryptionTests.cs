using System;
using System.IO;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using wwEncryption;

namespace wwEncryption.Test
{
    [TestClass]
    public class EncryptionTests
    {
        public static string OutputLocation = Path.Combine(Path.GetDirectoryName(typeof(EncryptionTests).Assembly.Location));

        string encKey = "45fr1231%3210k5w";

        

        [TestMethod]
        public void EncryptStringTest()
        {
            string origValue = "SuperSeekrit#9";

            string encoded = EncryptionUtils.EncryptString(origValue, encKey);
            Console.WriteLine($"Encoded: {encoded}");

            Assert.IsNotNull(encoded);

            string decoded = EncryptionUtils.DecryptString(encoded, encKey);
            
            Console.WriteLine($"Decoded: {decoded}");

            Assert.AreEqual(origValue, decoded);
        }


        [TestMethod]
        public void EncryptDecryptTripleDESTest()
        {
            string data = "This is a short string that we want to encrypt";


            // 32 bytes
            // string key = "12345678901234567890123456789012";

            // 24 bytes 
            string key = "123456789012345678901234";

            var encrypted = EncryptionUtils.EncryptString(data, key, true, "TripleDES", "ECB", null, null, null);
            Console.WriteLine(encrypted);

            var decrypted = EncryptionUtils.DecryptString(encrypted, key, true, "TripleDES", "ECB", null, null, null);

            Assert.AreEqual(data, decrypted);
        }

        [TestMethod]
        public void EncryptDecryptAESTest()
        {
            string data = "This is a short string that we want to encrypt";

            // 24 byte key
            string key = "123456789012345678901234";
            // 16 byte IV
            string iv = "1234567890123456";

            var encrypted = EncryptionUtils.EncryptString(data, key, true, "AES", "ECB", null, null, iv);
            Console.WriteLine(encrypted);

            var decrypted = EncryptionUtils.DecryptString(encrypted, key, true, "AES", "ECB", null, null, iv);

            Assert.AreEqual(data, decrypted);
        }
    }
}