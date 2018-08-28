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
                
                // single notification toggle
                if (link.parent().hasClass('notification')) {
                    if (link.parent().hasClass('new')) {
        	        link.parent().removeClass("new");
                    } else {
        	        link.parent().addClass("new");
                    }
                }
                // group notices toogle
                else {
                    if (link.parent().parent().parent().hasClass('new')) {
        	        link.parent().parent().parent().removeClass("new");
                    } else {
        	        link.parent().addClass("notification new"); // Mark as seen only for single notification
                    }
                }
        	link.remove();
		$.ajax({
        	type: "GET",
        	url: $(this).attr("href"),
        	dataType: 'html',
        	success: function() {
        		//link.parent().removeClass( "new" );
        		//link.remove();
			}
        });
		return false;
	});

        $.ajax({
        type: "GET",
        url: "/app-notifications/unread-number/",
        dataType: 'json',
        success: function(data) {
                     $("#notification_count").text(data);
                     $("#notification_count").show();
                 }
        });
        $("#notification_count").click(function()
        {
                window.open("/app-notifications/", "_blank");
        });
        $("#notification_count").hover(function()
        {
                $(this).css("cursor","pointer");
        });

});
