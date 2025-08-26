{ lib, stdenv, fetchFromGitHub, jdk8, ant, ivy, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "modelio";
  version = "5.4.1";

  src = fetchFromGitHub {
    owner = "ModelioOpenSource";
    repo = "Modelio";
    rev = "v5.4.1";  # ✅ Verwendet den v5.4.1 Tag
    sha256 = "sha256-YC6NQB1PjjnRkJ4rsNSn+kls2KWvMQgF+VtIDnZh5kM"; # Wird beim ersten Build ersetzt
  };

  nativeBuildInputs = [ jdk8 ant ivy makeWrapper ];
  buildInputs = [ jdk8 ];

  buildPhase = ''
    echo "🔨 Building Modelio..."
    export JAVA_HOME=${jdk8}
    
    # Ivy herunterladen falls nötig
    if [ ! -d "$HOME/.ant/lib" ]; then
      ant download-ivy
    fi
    
    # Build
    ant clean jar
  '';

  installPhase = ''
    echo "v5.4.1"
    mkdir -p $out/lib/modelio $out/bin $out/share/applications

    # JAR-Dateien suchen und kopieren
    find . -name "*.jar" -path "./build/*" -exec cp {} $out/lib/modelio/ \; || true
    find . -name "*.jar" -path "./dist/*" -exec cp {} $out/lib/modelio/ \; || true
    
    # Falls es eine main JAR gibt
    if [ -f "build/modelio.jar" ]; then
      cp build/modelio.jar $out/lib/modelio/
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
    platforms = platforms.linux;
  };
}
