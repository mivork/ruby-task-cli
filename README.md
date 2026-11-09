# ruby-task-cli

コマンドラインで動くシンプルなタスク管理ツールです。タスクの追加・一覧表示・完了・削除ができます。
データは `tasks.json` に保存されます。

## 必要環境

- Ruby 2.7 以上

## 使い方

```bash
ruby main.rb add 牛乳を買う
ruby main.rb list
ruby main.rb done 1
ruby main.rb delete 1
```

## コマンド一覧

| コマンド | 説明 |
|---|---|
| `add <タスク名>` | タスクを追加する |
| `list` | タスク一覧を表示する |
| `done <タスクID>` | タスクを完了にする |
| `delete <タスクID>` | タスクを削除する |

## データ形式

`tasks.json` に JSON 形式で保存されます。

```json
[
  {
    "id": 1,
    "title": "牛乳を買う",
    "done": false,
    "created_at": "2026-11-09T16:00:00+09:00"
  }
]
```
