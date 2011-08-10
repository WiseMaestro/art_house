//functions to trigger CSS animations to create a menu.

function growit(){
var elem = document.getElementById("mouseexpand");
  elem.style.WebkitDuration = "2000ms";
    elem.style.WebkitAnimationName = "growlist";
    
}

function shrinkit(){
var elem = document.getElementById('mouseexpand');


    elem.style.WebkitAnimationDuration = '5000ms';
    elem.style.WebkitAnimationName = 'shrinklist';



}