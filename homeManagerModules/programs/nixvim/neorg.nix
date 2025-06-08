{
  plugins.neorg = {
    enable = true;
    settings.load = {
      "core.defaults" = { __empty = null; };
      "core.dirman" = {
        config = {
          workspaces = {
            notes = "~/notes";
          };
        };
      };
      "core.esupports.metagen" = {
        config = {
          type = "auto";
        };
      };
      "core.concealer" = { __empty = null;  };
      "core.summary" = { __empty = null;  };
    };
  };
}
