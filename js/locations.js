// self executing function loads locations from locations.json
(function() {
    loadJSON();
})();

function loadJSON() {
    var xmlhttp = new XMLHttpRequest();

    xmlhttp.onreadystatechange = function() {
        if (xmlhttp.readyState == XMLHttpRequest.DONE ) {
            if (xmlhttp.status == 200) {
                handleJSON(xmlhttp.responseText);
            }
            else if (xmlhttp.status == 400) {
                document.getElementById("locations-list").innerHTML = "<p>Unable to retrieve locations at this time.</p>";
            }
            else {
                document.getElementById("locations-list").innerHTML = "<p>Unable to retrieve locations at this time.</p>";
            }
        }
    };

    xmlhttp.open("GET", "js/locations.json", true);
    xmlhttp.send();
}

function handleJSON(data) {
    var json = JSON.parse(data);
    var text = "";
    var loc;
    for (i = 0; i < json.locations.length; i++) {
        loc = json.locations[i];
        text += "<p>";
        json.catalog_info.tags.forEach(addToText);
        text += "</p>";
    }
    document.getElementById("locations-list").innerHTML = text;

    function addToText(item, index) {
        if (loc[item]) {
            switch (item) {
                case "title":
                    text += "<b>" + loc.title + "</b><br>";
                    break;
                case "city":
                    text += loc.city + ", ";
                    break;
                case "state":
                    text += loc.state + " ";
                    break;
                case "zip":
                    text += loc.zip + "<br>";
                    break;
                case "website":
                    text += "<a href='http://" + loc.website + "' target='_blank'>" + loc.website + "</a><br>";
                    break;
                case "email":
                    text += "<a href='mailto:" + loc.email + "'>" + loc.email + "</a><br>";
                    break;
                default:
                    text += loc[item] + "<br>";
            }
        }
    }
}
