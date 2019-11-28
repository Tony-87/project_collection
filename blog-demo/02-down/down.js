var fs = require('fs');
var request = require('request');

let url= 'https://pic4.ajkimg.com/display/xinfang/9b33f9fdf37c439a78b67688de5266a6/180x135m.jpg'

url = 'https://wkbjcloudbos.bdimg.com/v1/wenku28//0e125b3850dc32ac61d816f98219beba?responseContentDisposition=attachment%3B%20filename%3D%22%25E5%258F%258C%25E8%2589%25B2%25E7%2590%2583%25E5%258E%2586%25E5%258F%25B2%25E5%25BC%2580%25E5%25A5%2596%25E8%25AE%25B0%25E5%25BD%2595%25282003001-2013013%2529.txt%22%3B%20filename%2A%3Dutf-8%27%27%25E5%258F%258C%25E8%2589%25B2%25E7%2590%2583%25E5%258E%2586%25E5%258F%25B2%25E5%25BC%2580%25E5%25A5%2596%25E8%25AE%25B0%25E5%25BD%2595%25282003001-2013013%2529.txt&responseContentType=application%2Foctet-stream&responseCacheControl=no-cache&authorization=bce-auth-v1%2Ffa1126e91489401fa7cc85045ce7179e%2F2019-06-30T09%3A15%3A47Z%2F3000%2Fhost%2F85389bfe9347c9202437a64192c4c7cb3783f895e07cf409607efc399685fc39&token=eyJ0eXAiOiJKSVQiLCJ2ZXIiOiIxLjAiLCJhbGciOiJIUzI1NiIsImV4cCI6MTU2MTg4OTE0NywidXJpIjp0cnVlLCJwYXJhbXMiOlsicmVzcG9uc2VDb250ZW50RGlzcG9zaXRpb24iLCJyZXNwb25zZUNvbnRlbnRUeXBlIiwicmVzcG9uc2VDYWNoZUNvbnRyb2wiXX0%3D.GoPwrHqQOc3Kgef29Jsux5tDRCp5MQ2Ct%2BxVWLDqboE%3D.1561889147'
let filePath = './img/note.txt'
let stream = fs.createWriteStream(filePath);

request(url).pipe(stream).on("close",function (err) {
  //这里可以对下载的文件进行处理，比如下载的是文本文件，可以读取内容 
})
 