## qamsocial.example.com_homepage.feature: Managed by Puppet
Feature: http://qamsocial.example.com/mobile-service-social/hcheck.jsp
  It should be up

  Scenario: Visiting home page
    When I go to "http://qamsocial.example.com/mobile-service-social/hcheck.jsp"
    Then the request should succeed
    Then I should see "status=healthy"
