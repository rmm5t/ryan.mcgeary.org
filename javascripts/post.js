(function($) {
  $(document).ready(function() {
    $("#comments a[href$=#disqus_thread]").commentToggler();
    showCommentsIfNecessary();
  });

  var showCommentsIfNecessary = function() {
    if (window.location.toString().match(/#disqus_thread$/)) {
      $("#comments a[href$=#disqus_thread]").hide();
      $("#disqus_thread").show();
    }
  }; 

  $.fn.commentToggler = function() {
    this.click(function() {
      $(this).fadeOut(function() { $("#disqus_thread").fadeIn(); });  
    });
  };
})(jQuery);

