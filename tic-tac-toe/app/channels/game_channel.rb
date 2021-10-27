class GameChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "player_#{uuid}"
    Match.create(uuid)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
