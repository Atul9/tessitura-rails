Feature: Password recovery
  
  Scenario: User is in the database
    Given I have an active account
    And I am on the login page
    When I click the 'Forgot your password?' link
    And I submit the password reset form with my e-mail address
    Then I should see a message that reset information has been sent