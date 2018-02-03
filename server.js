// -------------------------------------- STORMLOOP ------------------
// -------------------------------------------------------------------
// init project

var express = require('express');
var app = express();
var path = require('path');
var forecast= require('forecast.io');
var zipdb = require('zippity-do-dah');
var bodyParser = require('body-parser');

var options = {
  APIKey : "72d1d2e42c981ba53d6cf8059be0dedc",
  timeout : 1000
}

var weather = new forecast(options);

// http://expressjs.com/en/starter/static-files.html
app.use(express.static(path.resolve(__dirname,'public')));
app.use(bodyParser.json());

app.set("views", ["views"]);
app.set("view engine", "ejs");

// http://expressjs.com/en/starter/basic-routing.html
app.get("/", function (request, response) {
  response.render("index");
});

//to understand the next line study $.ajax function in cient.js
app.get(/^\/(\d{5})$/, function (request, response, next) {
  var zip = request.params[0];
  var location = zipdb.zipcode(zip);
  // console.log(location);
  if(!location.zipcode){
    next();
    return;
  }

  var lat = location.latitude;
  var lon = location.longitude;

  var options = {
    exclude: 'minutely,hourly,daily,flags,alerts'
  };

  weather.get(lat, lon, options, function(err, data){
    if (err) {
      next();
      return;
    }
    
      //https://stackoverflow.com/questions/19696240/proper-way-to-return-json-using-node-or-express  
      response.setHeader('Content-Type', 'application/json');
      response.status(200).json(data);

  });  
});


app.get("/random/:min/:max", function(req, res) {
  var min = parseInt(req.params.min);
  var max = parseInt(req.params.max);
  if (isNaN(min) || isNaN(max)) {
    res.status(400);
    res.json({ error: "Bad request." });
  return;
  }

  var result = Math.round((Math.random() * (max - min)) + min);
  res.json({ result: result });
});

app.use(function (request, response){
  response.status(404).render("404");
});

// listen for requests :)
var listener = app.listen(process.env.PORT, function () {
  console.log('Your app is listening on port ' + listener.address().port);
});