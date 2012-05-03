# coding: utf-8
module Mongoid
  module UserFollowable
    extend ActiveSupport::Concern

    included do
      set :following_ids
      set :follower_ids

      after_destroy do
        self.following_ids.clear
        self.follower_ids.clear
      end
    end

    # 关注者总数
    def followers_count
      self.follower_ids.length
    end

    # 我关注的人数
    def followings_count
      self.following_ids.length
    end

    # 是否关注 user 这个用户
    def following?(user)
      self.following_ids.member?(user.id)
    end

    # 是否被 user 的关注
    def followed_by?(user)
      self.follower_ids.member?(user.id)
    end

    # 关注一个用户 
    def follow(user)
      return false if user.blank?
      return false if self.following?(user)
      user.follower_ids.add self.id
      self.following_ids.add user.id
    end

    # 取消对某人的关注
    def unfollow(user)
      return false if user.blank?
      user.follower_ids.delete self.id
      self.following_ids.delete user.id
    end

    # 关注我的人
    def followers
      self.class.where(:_id.in => self.follower_ids.to_a.collect { |id| id.to_i })
    end

    # 我关注的人
    def followings
      self.class.where(:_id.in => self.following_ids.to_a.collect { |id| id.to_i })
    end
  end
end