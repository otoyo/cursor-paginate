require "rails_helper"

describe "RelationMethods" do
  before do
    10.times do |i|
      Post.create(created_at: Time.now + i)
    end

    posts[0, 3].each do |post|
      post.is_published = true
      post.save
    end
  end

  after do
    Post.delete_all
  end

  shared_examples_for "next_cursor exists" do
    describe "#has_next?" do
      subject { posts.has_next? }

      it { is_expected.to eq true }
    end

    describe "next_cursor" do
      subject { posts.next_cursor }

      it { is_expected.to eq expected }
    end
  end

  shared_examples_for "no next_cursor" do
    describe "#has_next?" do
      subject { posts.has_next? }

      it { is_expected.to eq false }
    end

    describe "next_cursor" do
      subject { posts.next_cursor }

      it { is_expected.to be_nil }
    end
  end

  describe "#before" do
    context "cursor is nil" do
      let(:cursor) { nil }
      let!(:posts) { Post.before(id: cursor).limit(limit) }

      context "limit is less than count of all" do
        let(:limit) { 3 }
        let(:expected) { Post.order("id desc")[limit].id }

        it_behaves_like "next_cursor exists"
      end

      context "limit is equal to count of all" do
        let(:limit) { Post.count }

        it_behaves_like "no next_cursor"
      end
    end

    context "id is given as cursor" do
      let(:cursor_pos) { 3 }
      let(:cursor) { Post.order("id desc")[cursor_pos].id }
      let!(:posts) { Post.before(id: cursor).limit(limit) }

      context "limit is less than count of all" do
        let(:limit) { 3 }
        let(:expected) { Post.order("id desc")[limit + cursor_pos].id }

        it_behaves_like "next_cursor exists"
      end

      context "limit is equal to count of all" do
        let(:limit) { Post.count }

        it_behaves_like "no next_cursor"
      end
    end

    context "invalid column given" do
      let(:cursor_pos) { 3 }
      let(:posts) { Post.order("id desc") }
      let(:cursor) { posts[cursor_pos].id }

      subject { -> { Post.before(none: cursor) } }

      it { is_expected.to raise_error(CursorPagination::InvalidColumnGiven) }
    end

    context "limit not set" do
      let(:cursor_pos) { 3 }
      let(:posts) { Post.order("id desc") }
      let(:cursor) { posts[cursor_pos].id }

      subject { -> { Post.before(id: cursor).has_next? } }

      it { is_expected.to raise_error(CursorPagination::LimitNotSet) }
    end

    context "other condition is given" do
      let(:cursor_pos) { 3 }
      let(:cursor) { Post.where(is_published: false).order("id desc")[cursor_pos].id }
      let!(:posts) { Post.where(is_published: false).before(id: cursor).limit(limit) }

      context "limit is less than count of all" do
        let(:limit) { 3 }
        let(:expected) { Post.where(is_published: false).order("id desc")[limit + cursor_pos].id }

        it_behaves_like "next_cursor exists"
      end

      context "limit is equal to count of all" do
        let(:limit) { Post.where(is_published: false).count }

        it_behaves_like "no next_cursor"
      end
    end

    context "created_at is given as cursor" do
      let(:cursor_pos) { 3 }
      let(:cursor) { Post.order("id desc")[cursor_pos].created_at }
      let!(:posts) { Post.before(created_at: cursor).limit(limit) }

      context "limit is less than count of all" do
        let(:limit) { 3 }
        let(:expected) { Post.order("id desc")[limit + cursor_pos].created_at }

        it_behaves_like "next_cursor exists"
      end

      context "limit is equal to count of all" do
        let(:limit) { Post.count }

        it_behaves_like "no next_cursor"
      end
    end
  end

  describe "#after" do
    context "cursor is nil" do
      let(:cursor) { nil }
      let!(:posts) { Post.after(id: cursor).limit(limit) }

      context "limit is less than count of all" do
        let(:limit) { 3 }
        let(:expected) { Post.order("id asc")[limit].id }

        it_behaves_like "next_cursor exists"
      end

      context "limit is equal to count of all" do
        let(:limit) { Post.count }

        it_behaves_like "no next_cursor"
      end
    end

    context "id is given as cursor" do
      let(:cursor_pos) { 3 }
      let(:cursor) { Post.order("id asc")[cursor_pos].id }
      let!(:posts) { Post.after(id: cursor).limit(limit) }

      context "limit is less than count of all" do
        let(:limit) { 3 }
        let(:expected) { Post.order("id asc")[limit + cursor_pos].id }

        it_behaves_like "next_cursor exists"
      end

      context "limit is equal to count of all" do
        let(:limit) { Post.count }

        it_behaves_like "no next_cursor"
      end
    end

    context "invalid column given" do
      let(:cursor_pos) { 3 }
      let(:posts) { Post.order("id desc") }
      let(:cursor) { posts[cursor_pos].id }

      subject { -> { Post.after(none: cursor) } }

      it { is_expected.to raise_error(CursorPagination::InvalidColumnGiven) }
    end

    context "limit not set" do
      let(:cursor_pos) { 3 }
      let(:posts) { Post.order("id desc") }
      let(:cursor) { posts[cursor_pos].id }

      subject { -> { Post.after(id: cursor).has_next? } }

      it { is_expected.to raise_error(CursorPagination::LimitNotSet) }
    end

    context "other condition is given" do
      let(:cursor_pos) { 3 }
      let(:cursor) { Post.where(is_published: false).order("id asc")[cursor_pos].id }
      let!(:posts) { Post.where(is_published: false).after(id: cursor).limit(limit) }

      context "limit is less than count of all" do
        let(:limit) { 3 }
        let(:expected) { Post.where(is_published: false).order("id asc")[limit + cursor_pos].id }

        it_behaves_like "next_cursor exists"
      end

      context "limit is equal to count of all" do
        let(:limit) { Post.where(is_published: false).count }

        it_behaves_like "no next_cursor"
      end
    end

    context "created_at is given as cursor" do
      let(:cursor_pos) { 3 }
      let(:cursor) { Post.order("id asc")[cursor_pos].created_at }
      let!(:posts) { Post.after(created_at: cursor).limit(limit) }

      context "limit is less than count of all" do
        let(:limit) { 3 }
        let(:expected) { Post.order("id asc")[limit + cursor_pos].created_at }

        it_behaves_like "next_cursor exists"
      end

      context "limit is equal to count of all" do
        let(:limit) { Post.count }

        it_behaves_like "no next_cursor"
      end
    end
  end
end
