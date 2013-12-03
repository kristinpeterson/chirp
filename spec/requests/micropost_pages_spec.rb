require 'spec_helper'

describe "MicropostPages" do
  subject { page }
  
  let(:user) { FactoryGirl.create(:user) }
  let(:another_user){ FactoryGirl.create(:user) }
  before { sign_in user }

  describe "index" do

    before do
      visit microposts_path
      30.times { FactoryGirl.create(:micropost, user: user) }
      FactoryGirl.create(:micropost, user: another_user)
    end

    it { should have_selector('title', text: 'microposts') }
    it { should have_selector('h1',    text: 'Microposts') }

    describe "pagination" do
      before { visit microposts_path }
      it { should have_selector('div.pagination') }

      it "should list each micropost" do
        Micropost.paginate(page: 1).each do |micropost|
          page.should have_selector('li', text: micropost.content)
        end
      end
    end

    describe "clicking delete link as correct user" do
      before { visit microposts_path }
      it "should delete micropost" do
        expect { first(".delete").click }.to change(Micropost, :count).by(-1)
      end
    end

    describe "as a user" do
      it "should not display delete links for another users microposts" do
        should_not have_xpath("//a[@href = 'micropost_path(another_user)']")
      end

      it "submitting a DELETE request to another users destroy action" do
        expect { delete micropost_path(another_user) }.not_to change(Micropost, :count)
        response.should redirect_to(root_url)
      end
    end
    
    describe "search" do

      let(:existing_micropost) { user.microposts.first.content }

      it { should have_field("search") }
      it { should have_button("Search") }

      describe "for existing micropost should return results" do
        
        before do
          visit microposts_path
          fill_in "search",   with: existing_micropost
          click_button "Search"
        end
        
        it { should have_selector('li', text: existing_micropost) }
      end

      describe "for micropost that doesn't exist should not return results" do
        
        before do
          visit microposts_path
          fill_in "search",   with: "does not exist"
          click_button "Search"
        end
        
        it { should have_selector('span', text: "No microposts matched your query, try again.") }
      end
    end

  end

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') } 
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end

  describe "micropost destruction" do
    before do 
      FactoryGirl.create(:micropost, user: user)
      FactoryGirl.create(:micropost, user: another_user)
    end

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { first(".delete").click }.to change(Micropost, :count).by(-1)
      end
    end

    describe "as a user" do
      it "should not display delete links for another users microposts" do
        visit user_path(another_user)
        should_not have_link('delete', href: micropost_path(another_user.microposts.find(:first)))
      end

      it "submitting a DELETE request to another users destroy action" do
        expect { delete micropost_path(another_user.microposts.find(:first)) }.not_to change(Micropost, :count)
        response.should redirect_to(root_url)
      end
    end
  end

end
