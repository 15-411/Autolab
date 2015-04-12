/* JavaScript code that will be added to every page throughout the application */


/* Adding CSRF token to every Ajax call by default */

jQuery.ajaxSetup({
    headers: {
        'X-CSRF-Token' : $('meta[name="csrf-token"]').attr('content')
    },
});


/* Moment JS generic converter */
$(".moment-date-time").each(function(ind) {
	$el = $(this);
	var format = $el.data("format")  || "dddd, MMM Do YYYY, h:mm:ss a";
	var unformattedDate = $el.html();
	var formattedDate = moment(unformattedDate, "YYYY-MM-DD hh:mm:ss ZZ").format(format);
	$el.html(formattedDate);
})

/* Activating Tooltips */
$(function () {
  $('[data-toggle="tooltip"]').tooltip()
})


var $ratio = 12.5;
var ferris = $("#ferris"),
    center = $("#center"),
    tl;

TweenLite.set(center, {x:(190/$ratio)-2, y:(190/$ratio)-2});

//a little tricky getting the ferris wheel built, but it serves its purpose
function addArms(numArms) {
  var space = 360/numArms; 
  for (var i = 0; i < numArms; i++){
    var newArm = $("<div>", {class:"arm"}).appendTo(center)
    var newPivot = $("<div>", {class:"pivot outer"}).appendTo(center);
    var newBasket = $("<div>", {class:"basket"}).appendTo(newPivot);
    TweenLite.set(newPivot, {rotation:i*space, transformOrigin:10/$ratio+"px "+210/$ratio+"px"})
    TweenLite.set(newArm, {rotation:(i*space) -90, transformOrigin:"0px "+3/$ratio+"px"})
    TweenLite.set(newBasket, {rotation:  (-i * space), transformOrigin:"50% top" });
  }   
}

//Get this party started
addArms(7);//values between 2 and 12 work best
TweenLite.from(ferris, 1, {autoAlpha:0});

//Animation (super easy)
tl = new TimelineMax({repeat:-1, onUpdate:null});
tl.to(center, 20, {rotation:360,  ease:Linear.easeNone})
//spin each basket in the opposite direction of the ferris wheel at same rate (no math)
tl.to($(".basket"), 20, {rotation:"-=360",  ease:Linear.easeNone},0)

