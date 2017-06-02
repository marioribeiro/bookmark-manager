def sign_up(email: 'mail@marioribeiro.com',
            password: 'mypassword')
  visit '/users/new'
  fill_in :email, with: email
  fill_in :password, with: password
  click_button 'Signup'
end