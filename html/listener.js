$(function(){
    window.onload = function(e) {
        window.addEventListener("message", (event) => {
            var item = event.data;
            if (item !== undefined && item.type === "ui"){
                if (item.display === true){
                    $("#container").show();
                    //var elem2 = document.getElementById("myPoint");
                    //elem2.style.left = 50 + item.randomNum + "%";
                    /*  var elem = document.getElementById("myBar");
                      var width = 1;
                      setInterval(function frame() {
                        if (width >= 100) {
                          elem.style.width = 0;
                          width = 1;
                        } else {
                          width++;
                          elem.style.width = width + "%";
                        }
                      }, item.tiempoFarm*10);*/

                }else{
                    $("#container").hide();
                }
            }
        })
    }
})

//Math.floor(Math.random() * 15) + 1