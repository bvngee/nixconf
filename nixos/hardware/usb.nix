{ self, pkgs, config, ... }: {
  # Thunderbolt 3 device manager
  services.hardware.bolt.enable = true;

  environment.systemPackages = with pkgs; [
    # CLI/GUI manager for the Logitech Unifying Receiver
    solaar

    # Glorious Model O Wireless CLI configuration tool
    self.packages.${pkgs.stdenv.hostPlatform.system}.mow
  ];

  services.udev.packages = with pkgs; [
    # supposedly more up to date than what's included with solaar
    logitech-udev-rules
  ];

  # Creates plugdev group
  users.groups.plugdev = { };
  # Adds my user to plugdev and dialout groups
  users.users.${config.host.mainUser}.extraGroups = [ "plugdev" "dialout" ];

  # Allows users in plugdev group to access certain USB devices. 
  services.udev.extraRules = ''
    # Microbit (for use in the browser via the WebUSB)
    SUBSYSTEMS=="usb", ATTR{idVendor}=="0d28", MODE="0664", GROUP="plugdev"

    # https://github.com/stlink-org/stlink/tree/testing/config/udev/rules.d
    # STM32 nucleo boards, with onboard st/linkv2-1. ie, STM32F0, STM32F4.
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374a", MODE="0664", GROUP="plugdev", SYMLINK+="stlinkv2-1_%n"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", MODE="0664", GROUP="plugdev", SYMLINK+="stlinkv2-1_%n"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3752", MODE="0664", GROUP="plugdev", SYMLINK+="stlinkv2-1_%n"
    # STM32 discovery boards, with onboard st/linkv2. ie, STM32L, STM32F4.
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", MODE="0664", GROUP="plugdev", SYMLINK+="stlinkv2_%n"

    # stlink-v3 boards (standalone and embedded) in usbloader mode and standard (debug) mode
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374d", \
    MODE="660", GROUP="plugdev", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1", \
    SYMLINK+="stlinkv3loader_%n"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374e", \
    MODE="660", GROUP="plugdev", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1", \
    SYMLINK+="stlinkv3_%n"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374f", \
    MODE="660", GROUP="plugdev", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1", \
    SYMLINK+="stlinkv3_%n"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3753", \
    MODE="660", GROUP="plugdev", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1", \
    SYMLINK+="stlinkv3_%n"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3754", \
    MODE="660", GROUP="plugdev", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1", \
    SYMLINK+="stlinkv3_%n"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3755", \
    MODE="660", GROUP="plugdev", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1", \
    SYMLINK+="stlinkv3loader_%n"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3757", \
    MODE="660", GROUP="plugdev", TAG+="uaccess", ENV{ID_MM_DEVICE_IGNORE}="1", \
    SYMLINK+="stlinkv3_%n"

    # MPLab Extensions rules for Microship embedded development (attiny)
    # 2017.12.15 Rules file created.
    # ------------- BEGIN --------------
    ACTION=="add", SUBSYSTEM=="tty", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="6124", MODE="666"
    # ACTION=="add", SUBSYSTEM=="tty", KERNEL=="ttyACM[0-9]*", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="6124", MODE="0666"

    ACTION!="add", GOTO="rules_end"
    SUBSYSTEM=="usb_device", GOTO="check_add"
    SUBSYSTEM!="usb", GOTO="rules_end"

    LABEL="check_add"

    ATTR{idVendor}=="04d8", ATTR{idProduct}=="8???", MODE="666"
    ATTR{idVendor}=="04d8", ATTR{idProduct}=="9???", MODE="666"
    ATTR{idVendor}=="04d8", ATTR{idProduct}=="a0??", MODE="666"
    ATTR{idVendor}=="04d8", ATTR{idProduct}=="00e0", MODE="666"
    ATTR{idVendor}=="04d8", ATTR{idProduct}=="00e1", MODE="666"
    ATTR{idVendor}=="03eb", ATTR{idProduct}!="6124", MODE="666"

    LABEL="rules_end"
    # -------------  END  --------------


    ### Total Phase USB Device Configuration
    # Aarvark I2C/SPI Host Adapter
    ACTION=="add", SUBSYSTEM=="usb_device", ATTR{idVendor}=="0403", ATTR{idProduct}=="e0d0", OWNER="root", GROUP="root", MODE="0666"
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="e0d0", OWNER="root", GROUP="root", MODE="0666"

    # Beagle I2C/SPI/USB Protocol Analyzer
    ACTION=="add", SUBSYSTEM=="usb_device", ATTR{idVendor}=="1679", ATTR{idProduct}=="2001", OWNER="root", GROUP="root", MODE="0666"
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1679", ATTR{idProduct}=="2001", OWNER="root", GROUP="root", MODE="0666"

    # Cheetah SPI Host Adapter
    ACTION=="add", SUBSYSTEM=="usb_device", ATTR{idVendor}=="1679", ATTR{idProduct}=="2002", OWNER="root", GROUP="root", MODE="0666"
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1679", ATTR{idProduct}=="2002", OWNER="root", GROUP="root", MODE="0666"

    # Komodo CAN Solo/Duo Interface
    ACTION=="add", SUBSYSTEM=="usb_device", ATTR{idVendor}=="1679", ATTR{idProduct}=="3001", OWNER="root", GROUP="root", MODE="0666"
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1679", ATTR{idProduct}=="3001", OWNER="root", GROUP="root", MODE="0666"

    # Power Delivery Analyzer
    ACTION=="add", SUBSYSTEM=="usb_device", ATTR{idVendor}=="1679", ATTR{idProduct}=="6003", OWNER="root", GROUP="root", MODE="0666"
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1679", ATTR{idProduct}=="6003", OWNER="root", GROUP="root", MODE="0666"

    # Power Delivery Analyzer (Console)
    SUBSYSTEM=="tty", ATTRS{idVendor}=="1679", ATTRS{idProduct}=="6003", SYMLINK+="pdaconsole", OWNER="root", GROUP="root", MODE="0666"

    # Power Delivery Analyzer (Update mode)
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="df11", OWNER="root", GROUP="root", MODE="0666"
  '';

}
