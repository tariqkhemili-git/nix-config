{ pkgs, ... }:

{
  home.packages = with pkgs; [

    # 1. pcopy: The ultimate high-speed parallel copy
    (writeShellScriptBin "pcopy" ''
      set -euo pipefail
      trap 'echo -e "\n⚠️ Operation cancelled by user."; exit 1' INT TERM

      if [ "$#" -lt 2 ]; then
        echo "Usage: pcopy <source_directory> <destination_directory>"
        exit 1
      fi

      SRC=$(${coreutils}/bin/realpath -m "$1")
      DST=$(${coreutils}/bin/realpath -m "$2")

      if [ ! -d "$SRC" ]; then
        echo "Error: Source '$SRC' is not a directory."
        exit 1
      fi

      case "$DST/" in "$SRC/"*) echo "Error: Recursive copy!"; exit 1 ;; esac

      ${coreutils}/bin/mkdir -p "$DST"
      START=$SECONDS
      echo "🚀 Parallel Copy (24 threads, sequential opt): $SRC -> $DST"

      set +e
      # Removed -s flag to allow NVMe to maintain sequential write speeds
      ${fpart}/bin/fpsync -n 24 -f 1000 -T ${rsync}/bin/rsync \
        -o "-lptgoDWSq --inplace --numeric-ids" "$SRC/" "$DST/"
      EXIT_CODE=$?
      set -e

      echo "⏱️ Completed in $((SECONDS - START)) seconds."
      exit $EXIT_CODE
    '')

    # 2. pmove: The ultimate high-speed parallel move
    (writeShellScriptBin "pmove" ''
      set -euo pipefail
      trap 'echo -e "\n⚠️ Operation cancelled by user."; exit 1' INT TERM

      if [ "$#" -lt 2 ]; then
        echo "Usage: pmove <source_directory> <destination_directory>"
        exit 1
      fi

      SRC=$(${coreutils}/bin/realpath -m "$1")
      DST=$(${coreutils}/bin/realpath -m "$2")

      if [ ! -d "$SRC" ]; then echo "Error: Source is not a dir."; exit 1; fi
      case "$DST/" in "$SRC/"*) echo "Error: Recursive move!"; exit 1 ;; esac

      ${coreutils}/bin/mkdir -p "$DST"
      START=$SECONDS
      echo "🚚 Parallel Move (24 threads, sequential opt): $SRC -> $DST"

      set +e
      ${fpart}/bin/fpsync -n 24 -f 1000 -T ${rsync}/bin/rsync \
        -o "-lptgoDWSq --inplace --numeric-ids --remove-source-files" "$SRC/" "$DST/"
      EXIT_CODE=$?
      set -e

      if [ $EXIT_CODE -eq 0 ]; then
        ${findutils}/bin/find "$SRC" -type d -empty -delete
      fi

      echo "⏱️ Completed in $((SECONDS - START)) seconds."
      exit $EXIT_CODE
    '')

    # 3. pmerge: The ultimate high-speed parallel sync
    (writeShellScriptBin "pmerge" ''
      set -euo pipefail
      trap 'echo -e "\n⚠️ Operation cancelled by user."; exit 1' INT TERM

      if [ "$#" -lt 2 ]; then
        echo "Usage: pmerge <source_directory> <destination_directory>"
        exit 1
      fi

      SRC=$(${coreutils}/bin/realpath -m "$1")
      DST=$(${coreutils}/bin/realpath -m "$2")

      if [ ! -d "$SRC" ]; then echo "Error: Source is not a dir."; exit 1; fi
      case "$DST/" in "$SRC/"*) echo "Error: Recursive merge!"; exit 1 ;; esac

      ${coreutils}/bin/mkdir -p "$DST"
      START=$SECONDS
      echo "🔄 Parallel Merge (24 threads, sequential opt): $SRC -> $DST"

      set +e
      ${fpart}/bin/fpsync -n 24 -f 1000 -T ${rsync}/bin/rsync \
        -o "-lptgoDWSqu --inplace --numeric-ids" "$SRC/" "$DST/"
      EXIT_CODE=$?
      set -e

      echo "⏱️ Completed in $((SECONDS - START)) seconds."
      exit $EXIT_CODE
    '')

  ];
}
