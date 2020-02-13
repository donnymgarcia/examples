## qampush.example.com_homepage.feature: Managed by Puppet
Feature: http://qampush.example.com/push/hcheck.jsp
  It should be up

  Scenario: Visiting home page
    When I go to "http://qampush.example.com/push/hcheck.jsp"
    Then the request should succeed
    Then I should see "status=healthy"
