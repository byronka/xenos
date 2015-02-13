document.onreadystatechange = function () {
  if (document.readyState === 'complete') {
    xenos.run();
  }
}

var xenos = {};

xenos.run = function() {
 xenos.convert_rank_to_stars();
};

//Finds each of the rank elements and converts the numeral to
//stars using the unicode character for white and black stars.
//5 stars total.
xenos.convert_rank_to_stars = function() {
  var elements = document.getElementsByClassName('rank value');

  for (var i = 0; i < elements.length; i++) {
    var rank = +elements[i].innerHTML;
    
    //defensive code
    if (rank > 100) {
      //make them all filled stars
      elements[i].innerHTML = "&#x2605; &#x2605; &#x2605; &#x2605; &#x2605;";
    }

    if (rank < 0) {
      //make them all unfilled stars
      elements[i].innerHTML = "&#x2606; &#x2606; &#x2606; &#x2606; &#x2606;";
    }
    //defensive code ends

    var num_stars_float = (rank/100) * 5; //5 stars
    var num_filled_stars = Math.ceil(num_stars_float);
    var star_text = "";
    for (var j = 0; j < 5; j++) {
      if (j < num_filled_stars) {
        star_text += "&#x2605; ";
      } else {
        star_text += "&#x2606; ";
      }
    }
    elements[i].innerHTML = star_text;
      
  }
};


