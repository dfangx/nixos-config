{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, cmake
, libebur128
, taglib
, ffmpeg
, inih
, fmt
, zlib
}:

stdenv.mkDerivation rec {
    pname = "rsgain";
    version = "3.3";

    src = fetchFromGitHub {
      owner = "complexlogic";
      repo = "rsgain";
      rev = "v${version}";
      sha256 = "sha256-IGUD1J7rWo0BZ56SydIOucGdXa11CUIv2n+LE1KbvNQ=";
    };

    cmakeFlags = ["-DCMAKE_BUILD_TYPE='Release'"];

    nativeBuildInputs = [pkg-config cmake];
    buildInputs = [libebur128 taglib ffmpeg inih fmt zlib];

    meta = with lib; {
      description = "A simple, but powerful ReplayGain 2.0 tagging utility";
      homepage = "https://github.com/complexlogic/rsgain";
      changelog = "https://github.com/complexlogic/rsgain/blob/v${version}/CHANGELOG";
      license = licenses.bsd2;
      platforms = platforms.all;
      maintainers = [maintainers.felipeqq2];
    };
}
