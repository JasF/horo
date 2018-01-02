logs = require('../common/logger').getLogger();
const Browser = require('zombie');

exports.performRequest = function (url, completion) {
    logs.info('performing url request: ' + url)
    const browser = new Browser()
    browser.fetch(url)
    .then(function(response) {
          if (response.status === 200)
          return response.text();
          })
    .then(function(text) {
          completion(text, null)
          })
    .catch(function(error) {
           completion(null, error)
    });
}
