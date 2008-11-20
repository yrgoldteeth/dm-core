require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'spec_helper'))

# TODO: test loaded and unloaded behavior

describe 'Many to One Associations' do

  # define the model prior to with_adapters
  before do
    Object.send(:remove_const, :User) if defined?(User)
    class User
      include DataMapper::Resource

      property :name, String, :key => true
      property :age,  Integer
      property :description, Text

      has n, :comments
    end

    Object.send(:remove_const, :Clone) if defined?(Clone)
    class Clone
      include DataMapper::Resource

      property :name, String, :key => true
      property :age,  Integer
    end

    Object.send(:remove_const, :Article) if defined?(Article)
    class Article
      include DataMapper::Resource

      property :id,   Serial
      property :body, Text

      has n, :paragraphs
    end

    Object.send(:remove_const, :Comment) if defined?(Comment)
    class Comment
      include DataMapper::Resource

      property :id,      Serial
      property :body, Text

      belongs_to :user
    end

    Object.send(:remove_const, :Paragraph) if defined?(Paragraph)
    class Paragraph
      include DataMapper::Resource

      property :id,    Integer, :key => true
      property :text,  String

      belongs_to :article
    end
  end

  supported_by :all do
    before do
      @comment     = Comment.create(:body => "Cool spec",
                                    :user => User.create(:name => 'dbussink', :age => 25, :description => "Test"))

      @user        = @comment.user
      @model       = User
      @child_model = Comment
    end

    it_should_behave_like 'A public Resource'
  end
end
