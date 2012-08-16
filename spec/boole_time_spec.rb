require 'spec_helper'

describe BooleTime do
  describe 'reader method' do
    it 'returns false if the time is nil' do
      expect(Post.new.published).to eql(false)
    end

    it 'returns false if the time is in the future' do
      post = Post.new published_at: 2.weeks.from_now
      expect(post.published).to eql(false)
    end

    it 'returns true if the time is in the past' do
      post = Post.new published_at: 2.weeks.ago
      expect(post.published).to eql(true)
    end
  end

  describe 'negative reader method' do
    it 'returns true if the time is nil' do
      expect(Post.new.unpublished).to eql(true)
    end

    it 'returns true if the time is in the future' do
      post = Post.new published_at: 2.weeks.from_now
      expect(post.unpublished).to eql(true)
    end

    it 'returns false if the time is in the past' do
      post = Post.new published_at: 2.weeks.ago
      expect(post.unpublished).to eql(false)
    end
  end

  describe 'query method' do
    it 'returns false if the time is nil' do
      expect(Post.new.published?).to eql(false)
    end

    it 'returns false if the time is in the future' do
      post = Post.new published_at: 2.weeks.from_now
      expect(post.published?).to eql(false)
    end

    it 'returns true if the time is in the past' do
      post = Post.new published_at: 2.weeks.ago
      expect(post.published?).to eql(true)
    end
  end

  describe 'negative query method' do
    it 'returns true if the time is nil' do
      expect(Post.new.unpublished?).to eql(true)
    end

    it 'returns true if the time is in the future' do
      post = Post.new published_at: 2.weeks.from_now
      expect(post.unpublished?).to eql(true)
    end

    it 'returns false if the time is in the past' do
      post = Post.new published_at: 2.weeks.ago
      expect(post.unpublished?).to eql(false)
    end
  end

  describe 'writer method' do
    it 'updates the time when set to true' do
      post = Post.new
      post.published = true
      expect(post.published_at).to eq(Time.now)
    end

    it 'sets the time to nil when set to false' do
      post = Post.new published_at: 2.weeks.ago
      post.published = false
      expect(post.published_at).to be_nil
    end

    it 'does not the set the time when already set' do
      post = Post.new published_at: 2.weeks.ago
      post.published = true
      expect(post.published_at).to eq(2.weeks.ago)
    end
  end

  describe 'truthy_scope' do
    it 'returns records with times in the past' do
      post_1 = Post.create published_at: nil
      post_2 = Post.create published_at: 2.weeks.ago
      post_3 = Post.create published_at: 2.weeks.from_now
      posts  = Post.published

      expect(posts).to match_array([post_2])
    end

    after { Post.delete_all }
  end

  describe 'falsy_scope' do
    it 'returns records without set times' do
      post_1 = Post.create published_at: nil
      post_2 = Post.create published_at: 2.weeks.ago
      post_3 = Post.create published_at: 2.weeks.from_now
      posts  = Post.unpublished

      expect(posts).to match_array([post_1, post_3])
    end

    after { Post.delete_all }
  end
end
