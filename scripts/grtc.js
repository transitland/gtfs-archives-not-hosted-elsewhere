// npm install puppeteer
const puppeteer = require('puppeteer');
const fetch = require('node-fetch');
const fs = require('fs');

const downloadFile = (async (url, path) => {
  const res = await fetch(url);
  const fileStream = fs.createWriteStream(path);
  await new Promise((resolve, reject) => {
      res.body.pipe(fileStream);
      res.body.on("error", reject);
      fileStream.on("finish", resolve);
    });
});

(async () => {
  const browser = await puppeteer.launch({
    headless: true,
    args: [
      '--start-maximized' // you can also use '--start-fullscreen'
    ]
  });
  const page = await browser.newPage();
  await page.setViewport({ width: 1366, height: 768});
  // await page.screenshot({ path: 'page1.png' });
  await page.goto('http://ridegrtc.com/gtfs-files-login');
  await page.type('input[name=username]', process.env.GRTC_USERNAME);
  await page.type('input[name=password]', process.env.GRTC_PASSWORD);
  await Promise.all([
    page.waitForNavigation(),
    page.click('form.ff_composer input[value=Submit]')
  ]);
  // await page.screenshot({ path: 'page2.png' });
  const [continueLink] = await page.$x("//a[contains(., 'Click here if you are not redirected automatically')]");
  await Promise.all([
    page.waitForNavigation(),
    continueLink.click()
  ]);
  // await page.screenshot({ path: 'page3.png' });
  const gtfsUrl = await page.$eval('a.gtfs-button', anchor => anchor.getAttribute('href'));
  // console.log(gtfsUrl)
  downloadFile(gtfsUrl, "../grtc.zip")
  await browser.close();
})();