# Mobile Challenge

Welcome! This is your first step toward joining the development team of the largest investment bank in Latin America.

#### READ THE INSTRUCTIONS COMPLETELY BEFORE STARTING

> [!IMPORTANT]
> The use of AI tools will result in immediate disqualification. We have systems in place to detect and analyze such usage.

The challenge consists of developing a currency conversion app. The app should allow the user to select the source currency and the currency to be converted, then input the amount and view the conversion result.

## Requirements

The app must consume the [Mobile Challenge API](https://documenter.getpostman.com/view/11242574/2sA3Qqgt3W), created solely for the purpose of this challenge, and therefore does not provide real data. The API only presents exchange rates relative to a reference currency (US Dollar - `USD`); if the user wants to convert between any other two currencies, it will be necessary to first convert the source currency to dollars, and then from dollars to the desired currency.

* Android: _Kotlin_ | iOS: _Swift_
* The app should have two main screens:
   * The conversion screen should include:
      * Two buttons allowing the user to select the source and destination currencies.
      * A text input field where the user can enter the amount to be converted.
      * A text field to display the converted amount.
   * The currency listing screen should include:
      * A list of available currencies for conversion, displaying the currency code and name.

* The currency list must be shown on a separate screen from the conversion screen.

## Notes
* Prefer not using external libraries;
* If you choose to use external libraries, prefer CocoaPods as dependency manager;
* The goal of this challenge is to assess your technical knowledge, code style, understanding of architectures, programming patterns, and best practices. Take this opportunity to showcase all of your expertise.

## Features
### Mandatory:
- [ ] Exchange rates must be obtained from the [API Supported Currencies (/list)](https://raw.githubusercontent.com/Banking-iOS/mock-interview/main/api/list.json)
- [ ] The current exchange rate must be obtained from the [API Real-time Rates (/live)](https://raw.githubusercontent.com/Banking-iOS/mock-interview/main/api/live.json)
- [ ] Error handling and exception flows must be implemented, such as empty searches, loading issues, and other possible errors.

### Optional (not required, but earn extra points):
- [ ] Search functionality in the currency list by name or code (e.g., "dollar" or "USD").
- [ ] Sorting the currency list by name or code.
- [ ] Persisting the currency list and rates locally to allow app usage in offline mode.
- [ ] Developing unit and/or functional tests.
- [ ] Implementing the app using the MVVM architecture.
- [ ] Automated pipeline.

## Submission Process
To submit your challenge, fork this project to your GitHub account, clone it, and develop locally. When finished, open a pull request in the format "[Platform] - Name" to the master branch by the established deadline. An example would be "[iOS] - John Doe."

### Good luck.
