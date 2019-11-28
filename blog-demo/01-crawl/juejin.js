var url = 'https://short-msg-ms.juejin.im/v1/getHotRecommendList?uid=59c5a7aaf265da066e173d9f&device_id=1561788406684&token=eyJhY2Nlc3NfdG9rZW4iOiI4S1piMU1QVnhEakRkVDA0IiwicmVmcmVzaF90b2tlbiI6IlduS1hPY3FnYTFnMW5WeDkiLCJ0b2tlbl90eXBlIjoibWFjIiwiZXhwaXJlX2luIjoyNTkyMDAwfQ%3D%3D&src=web'

var request = require('request');
var cheerio = require('cheerio');
request(url, function (error, response, body) {
    var feidianObj = JSON.parse(body);
    feidianObj.d.list.forEach(function(item){
        console.log(item.content)
    })
});