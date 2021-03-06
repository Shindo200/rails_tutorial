require 'spec_helper'

describe "Static pages" do

  let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_content(heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading) { 'Sample App' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title("| Home") }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      before { sign_in user }

      context "have 1 micropost" do
        before do
          FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
          visit root_path
        end

        it { should have_content("1 micropost") }
      end

      context "have 2 microposts" do
        before do
          FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
          FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
          visit root_path
        end

        it { should have_content("2 microposts") }

        it "should render the user's feed" do
          user.feed.each do |item|
            expect(page).to have_selector("li##{item.id}", text: item.content)
          end
        end
      end

      describe "pagination" do

        before do
          50.times { FactoryGirl.create(:micropost, user: user) }
          visit root_path
        end

        it { should have_selector('div.pagination') }

        it "should list each user" do
          Micropost.paginate(page: 1).each do |micropost|
            expect(page).to have_selector('li', text: micropost.content)
          end
        end
      end
    end
  end

  describe "Help page" do
    before { visit help_path }
    let(:heading) { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    let(:heading) { 'About Us' }
    let(:page_title) { 'About Us' }

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading) { 'Contact' }
    let(:page_title) { 'Contact' }

    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    should have_title(full_title('About Us'))
    click_link "Help"
    should have_title(full_title('Help'))
    click_link "Contact"
    should have_title(full_title('Contact'))
    click_link "Home"
    click_link "Sign up now!"
    should have_title(full_title(''))
    click_link "sample app"
    should have_title(full_title(''))
  end
end
