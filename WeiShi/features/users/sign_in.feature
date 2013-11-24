Feature: Sign in
  In order to get access to protected sections of the site
  A user
  Should be able to sign in

    Scenario: User is not signed up
      Given I do not exist as a user
      When I sign in with valid credentials
      Then I see an invalid login message
        And I should be signed out

    Scenario: User signs in successfully
      Given I exist as a user
        And I am not logged in
      When I sign in with valid credentials
      Then I see a successful sign in message
      When I return to the site
      Then I should be signed in

    Scenario: User enters wrong email
      Given I exist as a user
      And I am not logged in
      When I sign in with a wrong email
      Then I see an invalid login message
      And I should be signed out

    Scenario: User using username to login
      Given I exist as a user
      And I am not logged in
      When I sign in with a right username
      Then I see a successful sign in message
      When I return to the site
      Then I should be signed in

    Scenario: User enters wrong password
      Given I exist as a user
      And I am not logged in
      When I sign in with a wrong password
      Then I see an invalid login message
      And I should be signed out

    Scenario: Old version User sign in with a right old version's md5 password
      Given I exist as a old version user
      And I am not logged in
      When I sign in with a right old version password
      Then I see a successful sign in message
      When I return to the site
      Then I should be signed in

    Scenario: Old version User sign in with a wrong old version's md5 password
      Given I exist as a old version user
      And I am not logged in
      When I sign in with a wrong old version password
      Then I see an invalid login message
      And I should be signed out