// client-side js
// run by the browser each time your view template is loaded
// by default, you've got jQuery,
// add other scripts at the bottom of index.html

$(document).ready(function ()  {
  console.log('hello world :o');

  var $h1 = $("h1");
  //var $h2 = 
  var $zip = $("input[name='zip']");
  
  $("form").on("submit" , function(event){
    
    event.preventDefault();
    
    var zipcode= $.trim($zip.val());
    
    $h1.text("Loading...");
    
    var request = $.getJSON({
                    url:"/"+zipcode,
                    complete: function(data){ 
                      var temp = JSON.parse(data.responseJSON.body);JSON 
                      //3 days to figure out
                      $h1.html("it is "+Math.round(((temp.currently.temperature-32)*5)/9)+"&#176;C in " + temp.timezone+" ."); 
                    }
    });
   
    request.fail(function(){
      $h1.text("error!"); 
    });
  });
});