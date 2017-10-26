class GamesController < WebsocketRails::BaseController  
    def hello
        
        @count = Game.all.size
        WebsocketRails[:updates].trigger(:update, @count)
      end
    
      def goodbye
        Viewer.decrement_counter(:count,1)
        @count = Viewer.first.count
        WebsocketRails[:updates].trigger(:update, @count)
      end
end  
