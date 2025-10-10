{ lib, config, ... }:
{
  imports = [
    ../../../common/cpu/amd
    ../../../common/cpu/amd/pstate.nix
    ../../../common/gpu/amd
  ];

  boot.kernelParams =
    [
      # ref:
      # https://community.frame.work/t/screen-flickering-on-linux-kernel-6-12/62632/38
      # https://old.reddit.com/r/framework/comments/1goh7hc/anyone_else_get_this_screen_flickering_issue/
      # "amdgpu.dcdebugmask=0x400"
    ]
    # Workaround for SuspendThenHibernate: https://lore.kernel.org/linux-kernel/20231106162310.85711-1-mario.limonciello@amd.com/
    ++ lib.optionals (lib.versionOlder config.boot.kernelPackages.kernel.version "6.8") [
      "rtc_cmos.use_acpi_alarm=1"
    ];

  # AMD has better battery life with PPD over TLP:
  # https://community.frame.work/t/responded-amd-7040-sleep-states/38101/13
  services.power-profiles-daemon.enable = lib.mkDefault true;
}
