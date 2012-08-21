require 'spec_helper'

describe BooleTime do
  context 'when the time is nil' do
    subject(:post) { Post.new published_at: nil }

    its(:published)    { should be_false }
    its(:published?)   { should be_false }
    its(:unpublished)  { should be_true }
    its(:unpublished?) { should be_true }

    context 'when set to true' do
      before { post.published = true }
      its(:published_at) { should eq(Time.now) }
    end

    context 'when set to false' do
      before { post.published = false }
      its(:published_at) { should be_nil }
    end
  end

  context 'when the time is in the future' do
    subject(:post) { Post.new published_at: 2.weeks.from_now }

    its(:published)    { should be_false }
    its(:published?)   { should be_false }
    its(:unpublished)  { should be_true }
    its(:unpublished?) { should be_true }

    context 'when set to true' do
      before { post.published = true }
      its(:published_at) { should eq(Time.now) }
    end

    context 'when set to false' do
      before { post.published = false }
      its(:published_at) { should eq(2.weeks.from_now) }
    end
  end

  context 'when the time is in the past' do
    subject(:post) { Post.new published_at: 2.weeks.ago }

    its(:published)    { should be_true }
    its(:published?)   { should be_true }
    its(:unpublished)  { should be_false }
    its(:unpublished?) { should be_false }

    context 'when set to true' do
      before { post.published = true }
      its(:published_at) { should eq(2.weeks.ago) }
    end

    context 'when set to false' do
      before { post.published = false }
      its(:published_at) { should be_nil }
    end
  end

  context 'with various times' do
    subject { Post }

    before do
      @post_1 = Post.create published_at: nil
      @post_2 = Post.create published_at: 2.weeks.ago
      @post_3 = Post.create published_at: 2.weeks.from_now
    end

    after { Post.delete_all }

    its(:published)   { should match_array([@post_2]) }
    its(:unpublished) { should match_array([@post_1, @post_3]) }
  end

  context 'without scopes' do
    subject { Post }
    it { should_not respond_to(:subscribed) }
    it { should_not respond_to(:unsubscribed) }
  end

  context 'without negatives' do
    subject { Post.new }
    it { should_not respond_to(:unsubscribed) }
    it { should_not respond_to(:unsubscribed?) }
  end

  context 'with a custom name' do
    subject { Post.new }
    it { should respond_to(:trashed=) }
    it { should respond_to(:trashed) }
    it { should respond_to(:trashed?) }
  end

  context 'with a custom negative name' do
    subject { Post.new }
    it { should respond_to(:treasured) }
    it { should respond_to(:treasured?) }
  end

  context 'with custom scope names' do
    subject { Post }
    it { should respond_to(:with_comments_open) }
    it { should respond_to(:with_comments_closed) }
  end
end
