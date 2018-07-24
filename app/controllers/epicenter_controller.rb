class EpicenterController < ApplicationController
  before_action :set_user, only: [:followers, :following]


  def following
    @users = []

    User.all.each do |user|
      if @user.following.include?(user.id)
        @users.push(user)
      end
    end
  end

  def followers
    @users = []

    User.all.each do |user|
      if user.following.include?(user.id)
        @users.push(user)
      end
    end
  end

  def all_users
    @users = User.order(:username)
  end

  def tag_tweets
    @tag = Tag.find(params[:id])
  end

  def feed
    @tweet = Tweet.new

      @following_tweets = []

      Tweet.all.each do |tweet|
        if current_user.following.include?(tweet.user_id) || current_user.id == tweet.user.id
        @following_tweets.push(tweet)
        end
      end
    end

  def show_user
    @user = User.find(params[:id])
  end

  def now_following
    current_user.following.push(params[:id].to_i)
    current_user.save

    redirect_to show_user_path(id: params[:id])
  end

  def unfollow
    current_user.following.delete(params[:id].to_i)
    current_user.save

    redirect_to show_user_path(id: params[:id])
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
