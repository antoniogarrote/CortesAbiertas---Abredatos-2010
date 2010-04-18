// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
CortesAbiertas = {

    show_points_of_day: function(id) {
        var div = 'session_summary_' + id;
        var link = 'session_summary_pod_link' + id;
        var old = jQuery("#session_summary_pod_link_4").text()
        if(old === "mostrar") {
            jQuery("#session_summary_pod_link_4").text("ocultar")
        } else {
            jQuery("#session_summary_pod_link_4").text("mostrar")
        }
        $(div).toggle();
    },

    hello: function() {
        alert("hola");
    }
    
}
    
