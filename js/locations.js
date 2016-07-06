var json;
var locations, loc, locIndex;
var stateMap;
var stateTextArray, locationTextArray;

// self executing function loads locations from locations.json
(function () {
    loadJSON();
    document.getElementById("back-to-top").onclick = function() {
        window.scrollTo(0,0);
    }
})();

window.onscroll = function() {backToTop()};

function backToTop() {
    if (document.body.scrollTop > 50 || document.documentElement.scrollTop > 50) {
        document.getElementById("back-to-top").className = "button button-small clear-visible";
    } else {
        document.getElementById("back-to-top").className = "button button-small clear-hidden";
    }
}

function loadJSON() {
    var xmlhttp = new XMLHttpRequest();

    xmlhttp.onreadystatechange = function () {
        if (xmlhttp.readyState == XMLHttpRequest.DONE) {
            if (xmlhttp.status == 200) {
                generateHtmlFromJSON(xmlhttp.responseText);
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

function generateHtmlFromJSON(data) {
    json = JSON.parse(data);
    locations = json.locations.sort(compareLocations);
    stateMap = json.catalog_info.state_map;
    var stateList = getSortedKeyList(stateMap);
    var canadaStateList = json.catalog_info.canada_state_list.sort();
    stateTextArray = [];
    locationTextArray = [];
    locIndex = 0;
    handleStates(stateList, false);
    handleStates(canadaStateList, true);

    document.getElementById("state-list").innerHTML = "<p>" + stateTextArray.join(", ") + "</p>";
    document.getElementById("locations-list").innerHTML = locationTextArray.join("");
}

function handleStates(stateList, isCanadianList) {
    var state;
    var stateIndex = 0;
    while (stateIndex < stateList.length && locIndex < locations.length) {
        state = stateList[stateIndex];
        var stateFound = false;
        while (locIndex < locations.length) {
            loc = locations[locIndex];
            if (!isCanadianList && isInCanada(loc)) {
                return;
            }
            if (state == loc.state && !stateFound) {
                // First time matching the state to an address from the locations list
                if (isCanadianList) {
                    var stateId = "canada-" + state;
                    stateTextArray.push("<a href='#" + stateId + "'>" + state + "</a>");
                    locationTextArray.push("<h3 id='" + stateId + "' class='state-header'>" + state + ", Canada</h3>");
                } else {
                    stateTextArray.push("<a href='#" + state + "'>" + state + "</a>");
                    locationTextArray.push("<h3 id='" + state + "' class='state-header'>" + stateMap[state] + " (" + state + ")</h3>");
                }
                addLocation();
                stateFound = true;
                locIndex++;
            } else if (state == locations[locIndex].state) {
                // All other times matching the state to an address
                addLocation();
                locIndex++;
            } else if (!stateFound) {
                if (!isCanadianList) {
                    stateTextArray.push(state);
                }
                break;
            } else {
                break;
            }
        }
        stateIndex++;
    }
}

function addLocation() {
    locationTextArray.push("<p class='location-address'>");
    json.catalog_info.tags.forEach(addToText);
    locationTextArray.push("</p>");
}

function addToText(item, index) {
    if (loc[item]) {
        switch (item) {
            case "title":
                locationTextArray.push("<b>" + loc.title + "</b><br>");
                break;
            case "city":
                locationTextArray.push(loc.city + ", ");
                break;
            case "state":
                locationTextArray.push(loc.state + " ");
                break;
            case "zip":
                locationTextArray.push(loc.zip + "<br>");
                break;
            case "phone1":
                locationTextArray.push("Phone: " + loc.phone1 + "<br>");
                break;
            case "phone2":
                locationTextArray.push("Phone: " + loc.phone2 + "<br>");
                break;
            case "fax":
                locationTextArray.push("Fax: " + loc.fax + "<br>");
                break;
            case "website":
                locationTextArray.push("<a href='http://" + loc.website + "' target='_blank'>" + loc.website + "</a><br>");
                break;
            case "email":
                locationTextArray.push("<a href='mailto:" + loc.email + "'>" + loc.email + "</a><br>");
                break;
            default:
                locationTextArray.push(loc[item] + "<br>");
        }
    }
}

function compareLocations(a, b) {
    // Sort first by country
    if (!a.country && b.country) {
        return -1;
    }
    if (a.country && !b.country) {
        return 1;
    }
    // Then by state
    if (a.state < b.state) {
        return -1;
    }
    if (a.state > b.state) {
        return 1;
    }
    // Then by title
    if (a.title < b.title) {
        return -1;
    }
    if (a.title > b.title) {
        return 1;
    }
    return 0;
}

function isInCanada(loc) {
    return (loc.country && loc.country.toLowerCase() == "canada");
}

function getSortedKeyList(map) {
    var stateList = [];
    for (var state in map) {
        stateList.push(state);
    }
    return stateList.sort();
}
