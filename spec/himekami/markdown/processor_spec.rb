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
          <input type="checkbox" class="task-list-item-checkbox" checked disabled>今日のタスク</li>
          <li class="task-list-item">
          <input type="checkbox" class="task-list-item-checkbox" disabled>明日のタスク</li>
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
            <input type="checkbox" class="task-list-item-checkbox" checked disabled>今日のタスク<ul>
            <li class="task-list-item">
            <input type="checkbox" class="task-list-item-checkbox" checked disabled>洗濯</li>
            <li class="task-list-item">
            <input type="checkbox" class="task-list-item-checkbox" checked disabled>掃除</li>
            </ul>
            </li>
            <li class="task-list-item">
            <input type="checkbox" class="task-list-item-checkbox" disabled>明日のタスク<ul>
            <li class="task-list-item">
            <input type="checkbox" class="task-list-item-checkbox" checked disabled>ゴミ捨て</li>
            <li class="task-list-item">
            <input type="checkbox" class="task-list-item-checkbox" disabled>買い物</li>
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
        - hogehoge
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
      <input type="checkbox" class="task-list-item-checkbox" checked disabled>デザインをマスターする</li>
      <li class="task-list-item">
      <input type="checkbox" class="task-list-item-checkbox" checked disabled>CSSをマスターする</li>
      <li class="task-list-item">
      <input type="checkbox" class="task-list-item-checkbox" disabled>Rails newする<ul>
      <li class="task-list-item">
      <input type="checkbox" class="task-list-item-checkbox" disabled>aaa<ul>
      <li class="task-list-item">
      <input type="checkbox" class="task-list-item-checkbox" disabled>aaaa</li>
      </ul>
      </li>
      <li class="task-list-item">
      <input type="checkbox" class="task-list-item-checkbox" disabled>aaa</li>
      <li>hogehoge
      <ul>
      <li class="task-list-item">
      <input type="checkbox" class="task-list-item-checkbox" disabled>aaa</li>
      </ul>
      </li>
      </ul>
      </li>
      <li>test
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
