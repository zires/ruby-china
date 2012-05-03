class RemoveOldFollowFields < Mongoid::Migration
  def self.up
    User.collection.update({},{ "$unset" => { :follower_ids => 1, :following_ids => 1, :following_node_ids => 1 }}, :multi => true)
  end

  def self.down
  end
end