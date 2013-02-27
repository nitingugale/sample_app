require 'spec_helper'

describe "User pages" do

	subject { page }

	describe "Signup page" do
		before { visit signup_path }
		
		it { should have_selector('h1', text: 'Sign Up') }
		it { should have_selector('title', text: full_title('Sign Up')) }
	end

	describe "Profile page" do
		let(:test_user) { FactoryGirl.create(:user) }

		before { visit user_path(test_user) }
		
		it { should have_selector('h1', text: test_user.name) }
		it { should have_selector('title', text: test_user.name) }
	end

	describe "Signup" do
		before { visit signup_path }

		let(:submit) { "Create my account" }

		describe "with invalid information" do
			it "should not create a user" do
				expect { click_button submit }.not_to change(User, :count)
			end

			describe "after submission" do
				before { click_button submit }

				it { should have_selector('title', test: 'Sign up') }
				it { should have_content('error') }
				it { should_not have_content('Password digest') }
			end 
		end

		describe "with valid information" do

			before do
				fill_in "Name", with: "Example User"
				fill_in "Email", with: "user@example.com"
				fill_in "Password", with: "foobar"
				fill_in "Confirmation", with: "foobar"
			end

			it "should create a user" do
				expect { click_button submit }.to change(User, :count).by(1)				
			end 
			
			describe "after saving a user" do
				before { click_button submit }
	
				let(:user) { User.find_by_email("user@example.com") }

				it { should have_selector('title', text: user.name) }
				it { should have_selector('div.alert.alert-success', text: 'Welcome') }
			end
		end
	end
end
