var Mustache = require("mustache")
var result = Mustache.render("Hi, {{first}}, {{last}}!", {
	first: "Nick",
	last: "Cage"
});
console.log(result);
