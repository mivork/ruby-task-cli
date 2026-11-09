#!/usr/bin/env ruby
# frozen_string_literal: true

require 'json'
require 'time'

DATA_FILE = File.join(__dir__, 'tasks.json')

def load_tasks
  return [] unless File.exist?(DATA_FILE)

  JSON.parse(File.read(DATA_FILE), symbolize_names: true)
rescue JSON::ParserError
  warn "警告: #{DATA_FILE} が壊れているため、空のタスク一覧で開始します"
  []
end

def save_tasks(tasks)
  File.write(DATA_FILE, JSON.pretty_generate(tasks))
end

def next_id(tasks)
  (tasks.map { |t| t[:id] }.max || 0) + 1
end

def cmd_add(args)
  title = args.join(' ')
  if title.empty?
    warn '使い方: ruby main.rb add <タスク名>'
    return
  end
  tasks = load_tasks
  task = {
    id: next_id(tasks),
    title: title,
    done: false,
    created_at: Time.now.iso8601
  }
  tasks << task
  save_tasks(tasks)
  puts "追加しました: [#{task[:id]}] #{task[:title]}"
end

def cmd_list
  tasks = load_tasks
  if tasks.empty?
    puts 'タスクはありません'
    return
  end
  tasks.each do |t|
    status = t[:done] ? '[x]' : '[ ]'
    puts "#{status} #{t[:id]}. #{t[:title]}"
  end
end

def cmd_done(args)
  id = args[0].to_i
  if id.zero?
    warn '使い方: ruby main.rb done <タスクID>'
    return
  end
  tasks = load_tasks
  task = tasks.find { |t| t[:id] == id }
  if task.nil?
    warn "タスクが見つかりません: #{id}"
    return
  end
  task[:done] = true
  save_tasks(tasks)
  puts "完了しました: [#{task[:id]}] #{task[:title]}"
end

def cmd_delete(args)
  id = args[0].to_i
  if id.zero?
    warn '使い方: ruby main.rb delete <タスクID>'
    return
  end
  tasks = load_tasks
  target = tasks.find { |t| t[:id] == id }
  if target.nil?
    warn "タスクが見つかりません: #{id}"
    return
  end
  tasks.reject! { |t| t[:id] == id }
  save_tasks(tasks)
  puts "削除しました: [#{target[:id]}] #{target[:title]}"
end

def show_help
  puts <<~HELP
    タスク管理CLI

    使い方:
      ruby main.rb add <タスク名>   タスクを追加
      ruby main.rb list             タスク一覧を表示
      ruby main.rb done <タスクID>  タスクを完了にする
      ruby main.rb delete <タスクID> タスクを削除

    例:
      ruby main.rb add 牛乳を買う
      ruby main.rb list
      ruby main.rb done 1
      ruby main.rb delete 1
  HELP
end

case ARGV[0]
when 'add'
  cmd_add(ARGV[1..])
when 'list'
  cmd_list
when 'done'
  cmd_done(ARGV[1..])
when 'delete'
  cmd_delete(ARGV[1..])
else
  show_help
end
