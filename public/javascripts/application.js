// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
CortesAbiertas = {

    show_points_of_day: function(id) {
        var div = 'session_summary_' + id;
        var link = 'session_summary_pod_link' + id;
        var old = jQuery("#session_summary_pod_link_"+id).text()
        if(old === "mostrar") {
            jQuery("#session_summary_pod_link_"+id).text("ocultar")
        } else {
            jQuery("#session_summary_pod_link_"+id).text("mostrar")
        }
        $(div).toggle();
    },

    show_bar_adjs_chart: function(id) {

        var all = SessionDataCortesAbiertasAdjs["session_"+id];
        var acum = [];
        for(var _i=0; _i<all.length; _i++) {
            acum.push([all[_i]['literal'],all[_i]['count']]);
        }

	var myChart = new JSChart('chart_adjs_session_'+id, 'bar');
	myChart.setDataArray(acum);
        myChart.setSize(250, 200);
        myChart.setTitle("Adjetivos");
        myChart.setBackgroundColor("#FFF");
        myChart.setBarColor("#F00");
        myChart.setAxisNameY("");
        myChart.setAxisNameX("");
	myChart.draw();
    },

    show_bar_nouns_chart: function(id) {

        var all = SessionDataCortesAbiertasNouns["session_"+id];
        var acum = [];
        for(var _i=0; _i<all.length; _i++) {
            acum.push([all[_i]['literal'],all[_i]['count']]);
        }

	var myChart = new JSChart('chart_nouns_session_'+id, 'bar');
	myChart.setDataArray(acum);
        myChart.setSize(250, 200);
        myChart.setTitle("Sustantivos");
        myChart.setBackgroundColor("#FFF");
        myChart.setBarColor("#0F0");
        myChart.setAxisNameY("");
        myChart.setAxisNameX("");
	myChart.draw();
    },

    show_bar_verbs_chart: function(id) {

        var all = SessionDataCortesAbiertasVerbs["session_"+id];
        var acum = [];
        for(var _i=0; _i<all.length; _i++) {
            acum.push([all[_i]['literal'],all[_i]['count']]);
        }

	var myChart = new JSChart('chart_verbs_session_'+id, 'bar');
	myChart.setDataArray(acum);
        myChart.setSize(250, 200);
        myChart.setTitle("Verbos");
        myChart.setBackgroundColor("#FFF");
        myChart.setBarColor("#00F");
        myChart.setAxisNameY("");
        myChart.setAxisNameX("");
	myChart.draw();
    },

    show_big_bar_adjs_chart: function() {

        var all = SessionDataCortesAbiertasAdjs["adjs"];
        var acum = [];
        for(var _i=0; _i<all.length; _i++) {
            acum.push([all[_i]['literal'],all[_i]['count']]);
        }

	var myChart = new JSChart('chart_adjs_session', 'bar');
	myChart.setDataArray(acum);
        myChart.setSize(700, 300);
        myChart.setTitle("Adjetivos");
        myChart.setBackgroundColor("#FFF");
        myChart.setBarColor("#F00");
        myChart.setAxisNameY("");
        myChart.setAxisNameX("");
	myChart.draw();
    },

    show_big_bar_nouns_chart: function(id) {

        var all = SessionDataCortesAbiertasNouns["nouns"];
        var acum = [];
        for(var _i=0; _i<all.length; _i++) {
            acum.push([all[_i]['literal'],all[_i]['count']]);
        }

	var myChart = new JSChart('chart_nouns_session', 'bar');
	myChart.setDataArray(acum);
        myChart.setSize(700, 300);
        myChart.setTitle("Sustantivos");
        myChart.setBackgroundColor("#FFF");
        myChart.setBarColor("#0F0");
        myChart.setAxisNameY("");
        myChart.setAxisNameX("");
	myChart.draw();
    },

    show_big_bar_verbs_chart: function(id) {

        var all = SessionDataCortesAbiertasVerbs["verbs"];
        var acum = [];
        for(var _i=0; _i<all.length; _i++) {
            acum.push([all[_i]['literal'],all[_i]['count']]);
        }

	var myChart = new JSChart('chart_verbs_session', 'bar');
	myChart.setDataArray(acum);
        myChart.setSize(700, 300);
        myChart.setTitle("Verbos");
        myChart.setBackgroundColor("#FFF");
        myChart.setBarColor("#00F");
        myChart.setAxisNameY("");
        myChart.setAxisNameX("");
	myChart.draw();
    }

}

