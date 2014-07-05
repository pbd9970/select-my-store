(function() {

  var UI = function() {

    self = this;

    this.renderButtons = function() {
      console.log('is this running');
      var qualitiesToRender = window.qualities;
      window.qualitiesHTML = self.makeQualityBtns(qualitiesToRender);
      $('ul#qualityPool').append(qualitiesHTML);
    };

    this.addQualityButton = function (label, classAppend, target) {
      window.qualitiesHTML = self.makeQualityBtns([label], classAppend);
      $(target).append(qualitiesHTML);
    };

    this.renderChoosenButtons = function() {
      console.log('is this running');
      var qualitiesToRender = window.choosenQualities;
      window.qualitiesHTML = self.makeQualityBtns(qualitiesToRender, 'chosen');
      $('.chosen-qualities').append(qualitiesHTML);
    };

    this.makeQualityBtns = function(daQualities, classAppend) {
      var html = "";

      if(!classAppend) {
        classAppend = '';
      }

      console.log('what are qualities when makeQualityBtns first runs', daQualities);
      for(var i = 0; i < daQualities.length; i++) {
        console.log('is this looping');
        html += "<li><a href='#' data-quality=" + daQualities[i] + " class='button quality-btns "+classAppend+"'>" + daQualities[i] + "</a></li>";
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
    $(this).parent('li').remove();

    if($(this).hasClass('chosen')) {
      //ui.addQualityButton(clickedQuality);

      ui.addQualityButton(clickedQuality, '', 'ul#qualityPool');
    }
    else {
      //window.choosenQualities.push(clickedQuality);
      //ui.renderChoosenButtons();

      ui.addQualityButton(clickedQuality, 'chosen', '.chosen-qualities');
    }

    if($('.chosen').size()>0){


    }

  });

})();
