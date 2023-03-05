Capybara.register_driver :selenium_chrome_headless do |app|
  Capybara::Selenium::Driver.new app,
    browser: :chrome,
    clear_session_storage: true,
    clear_local_storage: true,
    options: Selenium::WebDriver::Chrome::Options.new(
      args: %w[headless disable-gpu no-sandbox window-size=1600,1200],
    )
end
Capybara.server = :puma, { Silent: true }
Capybara.javascript_driver = :selenium_chrome_headless
# Capybara.javascript_driver = :selenium_chrome
