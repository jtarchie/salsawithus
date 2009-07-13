class EventPublisher < Facebooker::Rails::Publisher
  def publish_add_template
    one_line_story_template "{*actor*} has added {*event_name*} to salsawith.us."
    short_story_template "{*actor*} has added {*event_name*} to salsawith.us.", "{*actor*} has been helping <fb:pronoun uid='actor' useyou='false' possessive='true' /> friends find new places to dance. Learn more about salsa and go out and dance tonight."
    action_links action_link("See Event", "{*event_url*}"), action_link("More Venues", "{*venue_map_url*}")
  end
  
  def publish_edit_template
    one_line_story_template "{*actor*} has edited {*event_name*} on salsawith.us."
    short_story_template "{*actor*} has edited {*event_name*} on salsawith.us.", "{*actor*} has been helping <fb:pronoun uid='actor' useyou='false' possessive='true' /> friends find new places to dance. Learn more about salsa and go out and dance tonight."
    action_links action_link("See Event", "{*event_url*}"), action_link("More Venues", "{*venue_map_url*}")
  end
  
  def publish_add(options = {})
    send_as :user_action
    from options[:user]
    data options[:data]
  end
  
  def publish_edit(options = {})
    send_as :user_action
    from options[:user]
    data options[:data]
  end
  
  def edit_notification(options = {})
    send_as :notification
    from options[:from]
    recipients options[:to]
    fbml "has updated listing for <a href='#{options[:event_url]}'>#{options[:event].name}</a>."
  end
end
