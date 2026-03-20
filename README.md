# tm

Claude Code がアプリを出しても、`tmux` なら Codex でも Claude Code でも何でも使えるだろう、という前提で作った小さいランチャーです。

SSH 先で `tm` と打つだけで、

- 既存の `tmux` セッションを一覧から選ぶ
- 新しいセッションを作る
- `tm work` のように attach or create する

ができます。

長い `tmux attach -t ...` や `tmux new-session -A -s ...` を毎回打ちたくない人向けです。

## できること

- `tm`
  対話式で既存セッションを選ぶ
- `tm work`
  `work` セッションに attach。なければ作成
- `tmux` の中から実行しても、そのまま別セッションへ移動

## 使い方

```bash
tm
```

表示された一覧から番号で選ぶか、`n` で新規作成します。

```bash
tm work
```

`work` セッションがあれば接続、なければ作成します。

## 想定フロー

```bash
ssh mini
tm
```

または 1 発で:

```bash
ssh mini -t tm
```

## インストール

```bash
install -m 755 tm /opt/homebrew/bin/tm
```

## 前提

- `tmux` がインストール済み
- SSH 先で `tmux` が使える
- Bash で実行できる環境

## どういう人向けか

- Claude Code のアプリより `tmux` を使い続けたい
- Codex も Claude Code も同じ運用で回したい
- iPad / iPhone から iSH 経由で SSH している
- とにかくコマンドを覚えたくない
