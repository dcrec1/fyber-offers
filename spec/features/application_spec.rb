require 'rails_helper'

describe 'App' do
  include ActiveSupport::Testing::TimeHelpers

  it "renders offers when existent" do
    VCR.use_cassette("offers") do
      travel_to Time.new(2015, 6, 1) do
        visit '/'
        fill_in 'offers_uid', with: 'player1'
        fill_in 'offers_pub0', with: 'campaign2'
        fill_in 'offers_page', with: '1'
        click_button 'Search'
        expect(page).to_not have_content 'No offers available'
        expect(page).to have_content 'Double Down Casino - Facebook App'
      end
    end
  end

  it "doesn't render offers when the signature is invalid" do
    VCR.use_cassette("offers_with_invalid_signature") do
      travel_to Time.new(2015, 6, 1) do
        visit '/'
        fill_in 'offers_uid', with: 'player1'
        fill_in 'offers_pub0', with: 'campaign2'
        fill_in 'offers_page', with: '1'
        click_button 'Search'
        expect(page).to_not have_content 'Double Down Casino - Facebook App'
      end
    end
  end

  it "renders a message when no offers" do
    VCR.use_cassette("no_offers") do
      travel_to Time.new(2015, 6, 1) do
        visit '/'
        fill_in 'offers_uid', with: 'newplayer'
        fill_in 'offers_pub0', with: 'pub0'
        fill_in 'offers_page', with: '100'
        click_button 'Search'
        expect(page).to have_content 'No offers available'
      end
    end
  end

  it "renders a message when no offers for the page" do
    VCR.use_cassette("no_offers_for_page") do
      travel_to Time.new(2015, 6, 1) do
        visit '/'
        fill_in 'offers_uid', with: 'player1'
        fill_in 'offers_pub0', with: 'campaign2'
        fill_in 'offers_page', with: '2'
        click_button 'Search'
        expect(page).to have_content 'No offers available'
      end
    end
  end

  it "doesnt break when no params" do
    VCR.use_cassette("no_offers_no_params") do
      travel_to Time.new(2015, 6, 1) do
        visit '/'
        click_button 'Search'
        expect(status_code).to be 200
      end
    end
  end
end
