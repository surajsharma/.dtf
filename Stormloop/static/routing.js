var EXPRESS = require("express"); var HTTP = require("http"); var APP = EXPRESS();
var LOGGER = require('morgan');

var PATH = require('path');
var pubPath = PATH.resolve(__dirname, "pubilc");

APP.set("views", PATH.resolve(__dirname, "views"));
APP.set("view-engine", "ejs");

APP.use(EXPRESS.static(pubPath));

APP.use(LOGGER("short"));

APP.get("/", function(req, res){
	res.render("index", {
		message: "W-HA-TE-V-ER-er.ORG"
	});
	res.end("Made by Inverspolarity (TM)");
});

APP.get("/about", function(req, res){
	res.end(req.ip);
});

APP.get("/hello/:who", function(req, res){
	res.end("Hi, "+ req.params.who + ".");
	//security issue
});

APP.use(function(req, res){
	res.statusCode = 404;
	res.end("404!");
});

HTTP.createServer(APP).listen(3000);
console.log("Listening for HTTP on port 3000...");
