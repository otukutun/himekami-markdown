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

    context 'with complex list' do
      let(:markdown) do
      <<-EOS.strip_heredoc
      # 今日の日記


      - [x] デザインをマスターする
      - [x] CSSをマスターする
      - [ ] Rails newする
        - [ ] aaa
           - [ ] aaaa
        - [ ] aaa

      - test
        - aaaa

      今日も一日がんばるぞい
      EOS
    end

    it 'will convert to list' do
      should eq <<-EOS.strip_heredoc.chomp
      <h1>今日の日記</h1>
      <ul>
      <li class="task-list-item">
      <p><input type="checkbox" class="task-list-item-checkbox" checked>デザインをマスターする</p>
      </li>
      <li class="task-list-item">
      <p><input type="checkbox" class="task-list-item-checkbox" checked>CSSをマスターする</p>
      </li>
      <li class="task-list-item">
      <p><input type="checkbox" class="task-list-item-checkbox">Rails newする</p>
      <ul>
      <li class="task-list-item">
      <input type="checkbox" class="task-list-item-checkbox">aaa<ul>
      <li class="task-list-item">
      <input type="checkbox" class="task-list-item-checkbox">aaaa</li>
      </ul>
      </li>
      <li class="task-list-item">
      <input type="checkbox" class="task-list-item-checkbox">aaa</li>
      </ul>
      </li>
      <li>
      <p>test</p>
      <ul>
      <li>aaaa</li>
      </ul>
      </li>
      </ul>
      <p>今日も一日がんばるぞい</p>
      EOS
    end
    end

    context 'with list syntax' do
      let(:markdown) do
        <<-EOS.strip_heredoc
          - 今日のタスク
            - ゴミ捨て
            - ねる
          - 明日のタスク
            - 筋トレ
        EOS
      end

      it 'will convert to list' do
        should eq <<-EOS.strip_heredoc.chomp
        <ul>
        <li>今日のタスク
        <ul>
        <li>ゴミ捨て</li>
        <li>ねる</li>
        </ul>
        </li>
        <li>明日のタスク
        <ul>
        <li>筋トレ</li>
        </ul>
        </li>
        </ul>
        EOS
      end
    end
  end
end
