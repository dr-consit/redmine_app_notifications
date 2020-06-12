function urlSetParam(uri, key, val) {
    return uri
        .replace(new RegExp("([?&]"+key+"(?=[=&#]|$)[^#&]*|(?=#|$))"), "&"+key+"="+encodeURIComponent(val))
        .replace(/^([^?&]+)&/, "$1?");
}

$(document).ready(function()
{
	$("#notificationsLink").click(function()
	{
		$("#notificationsContainer").remove();

		$.ajax({
        	type: "GET",
        	url: $(this).attr("href"),
        	dataType: 'html',
        	success: function(data) {
				$("#notificationsLink").parent().addClass('notification_li');
				$("#notificationsLink").parent().append(data);
				$("#notificationsContainer").fadeToggle(300);
			}
        });

		return false;
	});

	//Document Click
	$(document).click(function()
	{
		$("#notificationsContainer").hide();
	});
	//Popup Click
	$("#notificationsContainer").click(function()
	{
		return false;
	});

	$(".view-notification").click(function()
	{
		var link = $( this );

		$.ajax({
        	    type: "GET",
        	    url: $(this).attr("href"),
        	    dataType: 'html',
        	    success: function() {
        		//link.parent().removeClass( "new" );
        		//link.remove();
		    }
                });
                
                // single notification toggle
                if (link.parent().hasClass('notification')) {
                    if (link.parent().hasClass('new')) {
        	        link.parent().removeClass("new");
                        link.attr('href', urlSetParam(link.attr('href'), 'mark_as_unseen', ''));
                        link.text(locale_str_mark_as_unseen).fadeIn();
                    } else {
        	        link.parent().addClass("new");
                        link.attr('href', urlSetParam(link.attr('href'), 'mark_as_unseen', 1));
                        link.text(locale_str_mark_as_seen).fadeIn();
                    }
                }
                // group notices toogle
                else {
                    if (link.parent().parent().parent().hasClass('new')) {
                        group_parent = link.parent().parent().parent()
        	        group_parent.removeClass("new");
                        all_links = group_parent.find('.view-notification')
                        all_links.attr('href', urlSetParam(all_links.attr('href'), 'mark_as_unseen', ''));
                        all_links.text(locale_str_mark_as_unseen).fadeIn();
                    } else {
        	        link.parent().addClass("notification new"); // Mark as seen only for single notification
                        link.attr('href', urlSetParam(link.attr('href'), 'mark_as_unseen', 1));
                        link.text(locale_str_mark_as_seen).fadeIn();
                    }
                }

		return false;
	});

        if ($('#notificationsLink').length > 0) // in case of double Login Popup Window at signin page
        {
        $.ajax({
            type: "GET",
            url: "/app-notifications/unread-number/",
            dataType: 'json',
            success: function(data) {
                $("#notification_count").text(data);
                $("#notification_count").show();
            }
        });
        }

        $("#notification_count").click(function()
        {
            window.open("/app-notifications/", "_blank");
        });

        $("#notification_count").hover(function()
        {
            $(this).css("cursor","pointer");
        });

});
