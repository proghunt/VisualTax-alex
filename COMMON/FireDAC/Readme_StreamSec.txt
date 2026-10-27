FireDAC includes encryption schemes AES and AES-CTR contributed by StreamSec. (c) 2010-2013 StreamSec(tm)

The KDF, CTR-mode, CBC-MAC and the PRNG are all implemented in accordance with various NIST standards.

* The "aes-nnn" schemes are provided for IND-CCA2 security at the "page" level, with certain entailed limitations.
* The "aes-ctr-nnn" schemes are provided for IND-CPA security, with similar, but more relaxed limitations.
* The "aes-ecb-nnn" schemes are provided for backwards compatibility only.

For more information regarding StreamSec, please visit http://www.streamsec.com/

