
var FS = require ('fs');
var PATH = require ('path'); 
var HTTP = require('http');
var MORGAN = require('morgan');
var EXPRESS = require ('express');
var STATICPATH= PATH.join(__dirname, "static");

var APP = EXPRESS();


HTTP.createServer(APP).listen(3000, function() {
  console.log("Guestbook app started on port 3000.");
});

APP.use(MORGAN("short"));

APP.use(EXPRESS.static(STATICPATH));

APP.use(function(req,res){
	res.status(404);
	res.send("File not found!");
})