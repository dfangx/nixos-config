let
  cyrusng = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCSNh8JmuD9AtS+xy60Mx0VkPgeLY754LjCudmM6+gUTgLbSXIekg9TjTBlN3uTOARzQESm4hD4A5+J+iDF/cXZXQ3E5qI0OxxQMgvvOdKWqjai0ioH5GSrQdNNkcCWQ1WvaI4/VNs7bs61mUss0Rv2GW6FBmSugVi/SbyM4+3N83cn8j3hXTNIOxGvZ4qgLKnfvbzyRDleZ1HThHTut/ehgkfhbVjfm9Y+9ax9PGJKWzF4mnNdZyBRKr2UDb5+SuISnKKoR+jvDmbdUbnqaxSto26gsqQHi99vtWuQcI/4SCg6nZkUiSfbzYp1ow754N3heWaWCekIfr0ZPN8eJI4Ctox925VKa4z9y0NcScdrMqsvGx9BSknkoJ9Ohpr5S3bA6tkzsOdq0PXw8w9jFbty+FFsYrSU8lPO2z8IIkG34LIKBfZnm0EDGFnc3oeI8p1d4Xm8IBbj2eZrTYkaeoV5NobQ0waJq+jbTssDHnevYQwCBNeFK+PxmE1mjJO+QZk=";
  system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJCS1xNCgp8R4XNSPOWvE4IO+zopznMLCIjy71ufYW+T";
in
  {
    "nextcloud.age".publicKeys = [ cyrusng system ];
    "wireguard.age".publicKeys = [ cyrusng system ];
    "duckdns.age".publicKeys = [ cyrusng system ];
    "wgPskPeer0.age".publicKeys = [ cyrusng system ];
    "wgPskPeer1.age".publicKeys = [ cyrusng system ];
    "wgPskPeer2.age".publicKeys = [ cyrusng system ];
    "wgPskPeer3.age".publicKeys = [ cyrusng system ];
    "wgPskPeer4.age".publicKeys = [ cyrusng system ];
    "grafanaAdmin.age".publicKeys = [ cyrusng system ];
    "fireflyIII.age".publicKeys = [ cyrusng system ];
    "laravel.age".publicKeys = [ cyrusng system ];
    "monica.age".publicKeys = [ cyrusng system ];
    "radicale.age".publicKeys = [ cyrusng system ];
    "restic.age".publicKeys = [ cyrusng system ];
    "keycloak.age".publicKeys = [ cyrusng system ];
    "authentik.age".publicKeys = [ cyrusng system ];
    "authentik-ldap.age".publicKeys = [ cyrusng system ];
  }
