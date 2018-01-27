var EXPRESS = require('express');
var APP = EXPRESS();

APP.use(function(req,res){
	console.log("Incoming for: " + req.url);
	res.end("Hi!");
});

HTTP.createServer(APP).listen(3000);
console.log("Listening for HTTP @3000");
