(function ($) {
  var what_if = false;

  $("input[name=what_if_grades]").change(function () {
    what_if = !what_if;

    updatePage(what_if);
  });

  $('body').on('blur', 'input[name=grade_input]', function() {
    var val = parseFloat($(this).val());
    if (!val) {
      $(this).addClass("invalid");
      return;
    } else {
      $(this).removeClass("invalid");
    }

    if ($(this).data("noscore")) {
      $(this).removeData("noscore");
    }

    recalculateGrades();
  });


  function recalculateGrades() {
    var categoryAverages = [];
    $(".grades").each(function () {
      var totalPoints = 0;
      var totalPossible = 0;
      $(this).find("input[name=grade_input]").each(function () {
        if ($(this).parent().data("noscore")) {
          if (parseFloat($(this).val()) > 0) {
            $(this).parent().removeData("noscore")
          } else {
            return;
          }
        }
        totalPoints += parseFloat($(this).val());
        totalPossible += parseFloat($(this).parent().data("max"));
      });

      var average = ((totalPoints / totalPossible) * 100).toFixed(1);
      var footer = $(this).find(".footer");

      footer.find(".total_score").text(totalPoints.toFixed(1));
      footer.find(".max_score").text(totalPossible.toFixed(1));
      footer.find(".average").text("("+average+"%)");

      categoryAverages.push(average);
    });

    var categoryWeights = 100 / categoryAverages.length();
  }

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
        grade_field.data("max", grade.data("max"));

        if (grade.data("noscore")) {
          grade_field.data("noscore", true);
        }

        grade.replaceWith(grade_field);
      });

      recalculateGrades();
    } else {
      window.location.reload();
    }
  }
}(jQuery));
