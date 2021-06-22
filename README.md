# ConCurrencyBot

  A command-line application written with Swift for implementing the Telegram bot logic.

## Functional
  1. Get current Central Bank currency rate;
  2. Get Central Bank currency rate for the specific date;
  3. Get local banks currency exchange offers;
  4. Get local banks best currency exchange offer.
  
## How to

### Preparation
  1. At first, you should install Swift on your computer. Visit [swift.org](https://swift.org/download/) for more information. To check the success write `swift --version` in your terminal.
  2. Then you should add bot token to your environment. On macOS, you can do it this way:
  ```bash
    TOKEN=<Bot token here> export TOKEN
  ```
  You can get а Telegram bot token by creating new one via [BotFather](https://t.me/BotFather).
### Run bot
 To run bot you nead:
 1. Clone project;
 2. Enter the directory;
 3. Start the bot.
 ```bash
    git clone https://github.com/VGrokhotov/ConCurrencyBot.git
    cd ConCurrencyBot
    swift run
 ```
  
### Run tests
  To start bot testing you need to run Swift testing in the project directory:
   ```bash
    swift test
 ```
