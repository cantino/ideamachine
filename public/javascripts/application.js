$(function() {
  $('#idea').text("Please hold on, I'm thinking...");
  $('#show_next').click(show_next_idea);
  show_next_idea();
});

function load_ideas(callback) {
  $.getJSON("/ideas/generate.json",
    function(data){
      $('#idea').data('ideas', data);
      if (callback) callback();
    });
}

function show_next_idea() {
  var ideas = $('#idea').data('ideas');
  if (!ideas) {
    load_ideas(show_next_idea);
  } else {
    var idea = ideas.shift();
    $('#idea').fadeOut(100, function() {
      $('#idea').html(idea).fadeIn(100);
    });
    if (ideas.length < 10) load_ideas();
  }
}