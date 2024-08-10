{ ... }:
{
  services.pipewire = {
    enable = true;

    audio.enable = true;

    jack.enable = true;
    pulse.enable = true;

    wireplumber.enable = true;
  };
}
