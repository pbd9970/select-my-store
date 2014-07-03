$(function() {

  var qualities = ['Smooth 5'];
  addQualities(qualities);

  $('#qualityPool').delegate('li', 'click', function () {
    //move up
    $(this).appendTo("#selectedQualities");

    var params = { 'qualities':[] }
    $('#selectedQualities li a').each(function () {
      params.qualities.push($(this).text());
    });
    console.log(params);
  })

  $('#selectedQualities').delegate('li', 'click', function () {
    //move back
    $(this).appendTo("#qualityPool");
  })

  function addQualities(qualities) {
    var i;

    for(i = 0 ; i < qualities.length ; i ++) {
      $('#qualityPool').append('<li><a href="#" class="button">'+qualities[i]+'</a></li>');
    }
  }

/*
  $('.multiple-items').slick({
    infinite: true,
    slidesToShow: 3,
    slidesToScroll: 3
  });
*/

});
