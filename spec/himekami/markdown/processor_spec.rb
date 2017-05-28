require "spec_helper"
require "active_support/core_ext/string/strip"

RSpec.describe Himekami::Markdown::Processor do
  describe '#call' do
    let(:result) { described_class.new.call(markdown) }

    subject { result[:output].to_s }

    context 'with simple task list' do
      let(:markdown) do
        <<-EOS.strip_heredoc
          - [x] 今日のタスク
          - [ ] 明日のタスク
        EOS
      end

      it 'will convert to checkbox' do
        should eq <<-EOS.strip_heredoc.chomp
          <ul>
          <li class="task-list-item">
          <input type="checkbox" class="task-list-item-checkbox" checked>今日のタスク</li>
          <li class="task-list-item">
          <input type="checkbox" class="task-list-item-checkbox">明日のタスク</li>
          </ul>
        EOS
      end
    end

        context 'with nested task list' do
      let(:markdown) do
        <<-EOS.strip_heredoc
          - [x] 今日のタスク
            - [x] 洗濯
            - [x] 掃除
          - [ ] 明日のタスク
            - [x] ゴミ捨て
            - [ ] 買い物
        EOS
      end

      it 'will convert to checkbox' do
        should eq <<-EOS.strip_heredoc.chomp
          <ul>
          <li class="task-list-item">
          <input type="checkbox" class="task-list-item-checkbox" checked>今日のタスク<ul>
          <li class="task-list-item">
          <input type="checkbox" class="task-list-item-checkbox" checked>洗濯</li>
          <li class="task-list-item">
          <input type="checkbox" class="task-list-item-checkbox" checked>掃除</li>
          </ul>
          </li>
          <li class="task-list-item">
          <input type="checkbox" class="task-list-item-checkbox">明日のタスク<ul>
          <li class="task-list-item">
          <input type="checkbox" class="task-list-item-checkbox" checked>ゴミ捨て</li>
          <li class="task-list-item">
          <input type="checkbox" class="task-list-item-checkbox">買い物</li>
          </ul>
          </li>
          </ul>
        EOS
      end
    end
  end
end
