module AppNotificationsHelper

 def self.issuenotification
   
     @issues = Issue.where("status_id not in (5,6,9,16) and assigned_to_id is not null")
     @issues_def = Issue.where("status_id in (5,6,9,16) and assigned_to_id is not null")
     @app_notifications = AppNotification.includes(:issue, :author, :journal, :kbarticle, :news).order("created_on desc")
     @notification_destroy  = @app_notifications.where(viewed: true, is_tmp: 1)
   if @notification_destroy.length > 0
      @notification_destroy.each do |notification|
         notification.destroy
      end
   end
     @app_notifications = @app_notifications.where(viewed: false)
   
    @issues_def.each do |issue|
    @del_notification = @app_notifications.where(issue_id: issue.id, is_tmp: 1, recipient_id: issue.assigned_to_id)
    if @del_notification.length > 0
     @del_notification.each do |notification|
        notification.destroy
     end
    end

    end
     @issues.each do |issue|
     notifications = @app_notifications.where(issue_id: issue.id, is_tmp: 1, recipient_id: issue.assigned_to_id)
      if notifications.length != 0
        notifications.each do |notification|
           notification.destroy
        end
      end
        tmp = issue
        @app_notifications_is_exist = @app_notifications.where(is_tmp: 0, issue_id: issue.id, recipient_id: issue.assigned_to_id)
      if !issue.due_date.nil? and @app_notifications_is_exist.length == 0
        days = (issue.due_date - Date.parse(Time.now.strftime("%Y-%m-%d"))).to_i
      if  days < 4 and issue.status_id != 5 and issue.status_id != 6 and issue.status_id != 9 and issue.status_id != 16
        appnotification = AppNotification.new(created_on: Time.now, viewed: 0, journal_id: nil, issue_id: issue.id, author_id: tmp.author_id, recipient_id: tmp.assigned_to_id, news_id: nil, article_id: nil, days: days, is_tmp: 1)
        appnotification.save
      end
      end
    end
end

end
