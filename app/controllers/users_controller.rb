class UsersController < ApplicationController
  include ApplicationHelper
  respond_to :html, :json

  before_filter :authenticate_user!, except: [:new, :retrieve_friend_info]

  def new
  end

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def retrieve_friend_info
    logger.debug "Retrieved user_id:#{params[:user_id]} friend_id:#{params[:friend_id]}"
    user = User.find(params[:user_id])
    return_html = get_friend_details( params[:friend_id], user )
    respond_with( return_html )
  end

  def retrieve_friend_photo
    return_html = get_friend_photo( params[:friend_id])
    respond_with( return_html )
  end

  def retrieve_posts
    user = User.find(params[:user_id])
    return_html = ''
    if params[:friend_id].blank?
      return_html = get_posts( user )
    else
      return_html = get_posts(params[:friend_id], user )
    end
    respond_with( return_html )
  end

  def send_post
    user = current_user
    return_html = '<p></p>'
    user = User.find(params[:user_id])
    post_message = params[:message]
    post_link = params[:link]
    if user.id == current_user.id && ! post_message.blank?
      return_html = post_to_provider( post_message, post_link, user )
    end
    respond_with( return_html )
  end
end
