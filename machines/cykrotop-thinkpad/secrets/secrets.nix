let
  cyrusng = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDk627qq4FFg7aeLh5GidLzo8nLDv0zC1lHBhR+ot75ASIJBFMH2o5Dy5+WujDtxQ4cFK4hZGZefllrR8s+r9vhXrTV0RGmMwYATbzjvZuir1GxoSSIaBGYWyrtHLHXye6W7aGpadLCSwLC9vRUdYfS2Nbd6PGAcs+cwRLba5N1xKzZhcIjRsyFfpUAkD2uP29yiWBwlP28Dd9HrWcSjqN7japXbjHXqeHKBYyQd0zviXEnmX/JyEUN2uJCt5qe5twn+zoScbRO7xmr6Zw5VWgPx30tdwLPTSstXeoTIX3QVd026zVOSRCeYyoYzH7mtIqJgVtVMg1xNg9i7L68+nq73ch35tjq57HI6ObLrrE6nYGOj30lcblNBA+GqTt7IKu0IZvoaJsqRp83TNFBcJ+X+i+dvMGK3QzJ70J3Q5u+wz0UfqBQqCGpim1gsqnHE5TMxTSOttgWHss9x0PlfGYixYoqLOjZ+sNeAh2aCBgaU7MsgR6oMjtit+MNQ1zZkGU=";
  system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHITm/HuaS1BeaUaPSjLQliw2HqmuDe9IF8hd9i1P0zQ";
in
  {
    "wgPrivate.age".publicKeys = [ cyrusng system ];
    "wgPsk.age".publicKeys = [ cyrusng system ];
  }
