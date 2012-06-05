# coding: utf-8
module Merit
  class PointRules
    include Merit::PointRulesMethods

    def initialize
      # 发帖
      score 3, :on => 'topics#create'
      # 发帖被删除
      score -5, :on => 'topics#destroy', :to => :user
      # 回帖
      score 5, :on => 'replies#create'
      # 回帖被删除
      score -8, :on => 'replies#destroy', :to => :user

      # 话题被收藏
      score 13, :on => 'topics#favorite', :to => :user
      # 话题被关注
      score 3, :on => 'topics#follow', :to => :user
      # 收到喜欢
      score 10, :on => 'likes#create', :to => :user
      # 第一次修改个人信息
      score 100, :on => 'users#update'
    end
  end
end
