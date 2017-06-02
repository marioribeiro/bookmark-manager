def sign_up
  visit '/users/new'
  expect(page.status_code).to eq(200)
  fill_in :email,    with: 'mail@marioribeiro.com'
  fill_in :password, with: 'mypassword'
  click_button 'Signup'
end