/**
 * session visualization
 */




data_tags_test = [[63, "proyectos"], [76, "ciudadanas"], [80, "parte"], [82, "Plan"], [87, "senora"], [90, "derechos"], [92, "ley"], [104, "Comunidad"], [128, "Grupo"], [154, "Gracias"]]


/**
 
 */
function tags_circles(raphael, data) {
    
    positions = []
    var start = Math.random()
    for(t in data) {
        var x = Math.floor(Math.random()*400) + 100
        var y = Math.floor(Math.random()*200) + 100
        tag = data[t]
        positions[t] = [x,y]

        color = "hsb(" + start + ", 1, 1)"
        color_stroke = "hsb(" + start + ", 0.3, 0.1)"
        radio = tag[0] * 0.6
        var circle = raphael.circle(x, y, radio)
        circle.attr("fill", color).attr('opacity',0.4).attr('stroke', "#FFFFFF")

        //text
        var attr = {font: tag[0]*tag[0]*0.03 + 'px Georgia, serif', opacity: 0.9};
        //raphael.text(x, y, tag[1]).attr(attr)
        //circle.attr("stroke", "#fff");
        //start += 0.1
    }
 
    for(t in data) {
        tag = data[t]
        x = positions[t] [0]
        y = positions[t] [1]

        var attr = {font: tag[0]*0.3 + 'px Georgia, serif', opacity: 0.9};
        raphael.text(x, y, tag[1]).attr(attr)
    }

}

/*
function vis_session_tags(where, session_json_url) {
    var paper = Raphael(10, 50, 320, 200);
    // Creates circle at x = 50, y = 40, with radius 10
    var circle = paper.circle(50, 40, 10);
    // Sets the fill attribute of the circle to red (#f00)
    circle.attr("fill", "#f00");

    // Sets the stroke attribute of the circle to white
    circle.attr("stroke", "#fff");

}
*/

