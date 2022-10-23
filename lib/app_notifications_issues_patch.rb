module AppNotificationsIssuesPatch
  extend ActiveSupport::Concern

  included do
    after_create :create_app_notifications_after_create_issue
  end

  # Returns the users that should be notified
  def my_notified_users
    # Author and assignee are always notified unless they have been
    # locked or don't want to be notified
    notified = [author, assigned_to, previous_assignee].compact.uniq

    notified = notified.map { |n| n.is_a?(Group) ? n.users : n }.flatten
    notified.uniq!
    notified = notified.select { |u| u.active? }

    notified += project.notified_users
    notified += project.users.preload(:preference).select(&:notify_about_high_priority_issues?) if priority.high?
    notified.uniq!
    # Remove users that can not view the issue
    notified.reject! { |user| !visible?(user) }
    notified
  end

  def create_app_notifications_after_create_issue
    if Setting.plugin_redmine_app_notifications.include?("issue_added") || (Setting.plugin_redmine_app_notifications.include?("user_mentioned"))
      to_users = my_notified_users()
      cc_users = notified_watchers

      parse_mentions()

      @users = to_users + cc_users + mentioned_users
      @users.uniq!

      @users.each do |user|
        if user.app_notification && user.id != author.id
          notification = AppNotification.create({
            :issue_id => id,
            :author_id => author.id,
            :recipient_id => user.id,
          })
          notification.deliver
        end
      end
    end
  end
end

Issue.send(:include, AppNotificationsIssuesPatch)
