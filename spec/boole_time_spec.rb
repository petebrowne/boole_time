require 'spec_helper'

describe BooleTime do
  it 'adds readers' do
    expect(Post.new.published).to eql(false)
    expect(Post.new(published_at: Time.now).published).to eql(true)
  end

  it 'add writers' do
    post = Post.new
    post.published = true
    expect(post.published_at).to eq(Time.now)
    post.published = false
    expect(post.published_at).to be_nil
  end

  it 'adds queriers' do
    expect(Post.new.published?).to eql(false)
    expect(Post.new(published_at: Time.now).published?).to eql(true)
  end
end
