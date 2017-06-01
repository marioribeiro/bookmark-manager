feature 'Creating links' do
  scenario 'I can create a new link' do
    visit '/links/new'
    fill_in 'url',   with: 'http://marioribeiro.com'
    fill_in 'title', with: "Mario Ribeiro's website"
    click_button 'Create Link'
    expect(current_path).to eq '/links'
    within 'div#links' do
      expect(page).to have_content("Mario Ribeiro's website")
    end
  end

end