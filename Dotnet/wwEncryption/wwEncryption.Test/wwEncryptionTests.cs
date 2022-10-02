using Microsoft.VisualStudio.TestTools.UnitTesting;
using wwDotnetBridge;

namespace wwEncryption.Test
{
    [TestClass]
    public class wwEncryptionTests
    {
        string encKey = "5aw#sdd@saddasd$adsddaws&";

        [TestMethod]
        public void EncryptStringTest()
        {
            string origValue = "SuperSeekrit#9";

            string encoded = EncryptionUtils.EncryptString(origValue, encKey);

            Assert.IsNotNull(encoded);

            string decoded = EncryptionUtils.DecryptString(encoded, encKey);

            Assert.AreEqual(origValue, encoded);
        }

   }
}