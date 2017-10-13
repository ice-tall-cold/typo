Feature: Create Catagories
  As a blog administrator
  In order to sort all articles
  I want to be able to add catagories to my blog
  
  Background:
    Given the blog is set up
    And I am logged into the admin panel
    
  Scenario: Successfully create catagories
    Given I am on the new categories page
    When I fill in "category_name" with "LOL Final"
    And I fill in "category_keywords" with "RNG"
    And I fill in "category_permalink" with "GG"
    And I fill in "category_description" with "RNG:No.1"
    And I press "Save"
    Then I should see "LOL Final"
    Then I should see "RNG"
    Then I should see "GG"
    Then I should see "RNG:No.1"
    
    
    
    