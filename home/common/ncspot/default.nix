_: {
  programs.ncspot = {
    enable = true;
    settings = {
      notify = true;
      bitrate = 320;
      shuffle = true;
      gapless = true;
      initial_screen = "library";
      use_nerdfont = true;
    };
  };
}
