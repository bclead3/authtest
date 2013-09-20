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
      string_output += '<li class="friend_link">' + link_to( item_name, friend_url) + '<br/>'
      #TODO: export this to a JQuery ajax call...
      string_output += get_friend_details( item_id, user )
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
end
