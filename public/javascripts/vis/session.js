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
            words[w] = [word.count, word.literal]
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
    for(t in data) {
        var x = max_radio*0.5 + Math.floor(Math.random()*(size_x - max_radio)) 
        var y = max_radio*0.5 + Math.floor(Math.random()*(size_y - max_radio)) 
        tag = data[t]
        positions[t] = [x,y]

        color = "hsb(" + start + ", 1, 1)"
        color_stroke = "hsb(" + start + ", 0.3, 0.1)"
        radio = tag[0] * max_radio * 0.6
        var circle = raphael.circle(x, y, radio)
        circle.attr("fill", color).attr('opacity',0.4).attr('stroke', "#FFFFFF")

    }
 
    for(t in data) {
        tag = data[t]
        x = positions[t] [0]
        y = positions[t] [1]

        radio = tag[0]*tag[0] * 40 + 10
        var attr = {font: radio + 'px Georgia, serif', opacity: 0.9};
        raphael.text(x, y, tag[1]).attr(attr)
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
