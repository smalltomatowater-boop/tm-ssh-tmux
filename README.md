# tm

`tmux` セッションを対話式で選ぶための小さいコマンドです。

`ssh` で Mac に入ったあと、長い `tmux` コマンドを覚えずに

- 既存セッションへ接続
- 新しいセッションを作成
- `tm <name>` で attach or create

ができます。

## 使い方

```bash
tm
```

起動すると既存セッション一覧を出して、番号で接続できます。

```bash
tm work
```

`work` セッションがあれば接続、なければ作成します。

## インストール

```bash
install -m 755 tm /opt/homebrew/bin/tm
```

## 前提

- `tmux` がインストール済み
- SSH 先で `tmux` が使える

## 想定フロー

```bash
ssh mini
tm
```

または

```bash
ssh mini -t tm
```
