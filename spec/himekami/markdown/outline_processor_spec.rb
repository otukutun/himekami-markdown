require 'spec_helper'
require 'active_support/core_ext/string/strip'

RSpec.describe Himekami::Markdown::OutlineProcessor do
  describe '#call' do
    let(:result) { described_class.new.call(markdown) }

    subject { result[:output].to_s }

    context 'with simple task list' do
      let(:markdown) do
        <<-EOS.strip_heredoc
          # お仕事
          ## 開発
          # TODO
          # 与太話
        EOS
      end

      it 'will extract h1 headings' do
        should eq <<-EOS.strip_heredoc.chomp
          <h1>お仕事</h1>
          <h1>TODO</h1>
          <h1>与太話</h1>

        EOS
      end
    end
  end
end
