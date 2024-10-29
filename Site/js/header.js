function openPage(o, page) {
    $("#header .onglet").removeClass("active");
    pages = ["accueil", "produits", "contact"];
    for (var i = 0; i < pages.length; i++) {
        var object = "#" + pages[i];
        if (page == pages[i]) {
            $(object).attr("style", "display:block;");
            $(o).addClass("active");
        } else {
            $(object).attr("style", "display:none;");
        }
    }
}