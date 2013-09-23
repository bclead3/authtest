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
end
