Given /^there are no users$/ do 
  User.count == 0
end

Given /^there is 1 user$/ do 
  @user = FactoryGirl.create(:user)
end

Given /^I'm viewing my profile$/ do 
  visit "/users/#{@user.id}"
end

When /^I submit the registration form with valid attributes$/ do 
  within '#new_user' do 
    fill_in 'user[password]', with: '2016usernew'
    fill_in 'user[password_confirmation]', with: '2016usernew'
    fill_in 'user[email]', with: 'newuser2016@example.com'
    fill_in 'user[email_confirmation]', with: 'newuser2016@example.com'
    fill_in 'user[first_name]', with: 'Frank'
    fill_in 'user[last_name]', with: 'Zappa'
    check 'user[terms]'

    click_button 'Create Account'
  end
end

When /^I submit the registration form with invalid attributes$/ do 
  within '#new_user' do 
    fill_in 'user[email]', with: ''
    click_button 'Create Account'
  end
end

When /^I visit the other user's dashboard$/ do 
  other_uid = User.where.not(:id => @user.id).first.id
  visit "/users/#{other_uid}/dashboard"
end

Then /^I should get a confirmation e-mail$/ do 
  expect(UserMailer.deliveries.count).to eql 1
end

Then /^I should not get a confirmation e-mail$/ do 
  expect(UserMailer.deliveries.count).to eql 0
end

Then /^I should see a message that the user was not saved$/ do 
  expect(page).to have_content 'prevented your account from being created'
end

Then /^there should be no users$/ do 
  expect(User.count).to eql 0
end

Then /^there should be (\d+) users?$/ do |count|
  if count == '1' then @user = User.first;
  else @users = User.all; end

  expect(User.count).to eql count.to_i
end

Then /^I should be rerouted to my dashboard$/ do 
  expect(current_path).to eql "/users/#{@user.id}/dashboard"
end