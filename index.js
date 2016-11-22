var webdriver = require('selenium-webdriver');
var By = webdriver.By;
var until = webdriver.until;
var Key = webdriver.Key;

var browser = 'chrome';
var url = 'https://stadssb.au.dk/sb_STAP/sb/'
if(process.argv.length < 4)
{
    console.error("Missing arguments!");
    process.exit(1);
    return;
}

var username = process.argv[2];
var password = process.argv[3];

var driverMain = new webdriver.Builder()
    .forBrowser(browser)
    .build();

driverMain.get(url);

var username_id = By.id('username');
driverMain.wait(until.elementLocated(username_id));
var username_field = driverMain.findElement(username_id);
username_field.sendKeys(username);

var password_id = By.id('password');
driverMain.wait(until.elementLocated(password_id));
var password_field = driverMain.findElement(password_id);
password_field.sendKeys(password);

password_field.submit();

driverMain.manage().getCookies().then(function(value)
{
    if(value.length != 2)
    {
        console.error("Invalid cookie return!");
        return;
    }

    console.log(value.reduce(function(acc,element)
    {
        return acc + "; " + element.name + "=" + element.value;
    },""));
});

driverMain.close();
driverMain.quit();
