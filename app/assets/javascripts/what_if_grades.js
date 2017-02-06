(function ($) {
  var what_if = false;

  $("input[name=what_if_grades]").change(function () {
    what_if = !what_if;

    updatePage(what_if);
  });

  $("input").on("blur", "[name=grade_input]", function () {
    var val = parseFloat($(this).val());
    if (!val) {
      $(this).addCalss("invalid");
    } else {
      $(this).addCalss("valid");
    }
  });


  var replacement_form = '<div class="grade-field">' +
            '<input name="grade_input" type="text">'+
            '</div>';

  function updatePage(what_if) {
    if (what_if) {
      $(".grade_received").each(function () {
        var grade_field = $(replacement_form);
        var grade = $(this);
        grade.css("display", "none");
        grade_field.find("input").val(grade.data("grade"));
        grade_field.data("assessment", grade.data("assessment"));
        grade.replaceWith(grade_field);
      })
    } else {
      window.location.reload();
    }
  }
}(jQuery));
