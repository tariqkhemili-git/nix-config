{ pkgs, ... }:

{
  home.packages = with pkgs; [

    # 1. pcopy: Multi-threaded copy with wildcard support
    (writeShellScriptBin "pcopy" ''
      set -euo pipefail
      trap 'echo -e "\n⚠️ Operation cancelled by user."; exit 1' INT TERM

      if [ "$#" -lt 2 ]; then
        echo "Usage: pcopy <source1> [source2...] <destination>"
        exit 1
      fi

      # The last argument is always the destination
      DST_RAW="''${@: -1}"
      DST=$(${coreutils}/bin/realpath -m "$DST_RAW")

      DST_EXISTS=false
      if [ -e "$DST_RAW" ] || [ -d "$DST_RAW" ]; then DST_EXISTS=true; fi

      # All arguments except the last one are sources
      SOURCES=("''${@:1:$#-1}")
      NUM_SOURCES=''${#SOURCES[@]}

      echo "🚀 Parallel Copy: Processing $NUM_SOURCES item(s) to $DST_RAW"

      for SRC_RAW in "''${SOURCES[@]}"; do
        SRC=$(${coreutils}/bin/realpath -m "$SRC_RAW")
        BASENAME=$(${coreutils}/bin/basename "$SRC")

        case "$DST/" in "$SRC/"*) echo "⚠️ Skipping $BASENAME: Recursive loop detected."; continue ;; esac

        if [ "$NUM_SOURCES" -eq 1 ] && [ "$DST_EXISTS" = false ]; then
          TARGET_DIR="$DST"
        else
          TARGET_DIR="$DST/$BASENAME"
        fi

        if [ -d "$SRC" ]; then
          ${coreutils}/bin/mkdir -p "$TARGET_DIR"
          set +e
          ${fpart}/bin/fpsync -n 20 -T ${rsync}/bin/rsync -o "-lptgoDWq" "$SRC/" "$TARGET_DIR/"
          set -e
        elif [ -f "$SRC" ]; then
          if [ "$NUM_SOURCES" -eq 1 ] && [ "$DST_EXISTS" = false ]; then
            ${coreutils}/bin/mkdir -p "$(${coreutils}/bin/dirname "$DST")"
            ${rsync}/bin/rsync -lptgoDWq "$SRC" "$DST"
          else
            ${coreutils}/bin/mkdir -p "$DST"
            ${rsync}/bin/rsync -lptgoDWq "$SRC" "$DST/"
          fi
        else
          echo "⚠️ Skipping $SRC_RAW: Not a standard file or directory."
        fi
      done
    '')

    # 2. pmove: Multi-threaded move with wildcard support
    (writeShellScriptBin "pmove" ''
      set -euo pipefail
      trap 'echo -e "\n⚠️ Operation cancelled by user."; exit 1' INT TERM

      if [ "$#" -lt 2 ]; then
        echo "Usage: pmove <source1> [source2...] <destination>"
        exit 1
      fi

      DST_RAW="''${@: -1}"
      DST=$(${coreutils}/bin/realpath -m "$DST_RAW")

      DST_EXISTS=false
      if [ -e "$DST_RAW" ] || [ -d "$DST_RAW" ]; then DST_EXISTS=true; fi

      SOURCES=("''${@:1:$#-1}")
      NUM_SOURCES=''${#SOURCES[@]}

      echo "🚚 Parallel Move: Processing $NUM_SOURCES item(s) to $DST_RAW"

      for SRC_RAW in "''${SOURCES[@]}"; do
        SRC=$(${coreutils}/bin/realpath -m "$SRC_RAW")
        BASENAME=$(${coreutils}/bin/basename "$SRC")

        case "$DST/" in "$SRC/"*) echo "⚠️ Skipping $BASENAME: Recursive loop detected."; continue ;; esac

        if [ "$NUM_SOURCES" -eq 1 ] && [ "$DST_EXISTS" = false ]; then
          TARGET_DIR="$DST"
        else
          TARGET_DIR="$DST/$BASENAME"
        fi

        if [ -d "$SRC" ]; then
          ${coreutils}/bin/mkdir -p "$TARGET_DIR"
          set +e
          ${fpart}/bin/fpsync -n 20 -T ${rsync}/bin/rsync -o "-lptgoDWq --remove-source-files" "$SRC/" "$TARGET_DIR/"
          EXIT_CODE=$?
          set -e
          
          if [ $EXIT_CODE -eq 0 ]; then
            ${findutils}/bin/find "$SRC" -type d -empty -delete
          fi
        elif [ -f "$SRC" ]; then
          if [ "$NUM_SOURCES" -eq 1 ] && [ "$DST_EXISTS" = false ]; then
            ${coreutils}/bin/mkdir -p "$(${coreutils}/bin/dirname "$DST")"
            ${rsync}/bin/rsync -lptgoDWq --remove-source-files "$SRC" "$DST"
          else
            ${coreutils}/bin/mkdir -p "$DST"
            ${rsync}/bin/rsync -lptgoDWq --remove-source-files "$SRC" "$DST/"
          fi
        else
          echo "⚠️ Skipping $SRC_RAW: Not a standard file or directory."
        fi
      done
    '')

    # 3. pmerge: Multi-threaded sync with wildcard support
    (writeShellScriptBin "pmerge" ''
      set -euo pipefail
      trap 'echo -e "\n⚠️ Operation cancelled by user."; exit 1' INT TERM

      if [ "$#" -lt 2 ]; then
        echo "Usage: pmerge <source1> [source2...] <destination>"
        exit 1
      fi

      DST_RAW="''${@: -1}"
      DST=$(${coreutils}/bin/realpath -m "$DST_RAW")

      DST_EXISTS=false
      if [ -e "$DST_RAW" ] || [ -d "$DST_RAW" ]; then DST_EXISTS=true; fi

      SOURCES=("''${@:1:$#-1}")
      NUM_SOURCES=''${#SOURCES[@]}

      echo "🔄 Parallel Merge: Processing $NUM_SOURCES item(s) to $DST_RAW"

      for SRC_RAW in "''${SOURCES[@]}"; do
        SRC=$(${coreutils}/bin/realpath -m "$SRC_RAW")
        BASENAME=$(${coreutils}/bin/basename "$SRC")

        case "$DST/" in "$SRC/"*) echo "⚠️ Skipping $BASENAME: Recursive loop detected."; continue ;; esac

        if [ "$NUM_SOURCES" -eq 1 ] && [ "$DST_EXISTS" = false ]; then
          TARGET_DIR="$DST"
        else
          TARGET_DIR="$DST/$BASENAME"
        fi

        if [ -d "$SRC" ]; then
          ${coreutils}/bin/mkdir -p "$TARGET_DIR"
          set +e
          ${fpart}/bin/fpsync -n 20 -T ${rsync}/bin/rsync -o "-lptgoDWqu" "$SRC/" "$TARGET_DIR/"
          set -e
        elif [ -f "$SRC" ]; then
          if [ "$NUM_SOURCES" -eq 1 ] && [ "$DST_EXISTS" = false ]; then
            ${coreutils}/bin/mkdir -p "$(${coreutils}/bin/dirname "$DST")"
            ${rsync}/bin/rsync -lptgoDWqu "$SRC" "$DST"
          else
            ${coreutils}/bin/mkdir -p "$DST"
            ${rsync}/bin/rsync -lptgoDWqu "$SRC" "$DST/"
          fi
        else
          echo "⚠️ Skipping $SRC_RAW: Not a standard file or directory."
        fi
      done
    '')

  ];
}
