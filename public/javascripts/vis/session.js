/**
 * session visualization
 */

data_tags_test = [[63, "proyectos"], [76, "ciudadanas"], [80, "parte"], [82, "Plan"], [87, "senora"], [90, "derechos"], [92, "ley"], [104, "Comunidad"], [128, "Grupo"], [154, "Gracias"]]

function get_words(data, count, callback) {
       var words = []
       var max = 0

       // extract information
       for(var w in data) {
            word = data[w]
            words[w] = [word.count, word.literal, word.stem, word.pos]
            if (word.count > max) {
                max = word.count
            }
       }

       // sort 
       words.sort(function(a, b) {
            return b[0] - a[0];
       })

       // normalize
       words = words.slice(0, count)
       for(var w in words) {
            words[w][0] = words[w][0]/max
       }
       callback(words)
}

/**
 * words for a session
 */
function get_session_words(url, count, callback) {
    jQuery.getJSON(url, function(data) {
        get_words(data['words_json'], count, callback)
    })
}

/**
 * global words 
 */
function get_relevant_words(url, count, callback) {
    jQuery.getJSON(url, function(data) {
        get_words(data, count, callback)
    })
}


/**
 
 */
function tags_circles(raphael, data, size_x, size_y) {
    
    positions = []
    var start = Math.random()
    max_radio = size_x/5;
    center_x = size_x*0.5
    center_y = size_y*0.5
    for(t in data) {
        tag = data[t]

        var x = max_radio*0.5 + Math.floor(Math.random()*(size_x - max_radio)) 
        var y = max_radio*0.5 + Math.floor(Math.random()*(size_y - max_radio)) 

        var normalized_radio = tag[0]
        distance_from_center = 1.0 - normalized_radio
        distance_from_center = 0.5 + (distance_from_center)*0.7

        radio = tag[0] * max_radio * 0.6
        
        if(false) {
            x = center_x + (2.0*Math.random() - 1.0)*distance_from_center*(size_x-max_radio)*.5
            y = center_y + (2.0*Math.random() - 1.0)*distance_from_center*(size_y-max_radio)*.5
        }
        


        color = "hsb(" + start + ", 1, 1)"
        color_stroke = "hsb(" + start + ", 0.3, 0.1)"
        var circle = raphael.circle(x, y, radio)
        circle.attr("fill", color).attr('opacity',0.4).attr('stroke', "#FFFFFF")
        positions[t] = [x,y,circle]
        /*
        circle.mouseover (function() {
            this.animate({scale: [1.0, 1.1, 1.0, 1.0]}, 2000, 'elastic')
        })
        circle.mouseout( function() {
            this.animate({scale: [1.0, 1.0, 1.0, 1.0]}, 2000, 'elastic')
        })
        */

    }
 
    for(t in data) {
        tag = data[t]
        x = positions[t] [0]
        y = positions[t] [1]
        var c = positions[t] [2]

        radio = tag[0]*tag[0] * 40 + 10
        var attr = {font: radio + 'px Georgia, serif', opacity: 0.8};
        var text = raphael.text(x, y, tag[1]).attr(attr)
        text.circle = c
        text.text = tag[1]
        text.link_stem = tag[2]
        text.link_pos= tag[3]
        text.mouseover (function() {
            this.animate({fill: "#FFFFFF"}, 200, 'linear')
            this.circle.animate({scale: [1.2, 1.2], opacity: 0.9, "stroke-width": 8, "stroke": "#EEEEEE"}, 2000, 'elastic')
        })
        text.mouseout (function() {
            this.animate({fill: "#000000"}, 200, 'linear')
            this.circle.animate({scale: [1.1, 1.1], opacity: 0.4, "stroke-width": 2, "stroke": "#FFFFFF"}, 2000, 'elastic')
        })
        text.click(function() {
            window.location = '/tags/' + this.link_stem + "?pos=" + this.link_pos

        })
        
    }

}


function session_get_intervention_per_MP(url, callback) {
    jQuery.getJSON(url, function(data) {
        var names = {}
        var max = 0 
        data.each(function(obj) {
        //for(var w in data) {
            var name = obj.parliament_member.name
            var count = obj.content.length
            if (name in names) {
                names[name] +=  count
            } else {
                names[name] =  count
            }
            max += count
        })
        //normalize
        for(var n in names) {
            names[n] = names[n] / max;
        }
        callback(names)
    })
}
