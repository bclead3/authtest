require 'spec_helper'

describe "Static pages" do

  subject { page }

  describe "Home page" do
    before {visit root_path }

    it { should have_selector('h1', :text => "Welcome to the Authentication Test") }
    it { should have_title("Authentication Test") }
    it { should_not have_selector('title', :text => '| Home') }
  end

  describe "About page" do
    before { visit about_path }

    it { should have_selector('h1', text: 'About Authentication Test') }
    it { should have_title("Authentication Test | About") }
  end

end