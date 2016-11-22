# What is my average?

This script utilizes the selenium webdriver to acquire an authentication cookie for `stadssb.au.dk`.
The passes that cookie onto a bash scripts, which processes the results page to calculate an ECTS weighted average grade.

## Setup
```
npm install
npm run chromedriver
```

## Usage
```
npm start USERNAME PASSWORD
```
