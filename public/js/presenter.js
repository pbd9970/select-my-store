(function() {

  var UI = function() {

    self = this;

    this.renderButtons = function() {
      console.log('is this running');
      var qualitiesToRender = window.qualities;
      window.qualitiesHTML = self.makeQualityBtns(qualitiesToRender);
      $('ul#qualityPool').append(qualitiesHTML);
    };

    this.renderChoosenButtons = function() {
      console.log('is this running');
      var qualitiesToRender = window.choosenQualities;
      window.qualitiesHTML = self.makeQualityBtns(qualitiesToRender);
      $('.chosen-qualities').append(qualitiesHTML);
    };

    this.makeQualityBtns = function(daQualities) {
      var html = "";
      console.log('what are qualities when makeQualityBtns first runs', daQualities);
      for(var i = 0; i < daQualities.length; i++) {
        console.log('is this looping');
        html += "<li><a href='#' data-quality=" + daQualities[i] + " class='button quality-btns'>" + window.qualities[i] + "</a></li>";
      }
      console.log('this is the html to render', html);
      return html;
    };

  };

  window.ui = new UI();


  $(document).on('click', ".quality-btns", function() {
    console.log('you clicked a quality butotn');
    var clickedQuality = $(this).data('quality');
    console.log('what did i click', clickedQuality);
    window.choosenQualities.push(clickedQuality);
    ui.renderChoosenButtons();
  });

})();
