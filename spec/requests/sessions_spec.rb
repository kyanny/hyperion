require "spec_helper"

describe "Signin/Signout" do
  subject { page }

  describe "GET /" do
    context "when not logged in as a user" do
      before {
        visit "/"
      }

      it {
        expect(current_path).to be == '/caveat'
        expect(subject).to have_content "Sign in"
      }
    end

    context "when logged in as a user" do
      context "when user is a member of the specified organization" do
        let(:user) { create(:user) }

        before {
          sign_in_as_member(user)
          visit "/"
        }

        it {
          expect(current_path).to be == '/'
          expect(subject).to have_content user.name
        }
      end

      context "when user is not a member of the specified organization" do
        let(:user) { create(:user) }

        before {
          User.any_instance.stub(:organizations).and_return([])
          sign_in(user)
          visit "/"
        }

        it {
          expect(current_path).to be == '/caveat'
          expect(subject).to have_content user.name
          expect(subject).to have_content "Not a member"
        }
      end
    end
  end

  describe "DELETE /signout" do
    context "when logged in as a user" do
      let(:user) { create(:user) }

      before {
        sign_in_as_member(user)
        sign_out
      }

      it {
        expect(current_path).to be == '/caveat'
        expect(subject).to have_content "Sign in"
      }
    end
  end
end
