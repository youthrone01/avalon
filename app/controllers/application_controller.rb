class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  def show
  	@game = Game.last
  	@users = @game.users
  	if @users.include?(current_user)
	  	session[:role] = current_user.joins.last.role
	  	session[:seat] = @game.joins.index(current_user.joins.last)+1
	else
	  	session[:role] = 4
	  	session[:seat] = ""
  	end
  	if session[:role] == nil
  		session[:role] = 1
  	end
  	@tasks = @game.tasks.collect do |task|
  		if task.result.include?("0")
  			"Fail"
  		else
  			"Success"
  		end
  	end
  	@messages = Message.joins(:user).select("users.name as username,messages.*").all.order("messages.created_at DESC")
  end

  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

end
