require 'spec_helper'
module Liberic
  describe Config do
    let(:config) { Config.new }

    describe '#convert_to_eric' do
      it 'converts true to "ja"' do
        expect(config.send(:convert_to_eric, true)).to eq('ja')
      end

      it 'converts false to "nein"' do
        expect(config.send(:convert_to_eric, false)).to eq('nein')
      end

      it 'converts integers to strings' do
        expect(config.send(:convert_to_eric, 1)).to eq('1')
      end

      it 'converts strings to iso-8859-15' do
        expect(config.send(:convert_to_eric, 'äöüß')).to eq('äöüß'.encode('iso-8859-15'))
      end
    end

    describe '#convert_to_ruby' do
      ['yes', 'ja'].each do |input|
        it "converts #{input} to true" do
          expect(config.send(:convert_to_ruby, input)).to eq(true)
        end
      end

      ['no', 'nein'].each do |input|
        it "converts #{input} to false" do
          expect(config.send(:convert_to_ruby, input)).to be(false)
        end
      end

      it 'converts strings to integers' do
        expect(config.send(:convert_to_ruby, '1')).to eq(1)
      end

      it 'converts strings from iso-8859-15 to source encoding' do
        expect(config.send(:convert_to_ruby, 'äöüß'.encode('iso-8859-15'))).to eq('äöüß')
      end
    end
  end
end
