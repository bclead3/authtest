module ApplicationHelper

  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Authentication Test"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def resource_name
    :user
  end

  def devise_mapping
    Devise.mappings[:user]
  end

  def resource_name
    devise_mapping.name
  end

  def resource_class
    devise_mapping.to
  end

  def get_friends( user )
    response = HTTParty.get('https://graph.facebook.com/me/friends?access_token='+ user.provider_authentication.token)
    string_output = '<ul>'
    response.parsed_response['data'].each do |item|
      item_name = item['name']
      item_id = item['id']
      friend_url = 'https://graph.facebook.com/'+item_id+'?access_token='+user.provider_authentication.token
      string_output += '<li class="friend_link empty" data_fb_id="'+item_id+'">' + item_name + '</li><br/>'   #link_to( item_name, friend_url)
      #TODO: export this to a JQuery ajax call...
      #string_output += get_friend_details( item_id, user )
    end
    string_output += '</ul>'
    string_output.html_safe
  end

  def get_friend_details( friend_id, user )
    string_output = '<p>'
    response = HTTParty.get('https://graph.facebook.com/'+friend_id+'?access_token='+user.provider_authentication.token)
    hash = response.parsed_response
    hash.keys.each do |key|
      hash_value = hash[key]
      if hash_value.is_a? Array
        string_output += "#{key}<br\/>"
        hash_value.each do |element|
          string_output += "&nbsp;&nbsp;&nbsp;#{element['name']}<br/>"
        end
      else
        string_output += "#{key}:#{hash_value}<br\/>"
      end

    end
    string_output.html_safe
  end

  def get_friend_photo( friend_id )
    photo_url = '<img src="https://graph.facebook.com/'+friend_id+'/picture" alt="friend photo" />'.html_safe
  end

  def get_posts( facebook_id = 'me', user )
    string_output = '<div class="post_messages"><ul class="posts">'
    response = HTTParty.get('https://graph.facebook.com/'+facebook_id+'/posts?access_token='+user.provider_authentication.token)
    response_hash = response.parsed_response['data']
    response_hash.each do |post_item|
      string_output += '<li>'
      string_output += '<img src="'+post_item['picture']+'" alt="">' if post_item['picture']
      string_output += post_item['message'] if post_item['message']
      string_output += '</li>'
    end
    string_output += '</ul></div>'
    string_output.html_safe
  end

  def post_to_provider( message, link='', user )
    if user
      response = nil
      user_token = user.provider_authentication.token
      user_id = user.provider_authentication.uid
      url = URI.escape("https://graph.facebook.com/#{user_id}/feed?access_token=#{user_token}")
      unless link.blank?
        response = HTTParty.post(url, query: { message: message, link: link })
      else
        response = HTTParty.post(url, query: { message: message })
      end

      html_text = '<p>'+response.parsed_response['id'] + '</p>'
    end
  end
end
