Given /^I am unlogged$/ do
 User.current = nil
end

Given /^I am at search page$/ do
 visit search_path
 page.should have_xpath("//input[@id='session_username']")
 page.should have_xpath("//input[@id='session_password']")
 page.should have_xpath("//input[@id='session_submit' and @type='submit']")
end

Given /^I login with registered user:$/ do |table|
 @user = FactoryGirl.build(:user, table.hashes.first)
 @user.stub!(:valid?).and_return(true)
 Axapta.stub!(:user_info).and_return({})
 @user.save!
end

When /^I click login$/ do
 User.any_instance.stub(:reload_accounts).and_return(true)
 fill_in('session_username', :with => @user.username)
 fill_in('session_password', :with => 'password')
 click_button("session_submit")
 save_and_open_page
end

Then /^I logged in$/ do
 page.should have_xpath("//input[@id='current_account_account' and @type='hidden']")
 page.should have_xpath("//a[@class='quite']") #[@href='/sessions' and @data-method='delete']
end

Given /^I am logged with registered user:$/ do |table|
 @user = FactoryGirl.build(:user, table.hashes.first)
 @user.stub!(:valid?).and_return(true)
 Axapta.stub!(:user_info).and_return({})
 @user.save!
 User.current = @user
end

Given /^I am at index page$/ do
 visit '/'
end

When /^I click logout$/ do
 click_link(I18n::t(:logout))
end

Then /^I unlogged$/ do
 User.current.should be_nil
end

