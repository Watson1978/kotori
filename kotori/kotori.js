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
    elem.setSelectionRange(caretPos, caretPos);
}

function addHidden(theForm, key, value) {
    var input = document.createElement('input');
    input.type = 'hidden';
    input.name = key;
    input.value = value;
    theForm.appendChild(input);
}

function saveAsWIP() {
    var form = document.getElementById("post_form");
    addHidden(form, 'save_as_wip', 'Save as WIP');
    form.submit();
}

function shipIt() {
    var form = document.getElementById("post_form");
    addHidden(form, 'save_as_lgtm', 'Ship It!');
    form.submit();
}
