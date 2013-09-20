$(document).ready ->
  item_count = $('li.friend_link').length
  if item_count > 0
    url_a = location.pathname.split("/")

    $('li.friend_link').each (i) ->
      fb_id = $(this).attr('data_fb_id')
      $.ajax
        url: url_a[2]+"/retrieve_friend_info"
        data:
          friend_id: fb_id
          fb_name: $(this).text()
        dataType: 'json'
        cache: false
        success: (data) ->
          console.log(data)
        failure: (xhr, status, error) ->
          console.log("there was a failure")
        complete: (xhr, status) ->
          $('[data_fb_id='+fb_id+']').append(xhr.responseText)
