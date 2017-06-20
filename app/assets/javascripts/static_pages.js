$(function() {
  $("#search_form input").keyup(function() {
    $.get($("#search_form").attr("action"), $("#search_form").serialize(), null, "script");
      return false;
    });
});