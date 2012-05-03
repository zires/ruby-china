require 'spec_helper'

describe Mongoid::UserFollowable do
  class Monkey
    include Mongoid::Document
    include Redis::Objects
    include Mongoid::UserFollowable

    field :name
  end

  before(:all) do
    @m1 = Monkey.create(:name => "Monkey 1")
    @m2 = Monkey.create(:name => "Monkey 2")
    @m3 = Monkey.create(:name => "Monkey 3")
    @m4 = Monkey.create(:name => "Monkey 4")
  end

  after(:all) do
    @m1.destroy
    @m2.destroy
    @m3.destroy
    @m4.destroy
  end

  it "should has follower_ids attribute" do
    @m1.follower_ids.to_a.should == []
  end

  it "should has following_ids attribute" do
    @m1.following_ids.to_a.should == []
  end

  it "should follow" do
    @m1.follow(@m2)
    @m2.follower_ids.to_a.should include(@m1.id.to_s)
    @m1.following_ids.to_a.should include(@m2.id.to_s)
    @m2.followers_count.should == 1
    @m1.followings_count.should == 1
    @m1.follow(@m2).should == false
    @m1.follow(@m2).should == false

    @m1.follow(@m3)
    @m3.follower_ids.to_a.should include(@m1.id.to_s)
    @m1.follow(@m4)
    @m1.followings_count.should == 3
    @m4.follower_ids.to_a.should include(@m1.id.to_s)
    @m3.follow(@m2)
    @m3.following_ids.to_a.should include(@m2.id.to_s)
    @m2.follower_ids.to_a.should include(@m3.id.to_s)
  end

  it "should unfollow" do
    @m1.unfollow(@m2)
    @m1.unfollow(@m4)
    @m2.follower_ids.to_a.should_not include(@m1.id.to_s)
    @m4.follower_ids.to_a.should_not include(@m1.id.to_s)
    @m1.following_ids.to_a.should_not include(@m4.id.to_s)
    @m1.following_ids.to_a.should_not include(@m2.id.to_s)
  end

  it "should following? work" do
    @m1.following?(@m2).should be_false
    @m1.following?(@m3).should be_true
    @m2.followed_by?(@m1).should be_false
    @m3.followed_by?(@m1).should be_true
  end

  it "should followers, following work" do
    m1 = Monkey.create(:name => "Monkey 1")
    m2 = Monkey.create(:name => "Monkey 2") 
    m1.follow(m2)
    m1.followings.to_a.should include(m2)
    m2.followers.to_a.should include(m1)
  end

end