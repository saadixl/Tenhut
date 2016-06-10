terminalHtml = '<section class="terminal col-md-12">
                    <div class="command-container">
                        <div class="command">
                            <input type="text" class="form-control">
                            <span class="add-command">Add Command</span>
                            <span class="delete-command">Delete</span>
                            <i class="fa fa-arrows-alt" aria-hidden="true"></i>
                        </div>
                    </div>
                    <div class="control">
                        <span class="add-terminal">Add Terminal</span>
                        <span class="delete-terminal">Delete</span>
                        <i class="fa fa-arrows-alt" aria-hidden="true"></i>
                    </div>
                </section>'

commandHtml = '<div class="command">
                <input type="text" class="form-control">
                <span class="add-command">Add Command</span>
                <span class="delete-command">Delete</span>
                <i class="fa fa-arrows-alt" aria-hidden="true"></i>
               </div>'

# Add terminal
$(".terminal-container").delegate ".add-terminal", "click", ->
    $(this).parent().parent().parent().append terminalHtml
    $(".delete-terminal").show() if $(".terminal").length > 1
    callSortable()

# Delete terminal
$(".terminal-container").delegate ".delete-terminal", "click", ->
    return if $(this).parent().parent().parent().find(".terminal").length == 1
    $(this).parent().parent().remove();

# Add command
$(".terminal-container").delegate ".add-command", "click", ->
    $(this).parent().parent().append(commandHtml);
    $(".delete-command").show() if $(this).parent().parent().find(".command").length > 1
    callSortable()

# Delete command
$(".terminal-container").delegate ".delete-command", "click", ->
    return if $(this).parent().parent().find(".command").length == 1
    $(this).parent().remove();

#Generate

generate = () ->
    singleTerminal = "<p>#!/bin/bash</p>"
    $(".terminal").each ->
        singleTerminal += "<p>osascript -e 'tell application \"Terminal\" to do script \""
        commandChildren = $(this).find(".command-container").children(".command")
        commandChildren.each (index) ->
            singleTerminal += $(this).find("input").val()
            singleTerminal += " && " if index != commandChildren.length - 1
        singleTerminal += "\"'</p>"
    $("#result").empty()
    $("#result").append(singleTerminal)

# Triggers

$(document).delegate "input", "keyup", ->
    generate()

# Copy to clipboard
clipboard = new Clipboard('.copy-code');
new Clipboard('.copy-code', {
     text: (trigger) ->
         clipboardText = ""
         $("#result p").each ->
             clipboardText += $(this).text() + "\n"
         return clipboardText
})

callSortable = () ->
    $( ".terminal-container, .command-container" ).sortable({
            stop: (event, ui) ->
                generate()
        })
    $( ".terminal-container, .command-container" ).disableSelection()

callSortable()
