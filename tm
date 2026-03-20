#!/usr/bin/env bash
set -euo pipefail

TMUX_BIN="${TMUX_BIN:-$(command -v tmux || true)}"

if [[ -z "$TMUX_BIN" ]]; then
  echo "tmux が見つかりません。" >&2
  exit 1
fi

sanitize_name() {
  local input="${1// /-}"
  input="${input//:/-}"
  input="${input//./-}"
  printf '%s' "$input"
}

session_exists() {
  "$TMUX_BIN" has-session -t "$1" 2>/dev/null
}

connect_session() {
  local name="$1"

  if [[ -n "${TMUX:-}" ]]; then
    if session_exists "$name"; then
      exec "$TMUX_BIN" switch-client -t "$name"
    fi
    exec "$TMUX_BIN" new-session -d -s "$name" \; switch-client -t "$name"
  fi

  exec "$TMUX_BIN" new-session -A -s "$name"
}

print_sessions() {
  "$TMUX_BIN" list-sessions -F '#{session_name}|#{session_windows}|#{?session_attached,attached,detached}' \
    2>/dev/null || true
}

choose_session() {
  local -a sessions=()
  local line
  local idx=1

  while IFS= read -r line; do
    [[ -n "$line" ]] || continue
    sessions+=("$line")
  done < <(print_sessions)

  echo ""
  echo "tm"
  echo "=="

  if ((${#sessions[@]} == 0)); then
    echo "セッションはまだありません。"
    echo ""
    read -r -p "新しいセッション名: " new_name
    new_name="$(sanitize_name "$new_name")"
    [[ -n "$new_name" ]] || { echo "名前が空です。"; exit 1; }
    connect_session "$new_name"
  fi

  echo "既存セッション:"
  for line in "${sessions[@]}"; do
    IFS='|' read -r name windows attached <<<"$line"
    printf '  %d) %s  [%s, %s windows]\n' "$idx" "$name" "$attached" "$windows"
    idx=$((idx + 1))
  done
  echo ""
  echo "  n) 新規作成"
  echo "  q) 終了"
  echo ""

  read -r -p "選択: " choice

  case "$choice" in
    q|Q)
      exit 0
      ;;
    n|N)
      read -r -p "新しいセッション名: " new_name
      new_name="$(sanitize_name "$new_name")"
      [[ -n "$new_name" ]] || { echo "名前が空です。"; exit 1; }
      connect_session "$new_name"
      ;;
    *)
      if [[ "$choice" =~ ^[0-9]+$ ]] && ((choice >= 1 && choice <= ${#sessions[@]})); then
        IFS='|' read -r name _ <<<"${sessions[choice-1]}"
        connect_session "$name"
      fi
      echo "無効な選択です。"
      exit 1
      ;;
  esac
}

if (($# > 0)); then
  name="$(sanitize_name "$1")"
  [[ -n "$name" ]] || { echo "セッション名が空です。"; exit 1; }
  connect_session "$name"
fi

choose_session
