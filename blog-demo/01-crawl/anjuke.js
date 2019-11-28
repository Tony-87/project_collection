var request = require('request');
var cheerio = require('cheerio');
request('https://bj.fang.anjuke.com/loupan/', function (error, response, body) {
    const $ = cheerio.load(body);
    $('.item-mod').each(function (index, item) {
        var name = $(item).find('.items-name').text().trim()
        var price = $(item).find('.price').text().trim()
        console.log(name,price); 
    })
});