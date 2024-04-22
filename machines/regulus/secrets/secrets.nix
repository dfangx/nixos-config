let
  cyrusng = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHZLaRFSC4nOKr2a8hAU/AzdOE7z5oZ4Y7sl/mN8trCV cyrusng@cyruspc";
in
  {
    "wgPrivate.age".publicKeys = [ cyrusng ];
    "wgPsk.age".publicKeys = [ cyrusng ];
  }
