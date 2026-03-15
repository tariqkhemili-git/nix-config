{ ... }:

{
  home.packages = with pkgs; [
    # 1. pcopy: Multi-threaded directory copy
    (writeShellScriptBin "pcopy" ''
      if [ "$#" -lt 2 ]; then
        echo "Usage: pcopy <source_directory> <destination_directory>"
        exit 1
      fi

      SRC=$(${coreutils}/bin/realpath "$1")
      DST=$(${coreutils}/bin/realpath "$2")

      if [ ! -d "$SRC" ]; then
        echo "Error: Source must be a directory."
        exit 1
      fi

      mkdir -p "$DST"
      echo "Parallel Copy: $SRC -> $DST (20 threads)"
      ${fpart}/bin/fpsync -n 20 -o '-lptgoDWq' "$SRC/" "$DST/"
    '')

    # 2. pmove: Multi-threaded directory move (copy then delete source)
    (writeShellScriptBin "pmove" ''
      if [ "$#" -lt 2 ]; then
        echo "Usage: pmove <source_directory> <destination_directory>"
        exit 1
      fi

      SRC=$(${coreutils}/bin/realpath "$1")
      DST=$(${coreutils}/bin/realpath "$2")

      if [ ! -d "$SRC" ]; then
        echo "Error: Source must be a directory."
        exit 1
      fi

      mkdir -p "$DST"
      echo "Parallel Move: $SRC -> $DST (20 threads)"
      ${fpart}/bin/fpsync -n 20 -o '-lptgoDWq --remove-source-files' "$SRC/" "$DST/"

      # Sweep up empty source directories after successful transfer
      if [ $? -eq 0 ]; then
        find "$SRC" -type d -empty -delete
      fi
    '')

    # 3. pmerge: Multi-threaded directory update (only newer files)
    (writeShellScriptBin "pmerge" ''
      if [ "$#" -lt 2 ]; then
        echo "Usage: pmerge <source_directory> <destination_directory>"
        exit 1
      fi

      SRC=$(${coreutils}/bin/realpath "$1")
      DST=$(${coreutils}/bin/realpath "$2")

      if [ ! -d "$SRC" ]; then
        echo "Error: Source must be a directory."
        exit 1
      fi

      mkdir -p "$DST"
      echo "Parallel Merge: $SRC -> $DST (20 threads)"
      ${fpart}/bin/fpsync -n 20 -o '-lptgoDWqu' "$SRC/" "$DST/"
    '')
  ];
}
