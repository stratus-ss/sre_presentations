var cnt=document.getElementById("count"); 
var water=document.getElementById("water");
var percent=cnt.innerText;
var interval;
var counter=0;
function incrementCount(){
    document.querySelector('#score').disabled=true;
    percent=0;
interval=setInterval(function(){
  percent++; 
  cnt.innerHTML = percent; 
  water.style.transform='translate(0'+','+(100-percent)+'%)';
  if(percent==100){
    clearInterval(interval);
  }
  counter++;
    if(counter%100 === 0){
  	document.querySelector('#score').disabled=false;
  }
  document.getElementById('number').value = counter;
},40);

}