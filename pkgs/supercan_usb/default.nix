{ fetchFromGitHub, stdenv, kernel, kmod, ... }:
let
  version = "0.2.8";
in
stdenv.mkDerivation {
  pname = "supercan_usb";
  version = "${version}-${kernel.modDirVersion}";

  src = fetchFromGitHub {
    owner = "Rombutan"; # Should probably be replaced with "jgressmann"
    repo = "supercan-linux";
    # This is a very specific commit that was found to work with linux 6.12
    rev = "2be5a6593b27ab3a17f2f5438663814605dc5346";
    hash = "sha256-/8wN+cgDd89ip2nxDJif5QHXfGEbbKLfDlo9/xCnMtc=";
  };

  dontConfigure = true;

  kernel = kernel.dev;
  kernelVersion = kernel.modDirVersion;

  nativeBuildInputs = [ kmod ] ++ kernel.moduleBuildDependencies;

  buildPhase = let
    supercan = fetchFromGitHub {
      owner = "jgressmann";
      repo = "supercan";
      rev = "d97ae7d9d3e39891f6330ed87aece40ce7668fe3";
      hash = "sha256-/ppWmAbUvOciL7OGjka7pUqDNL20izDb8eMQHyviYUQ=";
    };
  in ''
    cd supercan_usb-0.2.8

    cp -r ${supercan}/src/supercan.h .

    make V=1 KERNELRELEASE=$(uname -r) -C ${kernel.dev}/lib/modules/${kernel.modDirVersion}/build M=$PWD
  '';

  # prevent default `make install`, which calls `depmod -a` (errored in my testing)
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/misc
    cp supercan_usb.ko $out/lib/modules/${kernel.modDirVersion}/kernel/drivers/misc/

    runHook postInstall
  '';

  meta = {
    description = "SuperCAN Linux Driver";
    homepage = "https://github.com/jgressmann/supercan-linux";
  };
}
