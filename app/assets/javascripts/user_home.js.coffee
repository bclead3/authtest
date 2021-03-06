$(document).ready ->
  item_count = $('li.friend_link').length
  if item_count > 0
    url_a = location.pathname.split("/")
    $('li.friend_link').each (i) ->
      fb_id = $(this).attr('data_fb_id')
      $.ajax
        url: url_a[2]+"/retrieve_friend_photo"
        data:
          friend_id: fb_id
        dataType: 'json'
        cache: false
        complete: (xhr, status) ->
          $('[data_fb_id='+fb_id+']').append(xhr.responseText)

#    $('li.friend_link').each (i) ->
#      fb_id = $(this).attr('data_fb_id')
#      $.ajax
#        url: url_a[2]+"/retrieve_posts"
#        data:
#          friend_id: fb_id
#        dataType: 'json'
#        cache: false
#        complete: (xhr, status) ->
#          $('[data_fb_id='+fb_id+']').append(xhr.responseText)

  $('li.friend_link').click ->
    if $(this).hasClass('empty') or $(this).hasClass('ajaxed')
      if $(this).hasClass('ajaxed')
        $(this).children('.post_messages').toggle()
      else
        url_a = location.pathname.split("/")
        fb_id = $(this).attr('data_fb_id')
        $(this).removeClass('empty').addClass('ajaxed')
        $.ajax
          url: url_a[2]+"/retrieve_posts"
          data:
            friend_id: fb_id
            fb_name: $(this).text()
          dataType: 'json'
          cache: false
          complete: (xhr, status) ->
            $('[data_fb_id='+fb_id+']').append(xhr.responseText)

  $('.user_name span').click ->
    url_a = location.pathname.split("/")
    if $(this).hasClass('ajaxed')
      $('.user_name span .post_messages').toggle()
    else
      $(this).addClass('ajaxed')
      $.ajax
        url: url_a[2]+"/retrieve_posts"
        dataType: 'json'
        cache: false
        complete: (xhr, status) ->
          $('.user_name span').append(xhr.responseText)

  $('#user_submit_action button').click ->
    link_text = $('#user_bogus_link').val()
    message_text = $('#user_bogus_message').val()
    url_array = location.pathname.split("/")
    url_link = url_array[2] + '/send_post'
    $.ajax
      url: url_link
      dataType: 'json'
      cache: false
      data:
        message: message_text
        link: link_text
      complete: (xhr, status) ->
        $('#user_bogus_link').val('')
        $('#user_bogus_message').val('')
        $('.user_name span').append(xhr.responseText)