using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Security.Cryptography;
using System.Text;

namespace wwEncryption
{
    /// <summary>
    /// Class that provides a number of encryption utilities
    /// </summary>
    public static class EncryptionUtils
    {
        /// <summary>
        /// Replace this value with some unique key of your own
        /// Best set this in your App start up in a Static constructor
        ///
        /// For TripleDES this key has to be a multiple of 8 chars long
        /// </summary>
        public static string EncryptionKey = "4a3f131c";

        /// <summary>
        /// Determines whether data is returned as BinHex or Base64 (default)
        /// </summary>
        public static bool UseBinHex = false;


        /// <summary>
        /// Two way encryption provider for `Encrypt()`\`Decrypt` methods
        /// Values: TripleDES, AES
        /// </summary>
        public static string EncryptionProvider = "TripleDES";    // "AES"


        /// <summary>
        /// If true hashes the passed encryption key for `Encrypt()` \ `Decrypt()` using MD5.
        /// </summary>
        //public static bool EncryptionUseMd5EncryptionKey = true;

        public static string EncryptionKeyHashAlgorithm = "MD5";

        #region Two-way Encryption

        /// <summary>
        /// Encrypts a string using Triple DES encryption with a two way encryption key.String is returned as Base64 encoded value
        /// rather than binary.
        /// </summary>
        /// <param name="inputString"></param>
        /// <param name="encryptionKey"></param>
        /// <param name="useBinHex">BinHex rather than base64 if true</param>
        /// <param name="provider">TripleDES, AES</param>
        /// <param name="cipherMode">ECB, CBC, CTS, OFB</param>
        /// <param name="encryptionKeyHashAlgorithm">Optional key hash algorithm. Null or empty for none</param>
        /// <param name="encryptionKeySalt">Optional key hash salt</param>
        /// <param name="ivKey">Optional IV vector bytes as string for AES encryption</param>
        /// <returns></returns>
        public static string EncryptString(string inputString, string encryptionKey,
                                           bool useBinHex = false,
                                           string provider = null, string cipherMode = null,
                                           string encryptionKeyHashAlgorithm = null,
                                           string encryptionKeySalt = null, string ivKey = null)
        {
            if (useBinHex)
                return BinaryToBinHex(EncryptBytes(Encoding.UTF8.GetBytes(inputString),
                    encryptionKey, provider, cipherMode, encryptionKeyHashAlgorithm,
                    encryptionKeySalt, ivKey));

            return Convert.ToBase64String(EncryptBytes(Encoding.UTF8.GetBytes(inputString),
                    encryptionKey, provider, cipherMode,
                    encryptionKeyHashAlgorithm, encryptionKeySalt, ivKey));
        }

        /// <summary>
        /// Encodes a stream of bytes using DES encryption with a pass key. Lowest level method that 
        /// handles all work.
        /// </summary>
        /// <param name="inputBytes"></param>
        /// <param name="encryptionKey"></param>
        /// <param name="provider">TripleDES, AES</param>
        /// <param name="cipherMode">ECB (16 bytes), CBC (32 bytes), CTS, OFB   </param>
        /// <param name="encryptionKeyHashAlgorithm">Optional key hash algorithm. Null or empty for none</param>
        /// <param name="encryptionKeySalt">Optional key hash salt</param>
        /// <param name="ivKey">Optional IV vector bytes as a string for AES encryption</param>
        /// <returns></returns>
        public static byte[] EncryptBytes(byte[] inputBytes, string encryptionKey, string provider = null,
                      string cipherMode = null, string encryptionKeyHashAlgorithm = null,
                      string encryptionKeySalt = null, string ivKey = null)
        {
            if (encryptionKey == null)
                encryptionKey = EncryptionUtils.EncryptionKey;

            SymmetricAlgorithm cryptoProvider;

            if (string.IsNullOrEmpty(provider))
                provider = EncryptionProvider;

            if (provider == "AES")
            {
                if (string.IsNullOrEmpty(ivKey))
                    throw new ArgumentException("You ssshave to pass an IV Key with AES encryption");
                cryptoProvider = new AesCryptoServiceProvider();
            }
            else
            {
                cryptoProvider = new TripleDESCryptoServiceProvider();
            }

            cryptoProvider.Padding = PaddingMode.PKCS7;

            if (!string.IsNullOrEmpty(ivKey))
                cryptoProvider.IV = Encoding.ASCII.GetBytes(ivKey);

            if (string.IsNullOrEmpty(cipherMode))
                cipherMode = "ECB";
            cipherMode = cipherMode.ToUpper();

            if (!Enum.TryParse<CipherMode>(cipherMode, out CipherMode mode))
                return null;

            cryptoProvider.Mode = mode;

            if (!string.IsNullOrEmpty(encryptionKeyHashAlgorithm))
            {
                var salt = string.IsNullOrEmpty(encryptionKeySalt) ? null : Encoding.UTF8.GetBytes(encryptionKey);
                cryptoProvider.Key = ComputeHashBytes(encryptionKey, encryptionKeyHashAlgorithm, salt);
            }
            else
            {
                // key length has to match - typically 32 bytes/chars
                cryptoProvider.Key = Encoding.UTF8.GetBytes(encryptionKey);
            }

            ICryptoTransform transform = cryptoProvider.CreateEncryptor();


            byte[] Buffer = inputBytes;
            return transform.TransformFinalBlock(Buffer, 0, Buffer.Length);
        }

        /// <summary>
        /// Encrypts a string into bytes using DES encryption with a Passkey. 
        /// </summary>
        /// <param name="inputString"></param>
        /// <param name="encryptionKey"></param>
        /// <param name="provider">TripleDES, AES</param>
        /// <param name="cipherMode">ECB, CBC, CTS, OFB</param>
        /// <param name="encryptionKeyHashAlgorithm">Optional key hash algorith. Null or empty for none</param>
        /// <param name="encryptionKeySalt">Optional key hash salt</param>
        /// <param name="ivKey">Optional IV vector bytes as a string for AES encryption</param>
        /// <returns></returns>
        public static byte[] EncryptBytes(string inputString, string encryptionKey, string provider = null, string cipherMode = null, string encryptionKeyHashAlgorithm = null, string encryptionKeySalt = null, string ivKey = null)
        {
            return EncryptBytes(Encoding.UTF8.GetBytes(inputString), encryptionKey, provider,
                                cipherMode, encryptionKeyHashAlgorithm,
                                encryptionKeySalt, ivKey);
        }


        /// <summary>
        /// Decrypts a Byte array from DES with an Encryption Key.
        /// </summary>
        /// <param name="decryptBuffer"></param>
        /// <param name="encryptionKey"></param>
        /// <param name="provider">TRIPEDES, AES</param>
        /// <param name="cipherMode">ECB, CBC, CTS, OFB</param>
        /// <param name="encryptionKeyHashAlgorithm">Optional key hash algorith. Null or empty for none</param>
        /// <param name="encryptionKeySalt">Optional key hash salt</param>
        /// <param name="ivKey">Optional IV vector bytes as a string for AES encryption</param>
        /// <returns></returns>
        public static byte[] DecryptBytes(byte[] decryptBuffer, string encryptionKey, string provider,
                            string cipherMode = null, string encryptionKeyHashAlgorithm = null,
                            string encryptionKeySalt = null, string ivKey = null)
        {
            if (decryptBuffer == null || decryptBuffer.Length == 0)
                return null;

            if (encryptionKey == null)
                encryptionKey = EncryptionUtils.EncryptionKey;

            SymmetricAlgorithm cryptoProvider;

            if (string.IsNullOrEmpty(provider))
                provider = EncryptionProvider;

            if (provider == "AES")
            {
                if (string.IsNullOrEmpty(ivKey))
                    throw new ArgumentException("You have to pass an IV Key with AES encryption");

                cryptoProvider = new AesCryptoServiceProvider();
            }
            else
                cryptoProvider = new TripleDESCryptoServiceProvider();

            cryptoProvider.Padding = PaddingMode.PKCS7;
            if (!string.IsNullOrEmpty(ivKey))
                cryptoProvider.IV = Encoding.ASCII.GetBytes(ivKey);

            if (string.IsNullOrEmpty(cipherMode))
                cipherMode = "ECB";
            cipherMode = cipherMode.ToUpper();

            if (!Enum.TryParse<CipherMode>(cipherMode, out CipherMode mode))
                return null;

            cryptoProvider.Mode = mode;

            if (!string.IsNullOrEmpty(encryptionKeyHashAlgorithm))
            {
                var salt = string.IsNullOrEmpty(encryptionKeySalt) ? null : Encoding.UTF8.GetBytes(encryptionKey);
                cryptoProvider.Key = ComputeHashBytes(encryptionKey, encryptionKeyHashAlgorithm, salt);
            }
            else
            {
                // key length has to match - typically 32 bytes/chars
                cryptoProvider.Key = Encoding.UTF8.GetBytes(encryptionKey);
            }

            ICryptoTransform transform = cryptoProvider.CreateDecryptor();

            return transform.TransformFinalBlock(decryptBuffer, 0, decryptBuffer.Length);
        }

        public static byte[] DecryptBytes(string decryptString, bool useBinHex = false, string encryptionKey = null,
                                        string provider = null, string cipherMode = null,
                                        string encryptionKeyHashAlgorithm = null, string encryptionKeySalt = null,
                                        string ivKey = null)
        {
            if (useBinHex)
                return DecryptBytes(BinHexToBinary(decryptString), encryptionKey, provider,
                    cipherMode, encryptionKeyHashAlgorithm,
                    encryptionKeySalt, ivKey);

            return DecryptBytes(Convert.FromBase64String(decryptString), encryptionKey,
                provider, cipherMode, encryptionKeyHashAlgorithm,
                encryptionKeySalt, ivKey);
        }

        /// <summary>
        /// Decrypts a string using DES encryption and a pass key that was used for 
        /// encryption.
        /// <seealso>Class wwEncrypt</seealso>
        /// </summary>
        /// <param name="decryptString"></param>
        /// <param name="encryptionKey"></param>
        /// <param name="useBinHex">BinHex if true, base64 if false</param>
        /// <param name="provider">TRIPEDES, AES</param>
        /// <param name="cipherMode">ECB, CBC, CTS, OFB</param>
        /// <param name="encryptionKeyHashAlgorithm">Optional key hash algorith. Null or empty for none</param>
        /// <param name="encryptionKeySalt">Optional key hash salt</param>
        /// <returns>String</returns>
        public static string DecryptString(string decryptString, string encryptionKey, bool useBinHex = false, string provider = null, string cipherMode = null, string encryptionKeyHashAlgorithm = null, string encryptionKeySalt = null, string ivKey = null)
        {
            try
            {
                if (useBinHex)
                    return Encoding.UTF8.GetString(DecryptBytes(BinHexToBinary(decryptString), encryptionKey, provider, cipherMode, encryptionKeyHashAlgorithm, encryptionKeySalt, ivKey));

                return Encoding.UTF8.GetString(DecryptBytes(Convert.FromBase64String(decryptString), encryptionKey, provider, cipherMode, encryptionKeyHashAlgorithm, encryptionKeySalt, ivKey));
            }
            catch
            {
                return string.Empty;
            } // Probably not encoded
        }

        #endregion


        #region Hashes

        /// <summary>
        /// Generates a hash for the given plain text value and returns a
        /// base64-encoded result. Before the hash is computed, a random salt
        /// is generated and appended to the plain text. This salt is stored at
        /// the end of the hash value, so it can be used later for hash
        /// verification.
        /// </summary>
        /// <param name="plainText">
        /// Plaintext value to be hashed. 
        /// </param>
        /// <param name="hashAlgorithm">
        /// Name of the hash algorithm. Allowed values are: "MD5", "SHA1",
        /// "SHA256", "SHA384", and "SHA512", and "HMACSHA1","HMACSHA256",
        /// "HMACSHA512","HMACMD5" (if any other value is specified MD5 
        /// hashing algorithm will be used). This value is case-insensitive.
        /// </param>
        /// <param name="salt">
        /// Optional salt string to apply to the text before hashing. If not passed the
        /// raw encoding is used.
        /// For HMAC this will be the salt passed to the HMAC parser.
        /// </param>
        /// <returns>
        /// Hash value formatted as a base64-encoded string.
        /// </returns>
        public static string ComputeHash(string plainText,
            string hashAlgorithm,
            string salt = "")
        {
            byte[] saltBytes;
            if (string.IsNullOrEmpty(salt))
                saltBytes = null;
            else
                saltBytes = Encoding.UTF8.GetBytes(salt);

            return ComputeHash(plainText, hashAlgorithm, saltBytes);
        }

        /// <summary>
        /// Generates a hash for the given plain text value and returns a
        /// base64-encoded result. Before the hash is computed, a random salt
        /// is generated and appended to the plain text. This salt is stored at
        /// the end of the hash value, so it can be used later for hash
        /// verification.
        /// </summary>
        /// <param name="plainText">
        /// Plaintext value to be hashed. 
        /// </param>
        /// <param name="hashAlgorithm">
        /// Name of the hash algorithm. Allowed values are: "MD5", "SHA1",
        /// "SHA256", "SHA384", and "SHA512", and "HMACSHA1","HMACSHA256",
        /// "HMACSHA512","HMACMD5" (if any other value is specified MD5 
        /// hashing algorithm will be used). This value is case-insensitive.
        /// </param>
        /// <param name="saltBytes">
        /// Optional salt bytes to apply to the hash. If not passed the
        /// raw encoding is used.
        /// </param>
        /// <returns>
        /// Hash value formatted as a base64-encoded string.
        /// </returns>
        public static string ComputeHash(string plainText,
                                         string hashAlgorithm,
                                         byte[] saltBytes = null)
        {
            if (string.IsNullOrEmpty(plainText))
                return plainText;

            var hashBytes = ComputeHashBytes(plainText, hashAlgorithm, saltBytes);

            if (UseBinHex)
                return BinaryToBinHex(hashBytes);

            return Convert.ToBase64String(hashBytes);
        }


        public static byte[] ComputeHashBytes(string plainText,
            string hashAlgorithm,
            byte[] saltBytes = null)
        {
            if (string.IsNullOrEmpty(plainText))
                return null;

            // Convert plain text into a byte array.
            byte[] plainTextBytes = Encoding.UTF8.GetBytes(plainText);
            byte[] plainTextWithSaltBytes;

            if (hashAlgorithm.ToLower().StartsWith("hmac") &&
                (saltBytes == null || saltBytes.Length == 0))
                throw new ArgumentException("HMAC hash algorithms require a salt value.");

            if (saltBytes != null && !hashAlgorithm.ToLower().StartsWith("hmac"))
            {
                //// Allocate array, which will hold plain text and salt.
                plainTextWithSaltBytes =
                    new byte[plainTextBytes.Length + saltBytes.Length];

                // Copy plain text bytes into resulting array.
                for (int i = 0; i < plainTextBytes.Length; i++)
                    plainTextWithSaltBytes[i] = plainTextBytes[i];

                // Append salt bytes to the resulting array.
                for (int i = 0; i < saltBytes.Length; i++)
                    plainTextWithSaltBytes[plainTextBytes.Length + i] = saltBytes[i];
            }
            else
                plainTextWithSaltBytes = plainTextBytes;

            HashAlgorithm hash;

            // Make sure hashing algorithm name is specified.
            if (string.IsNullOrEmpty(hashAlgorithm))
                hashAlgorithm = "MD5";

            // Initialize appropriate hashing algorithm class.
            switch (hashAlgorithm.ToUpper())
            {
                case "SHA1":
                    hash = new SHA1Managed();
                    break;
                case "SHA256":
                    hash = new SHA256Managed();
                    break;
                case "SHA384":
                    hash = new SHA384Managed();
                    break;
                case "SHA512":
                    hash = new SHA512Managed();
                    break;
                case "HMACSHA1":
                    hash = new HMACSHA1(saltBytes);
                    break;
                case "HMACSHA256":
                    hash = new HMACSHA256(saltBytes);
                    break;
                case "HMACSHA384":
                    hash = new HMACSHA384(saltBytes);
                    break;
                case "HMACSHA512":
                    hash = new HMACSHA512(saltBytes);
                    break;
                case "HMACMD5":
                    hash = new HMACMD5(saltBytes);
                    break;
                case "MD5":
                    hash = MD5.Create();
                    break;
                default:
                    // default to MD5
                    throw new ArgumentException("Invalid hash algorithm specified: " + hashAlgorithm);
            }

            // Compute hash value of our plain text with appended salt.
            byte[] hashBytes = hash.ComputeHash(plainTextWithSaltBytes);

            return hashBytes;
        }


        #endregion

        #region Gzip

        /// <summary>
        /// GZip encodes a memory buffer to a compressed memory buffer
        /// </summary>
        /// <param name="buffer"></param>
        /// <returns></returns>
        public static byte[] GZipMemory(byte[] buffer)
        {
            MemoryStream ms = new MemoryStream();

            GZipStream gZip = new GZipStream(ms, CompressionMode.Compress);

            gZip.Write(buffer, 0, buffer.Length);
            gZip.Close();

            byte[] result = ms.ToArray();
            ms.Close();

            return result;
        }

        /// <summary>
        /// Encodes a string to a gzip compressed memory buffer
        /// </summary>
        /// <param name="Input"></param>
        /// <returns></returns>
        public static byte[] GZipMemory(string Input)
        {
            return GZipMemory(Encoding.UTF8.GetBytes(Input));
        }

        /// <summary>
        /// Encodes a file to a gzip memory buffer
        /// </summary>
        /// <param name="Filename"></param>
        /// <param name="IsFile"></param>
        /// <returns></returns>
        public static byte[] GZipMemory(string Filename, bool IsFile)
        {
            string InputFile = Filename;
            byte[] Buffer = File.ReadAllBytes(Filename);
            return GZipMemory(Buffer);
        }

        /// <summary>
        /// Encodes one file to another file that is gzip compressed.
        /// File is overwritten if it exists and not locked.
        /// </summary>
        /// <param name="Filename"></param>
        /// <param name="OutputFile"></param>
        /// <returns></returns>
        public static bool GZipFile(string Filename, string OutputFile)
        {
            string InputFile = Filename;
            byte[] Buffer = File.ReadAllBytes(Filename);
            FileStream fs = new FileStream(OutputFile, FileMode.OpenOrCreate, FileAccess.Write);
            GZipStream GZip = new GZipStream(fs, CompressionMode.Compress);
            GZip.Write(Buffer, 0, Buffer.Length);
            GZip.Close();
            fs.Close();

            return true;
        }

        #endregion

        #region CheckSum

        /// <summary>
        /// Creates an SHA256 or MD5 checksum of a file
        /// </summary>
        /// <param name="file"></param>
        /// <param name="mode">SHA256,MD5</param>
        /// <returns></returns>
        public static string GetChecksumFromFile(string file, string mode)
        {
            using (FileStream stream = File.OpenRead(file))
            {
                if (mode == "SHA256")
                {
                    var sha = new SHA256Managed();
                    byte[] checksum = sha.ComputeHash(stream);

                    if (UseBinHex)
                        return BinaryToBinHex(checksum);

                    return Convert.ToBase64String(checksum);
                }
                if (mode == "MD5")
                {
                    var md = new MD5CryptoServiceProvider();
                    byte[] checkSum = md.ComputeHash(stream);

                    if (UseBinHex)
                        return BinaryToBinHex(checkSum);

                    return Convert.ToBase64String(checkSum);
                }
            }

            return null;
        }

        /// <summary>
        /// Create a SHA256 or MD5 checksum from a bunch of bytes
        /// </summary>
        /// <param name="fileData"></param>
        /// <param name="mode">SHA256,MD5</param>
        /// <returns></returns>
        public static string GetChecksumFromBytes(byte[] fileData, string mode = "SHA256")
        {
            using (MemoryStream stream = new MemoryStream(fileData))
            {
                if (mode == "SHA256")
                {
                    var sha = new SHA256Managed();
                    byte[] checksum = sha.ComputeHash(stream);

                    if (UseBinHex)
                        return BinaryToBinHex(checksum);

                    return Convert.ToBase64String(checksum);
                }
                if (mode == "MD5")
                {
                    var md = new MD5CryptoServiceProvider();
                    byte[] checkSum = md.ComputeHash(stream);

                    if (UseBinHex)
                        return BinaryToBinHex(checkSum);

                    return Convert.ToBase64String(checkSum);
                }
            }

            return null;
        }

        #endregion

        #region BinHex Helpers

        /// <summary>
        /// Converts a byte array into a BinHex string.
        /// Example: 01552233 
        /// where the numbers are packed
        /// byte values.
        /// </summary>
        /// <param name="data">Raw data to send</param>
        /// <returns>string or null if input is null</returns>
        public static string BinaryToBinHex(byte[] data)
        {
            if (data == null)
                return null;

            StringBuilder sb = new StringBuilder(data.Length * 2);
            foreach (byte val in data)
            {
                sb.AppendFormat("{0:x2}", val);
            }
            return sb.ToString().ToUpper();
        }


        /// <summary>
        /// Turns a BinHex string that contains raw byte values
        /// into a byte array
        /// </summary>
        /// <param name="hex">BinHex string (just two byte hex digits strung together)</param>
        /// <returns></returns>
        public static byte[] BinHexToBinary(string hex)
        {
            int offset = hex.StartsWith("0x") ? 2 : 0;
            if ((hex.Length % 2) != 0)
                throw new ArgumentException("Invalid String Length");

            byte[] ret = new byte[(hex.Length - offset) / 2];

            for (int i = 0; i < ret.Length; i++)
            {
                ret[i] = (byte)((ParseHexChar(hex[offset]) << 4)
                                 | ParseHexChar(hex[offset + 1]));
                offset += 2;
            }
            return ret;
        }

        static int ParseHexChar(char c)
        {
            if (c >= '0' && c <= '9')
                return c - '0';
            if (c >= 'A' && c <= 'F')
                return c - 'A' + 10;
            if (c >= 'a' && c <= 'f')
                return c - 'a' + 10;

            throw new ArgumentException("Invalid character");
        }

        #endregion
    }

}
