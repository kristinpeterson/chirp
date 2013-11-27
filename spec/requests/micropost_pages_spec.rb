require 'spec_helper'

describe "MicropostPages" do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  let(:another_user){ FactoryGirl.create(:user) }
  before { sign_in user }

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
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
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
