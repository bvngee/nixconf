# Install aic8800 USB kernel driver, for AX900 Wi-Fi USB Adapter (thanks Luca).
# https://github.com/NixOS/nixpkgs/pull/443520
# https://github.com/Cryolitia/nixos-config/blob/de29451e2f2d1460e6686e4151ed7845ecc6daac/hosts/q6a/common.nix#L34-L49
#
# This will be deleted as soon as I get rid of and don't have a use for this
# device. What a mess of a driver lmao
#
# Help with the patch came from: https://claude.ai/share/dd643819-ef80-4346-b3a8-81bed33acca8
{ pkgs, inputs, config, ... }:
let
  aic8800-firmware = (pkgs.callPackage
    "${inputs.nixpkgs-aic8800}/pkgs/by-name/ai/aic8800-firmware/package.nix"
    { }).overrideAttrs {
    version = "4.0+git20250410.b99ca8b6-5-0deepin1";
    src = pkgs.fetchFromGitHub {
      owner = "deepin-community";
      repo = "aic8800";
      rev = "4.0+git20250410.b99ca8b6-5-0deepin1";
      hash = "sha256-KckJo0883cc2SRhuJYEU5CZ3ffR6G67z54G2LuuvIz4=";
    };
  };

  # This ridiculous patch adds detection for my specific device. For some reason,
  # once it's modeswitched into WiFi dongle mode, it pops up with very
  # non-standard USB VendorID and ProductID specific to Tenda, which this driver
  # doesn't have by default.
  aic8800-usb = (config.boot.kernelPackages.callPackage
    "${inputs.nixpkgs-aic8800}/pkgs/os-specific/linux/aic8800/default.nix"
    { aic8800-firmware = aic8800-firmware; }
  ).usb.overrideAttrs {
    patches = [
      (builtins.toFile "patch_enable_2604_001f.txt" ''
        diff --git a/src/USB/aic8800/aic8800_fdrv/aicwf_usb.c b/src/USB/aic8800/aic8800_fdrv/aicwf_usb.c
        index 014886c..b9143e8 100644
        --- a/src/USB/aic8800/aic8800_fdrv/aicwf_usb.c
        +++ b/src/USB/aic8800/aic8800_fdrv/aicwf_usb.c
        @@ -2374,7 +2374,10 @@ static int aicwf_usb_chipmatch(struct aic_usb_dev *usb_dev, u16_l vid, u16_l pid
                 }
                 AICWFDBG(LOGINFO, "%s USE AIC8800D89X2\r\n", __func__);
                 return 0;
        -    }else{
        +    }else if(pid == 0x001f) {
        +	usb_dev->chipid = PRODUCT_ID_AIC8800D81;
        +	return 0;
        +    } else {
         		return -1;
         	}
         }
        @@ -2636,6 +2639,7 @@ static struct usb_device_id aicwf_usb_id_table[] = {
             {USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_AIC_V2, USB_PRODUCT_ID_AIC8800D81X2, 0xff, 0xff, 0xff)},
             {USB_DEVICE(USB_VENDOR_ID_AIC_V2, USB_PRODUCT_ID_AIC8800D89X2)},
         #endif
        +    {USB_DEVICE_AND_INTERFACE_INFO(0x2604, 0x001f, 0xff, 0xff, 0xff)},
             {}
         };
         
      '')
    ];
  };
in
{
  boot.extraModulePackages = [
    aic8800-usb
  ];
  boot.kernelModules = [
    "aic8800_fdrv"
    "aic_load_fw"
    # "aic_btusb"
  ];
  hardware.firmware = [
    aic8800-firmware
  ];

  # Make the dongle immediately modeswitch into WiFi dongle mode when plugged in.
  services.udev.extraRules = ''
    # Tenda AX9000 Wirelss USB Adapter - Perform USB modeswitch from mass storage device to aic8800 kernel driver
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="a69c", ATTR{idProduct}=="5723", RUN+="${pkgs.bash}/bin/bash -c 'sleep 2 && ${pkgs.usb-modeswitch}/bin/usb_modeswitch -KQ -v a69c -p 5723'"

    # ATTR{idVendor}=="a69c", ATTR{idProduct}=="5723", RUN+="$ {pkgsUnstable.usb-modeswitch}/lib/udev/usb_modeswitch '/%k'"
  '';
  # Couldn't figure this shit out (went back to `sleep 2`):
  # # Requires usb-modeswitch-data, added in hardware/usb.nix
  # environment.etc."usb_modeswitch.d/a69c:5723".text = ''
  #   DefaultVendor=0xa69c
  #   DefaultProduct=0x5723
  #   StandardEject=1
  # '';
}
