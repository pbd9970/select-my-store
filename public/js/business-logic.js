(function() {
  var BusinessLogic = function() {
    window.qualities;
    window.choosenQualities = [];

    $.get("/api/qualities", function(data) {
      window.qualities = data;
      ui.renderButtons();
    });

  };

  window.bl = new BusinessLogic();
})();
