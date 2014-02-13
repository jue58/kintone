require 'spec_helper'
require 'kintone/api/guest'
require 'kintone/api'

describe Kintone::Api::Guest do
  let(:target) { Kintone::Api::Guest.new(space, api) }
  let(:space) { 1 }
  let(:api) { Kintone::Api.new("example.cybozu.com", "Administrator", "cybozu") }

  describe "#get_url" do
    subject { target.get_url(command) }
    context "" do
      let(:command) { "path" }

      it { expect(subject).to eq("/k/guest/1/v1/path.json") }
    end
  end
end
