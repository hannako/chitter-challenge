feature 'Peeps' do
  scenario 'as a signed in user i can list a peep' do
    User.create(first_name: 'Jess',
                second_name: 'Jones',
                username: 'hannako',
                email: 'user@example.com',
                password: 'secret1234',
                password_confirmation: 'secret1234')

    visit '/'
    fill_in :email, with: 'user@example.com'
    fill_in :password, with: 'secret1234'
    click_button 'sign in'
    click_button 'peep'
    fill_in :peep, with: 'Hello World!'
    click_button 'peep'
    expect(page).to have_content ('Hello World')
  end
end
