require 'spec_helper'

describe "shared/atom_feed.atom.builder" do
  before do
    blog = stub_model(Blog, :base_url => "http://myblog.net")
    view.stub(:this_blog) { blog }
    Blog.stub(:default) { blog }
  end

  let(:author) { stub_model(User, :name => "not empty") }

  let(:text_filter) { stub_model(TextFilter) }

  def base_article(time=Time.now)
    a = stub_model(Article, :published_at => time, :user => author,
                   :created_at => time, :updated_at => time,
                   :title => "not empty either", :permalink => 'foo-bar')
    a.stub(:tags) { [] }
    a.stub(:categories) { [] }
    a.stub(:resources) { [] }
    a.stub(:text_filter) { text_filter }
    a
  end

  describe "with no items" do
    before do
      render "shared/atom_feed", :items => []
    end

    it "should render a valid feed" do
      pending "think of what the updated value should be"
      assert_feedvalidator rendered
    end

    it "shows typo with the current version as the generator" do
      xml = Nokogiri::XML.parse(rendered)
      generator = xml.css("generator").first
      generator.content.should == "Typo"
      generator["version"].should == TYPO_VERSION
    end
  end

  describe "rendering articles" do
    it 'should create valid atom feed when articles contains funny bits' do
      article1 = base_article(1.minute.ago)
      article1.body = '&eacute;coute!'
      article2 = base_article(2.minutes.ago)
      article2.body = 'is 4 < 2? no!'
      render "shared/atom_feed", :items => [article1, article2]
      assert_feedvalidator rendered
      assert_atom10 rendered, 2
    end
  end

  describe "rendering trackbacks with one trackback" do
    let(:article) { base_article }
    let(:trackback) { Factory.build(:trackback, :article => article) }

    before do
      render "shared/atom_feed", :items => [trackback]
    end

    it "should render a valid feed" do
      assert_feedvalidator rendered
    end

    it "should render an Atom feed with one item" do
      assert_atom10 rendered, 1
    end
  end

  def assert_atom10 feed, count
    doc = Nokogiri::XML.parse(feed)
    root = doc.css(':root').first
    root.name.should == "feed"
    root.namespace.href.should == "http://www.w3.org/2005/Atom"
    root.css('entry').count.should == count
  end
end