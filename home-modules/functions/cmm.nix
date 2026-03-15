{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # 1. pcopy: Robust multi-threaded directory copy
    (writeShellScriptBin "pcopy" ''
      # Strict mode: fail on errors, unbound variables, or pipe failures
      set -euo pipefail

      if [ "$#" -lt 2 ]; then
        echo "Usage: pcopy <source_directory> <destination_directory>"
        exit 1
      fi

      # -m ensures realpath works even if the destination doesn't exist yet
      SRC=$(${coreutils}/bin/realpath -m "$1")
      DST=$(${coreutils}/bin/realpath -m "$2")

      if [ ! -d "$SRC" ]; then
        echo "Error: Source '$SRC' is not a directory or does not exist."
        exit 1
      fi

      # Prevent recursive explosions (copying a folder into itself)
      case "$DST/" in
        "$SRC/"*)
          echo "Error: Destination cannot be a subdirectory of the source."
          exit 1
          ;;
      esac

      ${coreutils}/bin/mkdir -p "$DST"

      START=$SECONDS
      echo "🚀 Parallel Copy: $SRC -> $DST"

      # Temporarily disable strict exit on failure to capture fpsync's exit code gracefully
      set +e
      ${fpart}/bin/fpsync -n 24 -f 1000 -o "-lptgoDWq --inplace" "$SRC/" "$DST/"
      EXIT_CODE=$?
      set -e

      echo "⏱️ Completed in $((SECONDS - START)) seconds."
      exit $EXIT_CODE
    '')

    # 2. pmove: Robust multi-threaded directory move
    (writeShellScriptBin "pmove" ''
      set -euo pipefail

      if [ "$#" -lt 2 ]; then
        echo "Usage: pmove <source_directory> <destination_directory>"
        exit 1
      fi

      SRC=$(${coreutils}/bin/realpath -m "$1")
      DST=$(${coreutils}/bin/realpath -m "$2")

      if [ ! -d "$SRC" ]; then
        echo "Error: Source '$SRC' is not a directory."
        exit 1
      fi

      case "$DST/" in
        "$SRC/"*)
          echo "Error: Destination cannot be a subdirectory of the source."
          exit 1
          ;;
      esac

      ${coreutils}/bin/mkdir -p "$DST"

      START=$SECONDS
      echo "🚚 Parallel Move: $SRC -> $DST"

      set +e
      ${fpart}/bin/fpsync -n 24 -f 1000 -o "-lptgoDWq --inplace --remove-source-files" "$SRC/" "$DST/"
      EXIT_CODE=$?
      set -e

      # Safely clean up empty directories only if the transfer was 100% successful
      if [ $EXIT_CODE -eq 0 ]; then
        ${findutils}/bin/find "$SRC" -type d -empty -delete
      else
        echo "⚠️ Move completed with errors. Source directories were not fully cleaned up."
      fi

      echo "⏱️ Completed in $((SECONDS - START)) seconds."
      exit $EXIT_CODE
    '')

    # 3. pmerge: Robust multi-threaded directory sync
    (writeShellScriptBin "pmerge" ''
      set -euo pipefail

      if [ "$#" -lt 2 ]; then
        echo "Usage: pmerge <source_directory> <destination_directory>"
        exit 1
      fi

      SRC=$(${coreutils}/bin/realpath -m "$1")
      DST=$(${coreutils}/bin/realpath -m "$2")

      if [ ! -d "$SRC" ]; then
        echo "Error: Source '$SRC' is not a directory."
        exit 1
      fi

      case "$DST/" in
        "$SRC/"*)
          echo "Error: Destination cannot be a subdirectory of the source."
          exit 1
          ;;
      esac

      ${coreutils}/bin/mkdir -p "$DST"

      START=$SECONDS
      echo "🔄 Parallel Merge: $SRC -> $DST"

      set +e
      ${fpart}/bin/fpsync -n 24 -f 1000 -o "-lptgoDWSqu --inplace" "$SRC/" "$DST/"
      EXIT_CODE=$?
      set -e

      echo "⏱️ Completed in $((SECONDS - START)) seconds."
      exit $EXIT_CODE
    '')
  ];
}
