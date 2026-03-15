{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # pcopy: General purpose high-speed copy
    (writeShellScriptBin "pcopy" ''
      SRC=$(${coreutils}/bin/realpath "$1")
      DST=$(${coreutils}/bin/realpath "$2")
      mkdir -p "$DST"

      # Optimization: Using 'cp' with --archive and --fsync
      # Using 24 workers to match physical cores on i9-14900K
      # -f 1000: Groups 1000 files per job to reduce process spawning overhead
      ${fpart}/bin/fpsync -n 24 -f 1000 -m cp -o "--archive --fsync" "$SRC/" "$DST/"
    '')

    # pmove: General purpose high-speed move
    (writeShellScriptBin "pmove" ''
      SRC=$(${coreutils}/bin/realpath "$1")
      DST=$(${coreutils}/bin/realpath "$2")
      mkdir -p "$DST"

      # -W: Whole files (bypasses delta-xfer logic, faster for local)
      # -S: Efficiently handles sparse files (common in VM images/databases)
      ${fpart}/bin/fpsync -n 24 -f 1000 -o "-lptgoDWSq --remove-source-files" "$SRC/" "$DST/"

      if [ $? -eq 0 ]; then
        find "$SRC" -type d -empty -delete
      fi
    '')

    # pmerge: General purpose high-speed merge/sync
    (writeShellScriptBin "pmerge" ''
      SRC=$(${coreutils}/bin/realpath "$1")
      DST=$(${coreutils}/bin/realpath "$2")
      mkdir -p "$DST"

      # -u: Update (skip files that are newer on receiver)
      # --inplace: Writes directly to the file instead of creating a temp copy
      # (Massively reduces I/O overhead on NVMe)
      ${fpart}/bin/fpsync -n 24 -f 1000 -o "-lptgoDWSqu --inplace" "$SRC/" "$DST/"
    '')
  ];
}
