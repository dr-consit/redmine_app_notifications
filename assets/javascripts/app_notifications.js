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
        		link.parent().removeClass( "new" );
        		link.remove();
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
