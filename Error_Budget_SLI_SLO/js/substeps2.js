var substepsAll = document.querySelectorAll(".substep");
for (var i = 0; i < substepsAll.length; i++) {
    substepsAll[i].classList.add("future");
}

// var steps = document.querySelectorAll(".step");
// var stepsf = document.querySelectorAll(".step .future");
// var stepsp = document.querySelectorAll(".step .past");
// if (stepsf.length === 0) {
//     for (var i = 0; i < stepp.length; i++) {
//     substepsAll[i].classList.remove("past");
//     substepsAll[i].classList.add("future");
//    }
// }

function substepNext() {
    var activeStep = document.querySelector(".step.active");
    var future = activeStep.querySelectorAll(".future");
    var present = activeStep.querySelectorAll(".present");
    var past = activeStep.querySelectorAll(".past")

    if (future.length === 0) {
        impress().next(); 
        present[0].classList.add("future");
        present[0].classList.remove("present");
         for (var i = 0; i < past.length; i++) {
        past[i].classList.add("future");
        past[i].classList.remove("past"); 
       }

    } else {
        future[0].classList.add("present");
        future[0].classList.remove("future");
        if (present.length > 0) {
            present[0].classList.add("past");
            present[0].classList.remove("present");
        }
        var event = document.createEvent("CustomEvent");
        event.initCustomEvent("impress:substep:enter", true, true);
        future[0].dispatchEvent(event);
    }
   
}

function substepPrev() {
    impress().prev();
}

document.addEventListener("keyup", function (event) {
    if (event.keyCode === 9 || (event.keyCode >= 32 && event.keyCode <= 34) || (event.keyCode >= 37 && event.keyCode <= 40)) {
        switch (event.keyCode) {
        case 33: // pg up
        case 37: // left
        case 38: // up
            substepPrev();
            break;
        case 9: // tab
        case 32: // space
        case 34: // pg down
        case 39: // right
        case 40: // down
            substepNext();
            break;
        }

        event.preventDefault();
    }
}, false);