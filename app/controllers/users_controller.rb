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
    	session[:seat] = game.joins.index(@user.joins.last) +1
  		return render json: true
    end
  	render json:false
  end

  def role
  	game = Game.last
  	join = game.joins.find_by(user_id:session[:user_id])
  	if join
		@res = join.role
		session[:role] = @res
	  	return render json:@res
	end
	render json:nil
  end

  def seat
  	render json:session[:seat]
  end

  def host
  	host = Game.last.hosts.last.hoster
  	@user = Game.last.users.all[host-1]
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
