var EXPRESS = require("express"); var HTTP = require("http"); var APP = EXPRESS();
var LOGGER = require('morgan');
var PATH = require('path');
var pubPath = PATH.resolve(__dirname, "pubilc");

APP.use(EXPRESS.static(pubPath));

APP.use(LOGGER("short"));

APP.use(function(req, res, next) {
	res.writeHead(200, {"Content-Type": "text/plain" });
	res.end("no static files");
	next();
});

APP.use(function(req, res, next) {
	var minute = (new Date()).getMinutes();
	if (minute % 2 === 0) {
		next();
	}
	else {
		res.statusCode = 403;
		res.end("Access Denied!");
		console.log("not relayed");
	}
});

APP.use(function(req, res, next) {
	res.end("PASSWORD SWORDFISH!");
	console.log("relayed.");
});

HTTP.createServer(APP).listen(3000);
console.log("Listening for HTTP on port 3000...");
