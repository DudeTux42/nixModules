{ lib, stdenv, fetchFromGitHub, jdk8, ant, ivy, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "modelio";
  version = "5.4.1";

  src = fetchFromGitHub {
    owner = "ModelioOpenSource";
    repo = "Modelio";
    rev = "main"; # oder spezifischer commit
    sha256 = lib.fakeSha256; # Wird beim ersten Build ersetzt
  };

  nativeBuildInputs = [ jdk8 ant ivy makeWrapper ];
  buildInputs = [ jdk8 ];

  buildPhase = ''
    echo "🔨 Building Modelio..."
    export JAVA_HOME=${jdk8}
    ant download-ivy
    ant clean jar
  '';

  installPhase = ''
    echo "📦 Installing Modelio..."
    mkdir -p $out/lib/modelio $out/bin $out/share/applications

    # JAR-Dateien kopieren
    if [ -d "build" ]; then
      cp -r build/*.jar $out/lib/modelio/ 2>/dev/null || true
    fi
    
    if [ -d "dist" ]; then
      cp -r dist/* $out/lib/modelio/ 2>/dev/null || true
    fi

    # Executable wrapper
    makeWrapper ${jdk8}/bin/java $out/bin/modelio \
      --add-flags "-jar $out/lib/modelio/modelio.jar" \
      --set JAVA_HOME "${jdk8}" \
      --set PATH "${lib.makeBinPath [ jdk8 ]}"

    # Desktop entry
    cat > $out/share/applications/modelio.desktop << EOF
[Desktop Entry]
Name=Modelio
Comment=Open Source Modeling Environment
Exec=$out/bin/modelio
Icon=modelio
Terminal=false
Type=Application
Categories=Development;Engineering;
EOF
  '';

  meta = with lib; {
    description = "Open Source Modeling Environment";
    homepage = "https://github.com/ModelioOpenSource/Modelio";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.dudetux42 ]; # Du!
    platforms = platforms.linux;
  };
}
