function changeTextAreaFont() {
    var elements = document.getElementsByTagName('textarea');
    for(var i = 0; i < elements.length; i++) {
        elements[i].style.fontFamily = 'monospace';
    }
}
