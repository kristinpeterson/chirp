require 'spec_helper'

describe "Static pages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_heading(heading) }
    it { should have_title(page_title) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading)    { 'Sample App' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_selector 'title', text: '| Home' }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before(:each) { 40.times { FactoryGirl.create(:micropost, user: user) } }
      after(:all)  { User.delete_all }
 
      before do
        sign_in user
        visit root_path
      end

      it "should have the correct micropost count" do
        expect(page).to have_content("micropost".pluralize(user.microposts.count))     
      end

      describe "pagination" do
        it { should have_selector('div.pagination') }

        it "should list each micropost" do
          Micropost.paginate(page: 1).each do |micropost|
            page.should have_selector('li', text: micropost.content)
          end
        end
      end
    end
  end

  describe "Help page" do
    before { visit help_path }
    let(:heading)    { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    let(:heading)    { 'About Us' }
    let(:page_title) { 'About Us' }

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading)    { 'Contact' }
    let(:page_title) { 'Contact' }

    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    should have_title('About Us')
    click_link "Help"
    should have_title('Help')
    click_link "Contact"
    should have_title('Contact')
    click_link "Home"
    click_link "Sign up now!"
    should have_title('Sign up')
    click_link "sample app"
    should have_title('')
  end

end