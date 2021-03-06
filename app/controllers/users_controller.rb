class UsersController < ApplicationController
  def create
  	user = User.new(reg_params)
  	if user.save
  		session[:user_id] = user.id
  		redirect_to "/home"
  	else
  		flash[:errors] = user.errors.full_messages
  		redirect_to :back
  	end
  end

  def join
  	game = Game.last
    @user = User.find(session[:user_id])
    if game.joins.size < 6 and !game.users.include?(@user)
    	game.joins.create(user_id:session[:user_id])
  		return render json: true
    end
  	render json:false
  end

  def start
  	game = Game.last
  	join = game.joins.find_by(user_id:session[:user_id])
  	if join
  		@res = {}
		@res[:role] = join.role
		@res[:seat] = join.seat
		session[:role] = @res[:role]
	  	return render json:@res
	end
	render json:nil
  end

  def seat
  	render json:session[:seat]
  end

  def seats
  	@joins = Game.last.joins.joins(:user).select("user.name AS name,joins.*").order("joins.seat")
  end

  def host
  	host = Game.last.hosts.last.hoster
  	join = Game.last.joins.find_by_seat(host)
  	@user = join.user
  	# binding.pry
  	render json:@user
  end

  def limit
  	list = [2,3,4,3,4]
	a = Game.last.tasks.size%5
	render json: list[a]
  end

  private

  def reg_params
  	params.require(:user).permit(:name,:email,:password)
  end
end
