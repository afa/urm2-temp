Given /^I am unlogged$/ do
 User.current = nil
end

Given /^I am at search page$/ do
 visit search_path
 #save_and_open_page
 page.should have_xpath("//input[@id='user_login']")
 page.should have_xpath("//input[@id='user_pass']")
 page.should have_xpath("//input[@id='wp-submit' and @type='submit']")
end

Given /^I login with registered user:$/ do |table|
 @user = FactoryGirl.build(:user, table.hashes.first)
 @user.stub!(:valid?).and_return(true)
 Axapta.stub!(:user_info).and_return({})
 Axapta.stub!(:renew_structure)
 @user.save!
 acnt = FactoryGirl.create(:account, :user => @user)
 @user.current_account = acnt
 @user.save!

end

When /^I click login$/ do
 User.any_instance.stub(:reload_accounts).and_return(true)
 fill_in('user_login', :with => @user.username)
 fill_in('user_pass', :with => 'password')
 click_button("wp-submit")
 #save_and_open_page
end

Then /^I logged in$/ do
 save_and_open_page
 page.should have_xpath("//input[@id='current_account_account' and @type='hidden']")
 page.should have_xpath("//a[@class='quite']") #[@href='/sessions' and @data-method='delete']
end

Given /^I am logged with registered user:$/ do |table|
 @user = FactoryGirl.build(:user, table.hashes.first)
 @user.stub!(:valid?).and_return(true)
 Axapta.stub!(:user_info).and_return({})
 Axapta.stub!(:renew_structure)
 acnt = FactoryGirl.create(:account, :user => @user)
 @user.current_account = acnt
 @user.save!
 User.current = @user
end

Given /^I am at index page$/ do
 visit '/'
end

When /^I click logout$/ do
 click_link(I18n::t(:logout))
end

Then /^I redirected to new session$/ do
  page.should redirected_to(new_sessions_path)
end

Then /^I unlogged$/ do
 User.current.should be_nil
end






#Then /^I should be on the (.+?) page$/ do |page_name|
#  request.request_uri.should == send("#{page_name.downcase.gsub(' ','_')}_path")
#  response.should be_success
#end

#Then /^I should be on (.+?) page$/ do |page_name|
#  page.current_path.should == send("#{page_name.downcase.gsub(' ','_')}_path")
#  [200, 304].should be_include(page.status_code)
#  #[302,304].should be_include(page.status_code)
#end
