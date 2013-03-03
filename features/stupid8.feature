Feature: See the FAQ page
  As a dealermatch user
  I want to see the FAQ page
  So that I can understand the Dealermatch process

  Scenario: Looking at the FAQ
    Given a user named "faq" with dealership "Faqs" exists
    Given I am logged in as "faq@example.com"
    And I am on the faq page
    Then I see "Frequently Asked Questions"
