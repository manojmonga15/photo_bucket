$(document).ready(function(){
  if($('#pb-bucket').length > 0) {
    $(window).scroll(bindScroll);
  }

  $('.hide-comments').click(function(){
    $('#pb-comments-container').html('');
    $('.show-comments').removeClass('hidden');
    $('.hide-comments').addClass('hidden');
  })
});

function loadMore(){
  var scrollable_url = $('#scrollable-url');
  if(scrollable_url.length > 0 && scrollable_url.val() !== undefined && scrollable_url.data('load') != 'no') {
    $('.load-more').show();
    $.get(scrollable_url.val(), function(data){
      $(window).bind('scroll', bindScroll);
    }).always(function(){
      $('.load-more').hide();
    });
  }
}

function bindScroll(){
  if($(window).length > 0 && ($(window).scrollTop() + $(window).height() > $(document).height() - 100)) {
    $(window).unbind('scroll');
    loadMore(scrollable);
  }
}