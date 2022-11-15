module AppNotificationsJournalsPatch
  extend ActiveSupport::Concern

  included do
    after_create :create_app_notifications_after_create_journal
  end

  # Returns the users that should be notified
  def my_notified_users
    # Author and assignee are always notified unless they have been
    # locked or don't want to be notified
    notified = [journalized.author, journalized.assigned_to, journalized.previous_assignee].compact.uniq

    notified = notified.map { |n| n.is_a?(Group) ? n.users : n }.flatten
    notified.uniq!
    notified = notified.select { |u| u.active? }

    notified += journalized.project.notified_users
    notified += journalized.project.users.preload(:preference).select(&:notify_about_high_priority_issues?) if journalized.priority.high?
    notified.uniq!
    # Remove users that can not view the issue
    notified.reject! { |user| !journalized.visible?(user) }
    notified
  end

  def create_app_notifications_after_create_journal
    if notify? && (Setting.plugin_redmine_app_notifications.include?("issue_updated") ||
                   (Setting.plugin_redmine_app_notifications.include?("user_mentioned")) ||
                   (Setting.plugin_redmine_app_notifications.include?("issue_note_added") && journalized.notes.present?) ||
                   (Setting.plugin_redmine_app_notifications.include?("issue_status_updated") && journalized.status.present?) ||
                   (Setting.plugin_redmine_app_notifications.include?("issue_assigned_to_updated") && journalized.detail_for_attribute("assigned_to_id").present?) ||
                   (Setting.plugin_redmine_app_notifications.include?("issue_priority_updated") && journalized.new_value_for("priority_id").present?))
      this_issue = journalized
      l_to_users = my_notified_users
      l_cc_users = notified_watchers - l_to_users
      l_author = user

      if respond_to?(:parse_mentions) then
        parse_mentions()
        l_users = l_to_users + l_cc_users + mentioned_users
      else
        l_users = l_to_users + l_cc_users
      end

      l_users.each do |l_user|
        if l_user.app_notification && l_user.id != l_author.id
          notification = AppNotification.create({
            :journal_id => id,
            :issue_id => this_issue.id,
            :author_id => l_author.id,
            :recipient_id => l_user.id,
          })
          notification.deliver
        end
      end
    end
  end
end

Journal.send(:include, AppNotificationsJournalsPatch)
