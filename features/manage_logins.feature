Feature: Manage logins
  In order to restrict unauthorized access to urm
  and manage users by someself
  wants [behaviour]
  
  Scenario: Login when unlogged
    Given I am unlogged
    And I am at search page
    And I login with registered user:
      |username|password|
      |tst     |password|
      |test    |password|
    When I click login
    Then I logged in

  Scenario: Logout
   Given I am logged with registered user:
    |username|password|
    |tst     |password|
   And I am at index page
   When I click logout
   Then I unlogged
   And I should be on the new sessions page
   And I login with registered user:
      |username|password|
      |test    |password|
