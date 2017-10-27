class GamesController < WebsocketRails::BaseController  
    def join
        game = Game.last
        @user = User.find(session[:user_id])
        puts 'Hey!'
        if game.users.include?(@user)
          puts "Hi!"
	        WebsocketRails[:updates].trigger(:update_player, @user)
        end
      end
    
      def goodbye
        join = Game.last.joins.find_by(user_id:session[:user_id])
        if join
        	@user = join.user
        	join.destroy
	        WebsocketRails[:updates].trigger(:player_leave, @user)
        end
      end

  def ready
    # game = current_user.games.last
    puts "I'm ready!"
    current_user = User.find(session[:user_id])
    join = current_user.joins.last
    # binding.pry
    join.vote = true
    join.save
    game = join.game
    puts game.joins.where(vote:true).size
    if game.joins.where(vote:true).count == 2
      puts "we all ready!"
      roles = [0,1]
      roles = roles.shuffle
      joins = game.joins
      joins.each do |join|
        join.role = roles.pop()
        join.vote = nil
        join.save
      end
      hoster = Random.rand(1..2)
      game.hosts.create(hoster:hoster,vote:"",players:"")
      @user = game.users.find(hoster)
      puts @user
      WebsocketRails[:updates].trigger(:start, @user)
    end
  end

  def pick_players
    game = Game.last
    host = game.hosts.last
    # user_ids = data.collect{|d| d["value"]}
    data.each do |d|
      host.players += d['value']+","
    end
    host.save
    puts host.players
    @usernames = data.collect{|d| game.users.find(d["value"].to_i).name }
    # puts usernames
    WebsocketRails[:updates].trigger(:players,@usernames)
  end

  def vote
    user = User.find(session[:user_id])
    join = user.joins.last
    game = Game.last
    puts message
    host = game.hosts.last
    # binding.pry
    if message
      host.vote += "1"
    elsif message == nil
      host.vote += "2"
    else
      host.vote += "0"
    end
    host.save
    if message != nil
      join.vote = message
      join.save
    end
    if host.vote.length >= 2
      host.vote = ''
      game.joins.each do |join|
        if join.vote
          host.vote += "1"
        elsif join.vote == nil
          host.vote += "2"
        else
          host.vote += "0"
        end
        join.update(vote:nil)
        host.save
      end
      puts host.vote
      
      if host.hoster <=1
        hoster = host.hoster+1
      else
        hoster = 1
      end
      game.hosts.create(hoster:hoster,players:"",vote:"")
      agree = host.vote.count("1")
      disagree = host.vote.count("0")
      # binding.pry
      if agree > disagree
        host.update(result:true)
        puts "Agree!"
        game.tasks.create(result:"")
        @host = host
        return WebsocketRails[:updates].trigger(:vote_result, @host)
      else
        host.update(result:false)
        @host = host
        # binding.pry
        return WebsocketRails[:updates].trigger(:vote_result,@host)
      end
    end
  end

  def task
    game = Game.last
    t = game.tasks.last
    host = game.hosts.where("players != ?",'')[-1]
    if host.players.include?(session[:seat].to_s)
      if message or message == nil
        t.result += "1"
      else
        t.result += "0"
      end
      t.save
    end
    if t.result.length == host.players.length/2
      tasks = game.tasks
      up = 0
      # binding.pry
      unless t.result.include?("0")
        tasks.each do |tk|
          unless tk.result.include?("0")
            up += 1
          end
        end
        if up >= 3
          Game.create()
          return WebsocketRails[:updates].trigger('game_over',true)
        end
        return WebsocketRails[:updates].trigger('task_result',true)
      else
        tasks.each do |tk|
          if tk.result.include?("0")
            up += 1
          end
        end
        if up >= 3
          Game.create()
          return WebsocketRails[:updates].trigger('game_over',false)
        end
        return WebsocketRails[:updates].trigger('task_result',false)
      end

    end
  end

end  