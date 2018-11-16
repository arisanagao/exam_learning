# frozen_string_literal: true

require 'test_helper'

# test/application_system_test_case
class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
end
