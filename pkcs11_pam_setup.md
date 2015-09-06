## Smartcard integration with PAM
This has been tested on Ubuntu 14.04 LTS with a Feitian PKI (FTCOS/PK-01C) smartcard and a generic USB smartcard reader.

reference: http://ubuntuforums.org/showthread.php?t=1557180

### The general steps:
* Erase and initialize card
* Create public/private key pair on smartcard
* Generate X.509 certificate with our email address as a subjectAltName value
* Configure PAM to use the PKCS#11 module

### The details:
1. Install smartcard middleware and libraries

    ```sudo apt-get install pcscd opensc libengine-pkcs11-openssl libpam-pkcs11```

2. Erase smartcard

    ```pkcs15-init -E```
    
3. Initialize smartcard

    ```pkcs15-init --create-pkcs15 -p pkcs15+onepin --pin 1234 --puk 4321```
    
4. Create public/private key pair on smartcard

    ```pkcs15-init -G rsa/2048 -i 01 -a 01 -u sign --pin 1234```

5. Generate a self-signed certificate

    ```openssl req -config openssl_pkcs11.conf -new -x509 -days 90 -keyform engine -engine pkcs11 -key slot_1-id_01 -out ~/my_cert.pem```

6. Store the cert on your card

    ```pkcs15-init -X ~/my_cert.pem -i 01 -a 01 --format pem```

7. Configure the pkcs11 pam module
    
    ```sudo mkdir -p /etc/pam_pkcs11/{,cacerts,crls}```

    ```zcat /usr/share/doc/libpam-pkcs11/examples/pam_pkcs11.conf.example.gz | sudo tee /etc/pam_pkcs11/pam_pkcs11.conf```
    
    ```sudo cp ~/my_cert.pem /etc/pam_pkcs11/cacerts/```
    
    ```cd /etc/pam_pkcs11/cacerts && sudo pkcs11_make_hash_link```
    
    ```echo "me@website.example -> userid" | sudo tee /etc/pam_pkcs11/mail_mapping```
    
    Edit the "module = /usr/lib/opensc-pkcs11.so" line of /etc/pam_pkcs11/pam_pkcs11.conf to point to the right location of the module on your system

8. Configure your PAM modules
    For example: add ```auth sufficient pam_pkcs11.so``` to the top of /etc/pam.d/common-auth

