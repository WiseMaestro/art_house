//functions to trigger CSS animations to create a menu.
function growit(){
	var elem = document.getElementById("mouseexpand");
	elem.style.WebkitAnimationName = "growlist";
	elem.style.MozAnimationName = "growlist";
	elem.style.OTransform = "scale(1,1)";

}

function shrinkit(){
var elem = document.getElementById('mouseexpand');


    elem.style.WebkitAnimationDuration = '5000ms';
    elem.style.WebkitAnimationName = 'shrinklist';
    elem.style.MozAnimationDuration = '5000ms';
    elem.style.MozAnimationName = 'shrinklist';
	elem.style.OTransform = "scale(1,0)";


}

function growitopera(){
	var elem = document.getElementById("mouseexpand");
	elem.style.OTransform = "scale(1,1)";
    elem.style.msTransform = "scale(1,1)";
}

function shrinkitopera(){
var elem = document.getElementById('mouseexpand');
	elem.style.OTransform = "scale(1,0)";
    elem.style.msTransform = "scale(1,0)";
}

