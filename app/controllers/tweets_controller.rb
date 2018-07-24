class TweetsController < ApplicationController
  before_action :set_tweet, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_user!

  include TweetsHelper

  # GET /tweets
  # GET /tweets.json
  def index
    @tweets = Tweet.all
  end

  # GET /tweets/1
  # GET /tweets/1.json
  def show
  end

  # GET /tweets/new
  def new
    @tweet = Tweet.new
  end

  # GET /tweets/1/edit
  def edit
  end

  # POST /tweets
  # POST /tweets.json
  def create
    @tweet = Tweet.new(tweet_params)

    respond_to do |format|
      if @tweet.save

        @tweet = get_tagged(@tweet)
        @tweet.save

        message_arr = @tweet.message.split

        message_arr = @tweet.message.split

        message_arr.each_with_index do |word, index|
          if word[0] == "#"
            if Tag.pluck(:phrase).include?(word)
              #save that Tag as a variable (to use in TweetTag creation)
              tag = Tag.find_by(phrase: word)
            else
            #creates a new instance of a Tag
              tag = Tag.create(phrase: word)
            end
            tweet_tag = TweetTag.create(tweet_id: @tweet.id, tag_id: tag.id)
            message_arr[index] = "<a href='/tag_tweets?id=#{tag.id}'>#{word}</a>"
          end
        end

        @tweet.update(message: message_arr.join(" "))

        format.html { redirect_to root_url, notice: 'Tweet was successfully created.' }
        format.json { render :show, status: :created, location: @tweet }
      else
        format.html { render :new }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end
  # DELETE /tweets/1
  # DELETE /tweets/1.json
  def destroy
    @tweet.destroy
    respond_to do |format|
      format.html { redirect_to tweets_url, notice: 'Tweet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tweet_params
      params.require(:tweet).permit(:message, :user_id, :link)
    end
end
