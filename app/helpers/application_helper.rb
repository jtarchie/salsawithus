# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def fb_user_action_js(page, action, user_message = "", prompt = "", callback = nil)
    page.call "FB.Connect.showFeedDialog",action.template_id,action.data,action.target_ids,action.body_general,nil,"FB.RequireConnect.promptConnect",callback,prompt,user_message
  end
  
  def fb_notification_js(page, to, message, callback = nil)
    page << "FB.Facebook.apiClient.notifications_send(#{to.to_json}, #{message.to_json}, #{callback || 'function(){}'});"
  end
end
