function changeTextAreaFont() {
    var elements = document.getElementsByTagName('textarea');
    for(var i = 0; i < elements.length; i++) {
        elements[i].style.fontFamily = 'monospace';
    }
}

function resizeFirstTextAreaHeight(size) {
    var elements = document.getElementsByTagName('textarea');
    if (elements.length > 0) {
        var height = parseInt(elements[0].style.height);
        elements[0].style.height = (height + size) + "px";
    }
}

function insertText(text) {
    var elem = document.activeElement;
    var startPos = elem.selectionStart;
    var endPos = elem.selectionEnd;
    var caretPos = startPos + text.length;
    elem.value = elem.value.substring(0, startPos) + text + elem.value.substring(endPos, elem.value.length);
    lem.setSelectionRange(caretPos, caretPos);
}
