#require_dependency 'kb_article'
#requires 'kb_article'

module AppNotificationsKbArticlesPatch
    extend ActiveSupport::Concern

    included do
      after_create :create_app_notifications_after_create_kbarticle
    end

    def create_app_notifications_after_create_kbarticle
      to_users = notified_users
      cc_users = notified_watchers - to_users
      @users = to_users + cc_users

      @users.each do |user|
        if user.app_notification && user.id != author.id
          notification = AppNotification.create({
            :article_id => id,
            :author_id => author.id,
            :recipient_id => user.id,
          })
          notification.deliver
        end
      end
    end
  end

KbArticle.send(:include, AppNotificationsKbArticlesPatch)
#puts KbArticle