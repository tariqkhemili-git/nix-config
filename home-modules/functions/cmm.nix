{ pkgs, ... }:

{
  home.packages = with pkgs; [

    # 1. pcopy: Back to the 41-second raw speed logic
    (writeShellScriptBin "pcopy" ''
      set -euo pipefail
      trap 'echo -e "\n⚠️ Operation cancelled by user."; exit 1' INT TERM

      if [ "$#" -lt 2 ]; then
        echo "Usage: pcopy <source_directory> <destination_directory>"
        exit 1
      fi

      SRC=$(${coreutils}/bin/realpath -m "$1")
      DST=$(${coreutils}/bin/realpath -m "$2")

      if [ ! -d "$SRC" ]; then echo "Error: Source is not a dir."; exit 1; fi
      case "$DST/" in "$SRC/"*) echo "Error: Recursive copy!"; exit 1 ;; esac

      ${coreutils}/bin/mkdir -p "$DST"
      START=$SECONDS
      echo "🚀 Parallel Copy (20 threads, raw speed): $SRC -> $DST"

      set +e
      # Reverted to 20 threads, default chunking, and basic archive flags
      ${fpart}/bin/fpsync -n 20 -T ${rsync}/bin/rsync -o "-lptgoDWq" "$SRC/" "$DST/"
      EXIT_CODE=$?
      set -e

      echo "⏱️ Completed in $((SECONDS - START)) seconds."
      exit $EXIT_CODE
    '')

    # 2. pmove: Raw speed logic
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
      echo "🚚 Parallel Move (20 threads, raw speed): $SRC -> $DST"

      set +e
      ${fpart}/bin/fpsync -n 20 -T ${rsync}/bin/rsync -o "-lptgoDWq --remove-source-files" "$SRC/" "$DST/"
      EXIT_CODE=$?
      set -e

      if [ $EXIT_CODE -eq 0 ]; then
        ${findutils}/bin/find "$SRC" -type d -empty -delete
      fi

      echo "⏱️ Completed in $((SECONDS - START)) seconds."
      exit $EXIT_CODE
    '')

    # 3. pmerge: Raw speed logic
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
      echo "🔄 Parallel Merge (20 threads, raw speed): $SRC -> $DST"

      set +e
      ${fpart}/bin/fpsync -n 20 -T ${rsync}/bin/rsync -o "-lptgoDWqu" "$SRC/" "$DST/"
      EXIT_CODE=$?
      set -e

      echo "⏱️ Completed in $((SECONDS - START)) seconds."
      exit $EXIT_CODE
    '')

  ];
}
