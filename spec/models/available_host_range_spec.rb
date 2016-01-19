require 'rails_helper'
require 'spec_helper'

RSpec.describe AvailableHostRange, type: :model do
  let(:hosting) { FactoryGirl.create :hosting, zipcode: "11372" }

  context "when adding dates to hosting" do
    it "allows the host to set one or more ranges for a hosting" do
      expect(FactoryGirl.build :available_host_range).to be_valid
    end

    it "does not allow a start date in the past" do
      expect(FactoryGirl.build :available_host_range, start_date: DateTime.now - 5).to_not be_valid
    end

    it "does not allow an end date before the start date" do
      expect(FactoryGirl.build :available_host_range,
          start_date: DateTime.now + 5, end_date: DateTime.now).to_not be_valid
    end

    it "identifies whether date ranges overlap" do
      FactoryGirl.create :available_host_range, hosting_id: hosting.id
      expect(
        FactoryGirl
          .build(:available_host_range, hosting_id: hosting.id, end_date: DateTime.now + 10)
          .is_overlapping?
        ).to eq(true)
      expect(
        FactoryGirl
          .build(:available_host_range, hosting_id: hosting.id,
            start_date: DateTime.now + 20, end_date: DateTime.now + 40)
          .is_overlapping?
        ).to eq(false)
    end

  end
end
