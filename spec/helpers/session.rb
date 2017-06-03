module SessionHelpers

 def sign_in(email:, password:)
   visit '/sessions/new'
   fill_in :email, with: email
   fill_in :password, with: password
   click_button 'Signin'
 end

 def sign_up(email: 'mail@marioribeiro.com',
             password: 'mypassword')
   visit '/users/new'
   fill_in :email, with: email
   fill_in :password, with: password
   click_button 'Signup'
 end

end