require "rails_helper"

describe UsersController do
  let(:user) { create :user }

  before do
    sign_in_as(user)
  end

  describe "GET /index" do
    it "returns http response :ok" do
      get :index

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:index)
      expect(assigns(:users)).to be_present
    end
  end

  describe "GET /new" do
    it "returns http response :ok" do
      get :new

      expect(response).to have_http_status(:ok)
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "POST /create" do
    context "success" do
      it "add one user and redirect to index page" do
        expect do
          post :create, user: attributes_for(:user)
        end.to change(User, :count).by(1)

        expect(response).to redirect_to(users_path)
      end
    end

    context "failure" do
      it "doesn't add one user and re-render new page" do
        expect do
          post :create, user: attributes_for(:user).except(:password)
        end.to change(User, :count).by(0)

        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET /show" do
    it "returns http response :ok" do
      get :show, id: user.id

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:show)
      expect(assigns(:user)).to eq(user)
    end
  end

  describe "GET /edit" do
    it "returns http response :ok" do
      get :edit, id: user.id

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:edit)
      expect(assigns(:user)).to eq(user)
    end
  end

  describe "PATCH /update" do
    let(:user_attributes) { attributes_for(:user,
                                           email: "abc@abc.com",
                                           first_name: "First",
                                           last_name: "Last",
                                           username: "username",
                                           gender: "female",
                                           date_of_birth: Date.today,
                                           profession: "developer",
                                           nationality: "indonesia",
                                           residence_status: "local",
                                           interested_to_meet: "only_male",
                                           payment_preference: "paying",
                                           location: "Jakarta") }
    let(:reloaded_user) { user.reload }

    context "success" do
      it "edit user and redirect to index page" do
        patch :update, id: user.id, user: user_attributes

        expect(response).to redirect_to(users_path)
        expect(reloaded_user.email).to eq("abc@abc.com")
        expect(reloaded_user.first_name).to eq("First")
        expect(reloaded_user.last_name).to eq("Last")
        expect(reloaded_user.username).to eq("username")
        expect(reloaded_user.gender).to eq("female")
        expect(reloaded_user.date_of_birth).to eq(Date.today)
        expect(reloaded_user.profession).to eq("developer")
        expect(reloaded_user.nationality).to eq("indonesia")
        expect(reloaded_user.residence_status).to eq("local")
        expect(reloaded_user.interested_to_meet).to eq("only_male")
        expect(reloaded_user.payment_preference).to eq("paying")
        expect(reloaded_user.location).to eq("Jakarta")
      end
    end

    context "failure" do
      it "doesn't update user and re-render new page" do
        patch :update, id: user.id, user: { email: "a" }

        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE /destroy" do
    context "success" do
      it "delete user and redirect to index page" do
        expect {
          delete :destroy, id: user.id
        }.to change(User, :count).by(-1)

        expect(response).to redirect_to(users_path)
      end
    end

    context "failure" do
      it "doesn't update user and re-render new page" do
        allow(User).to receive(:find) { user }
        allow(user).to receive(:destroy) { false }

        expect {
          delete :destroy, id: user.id
        }.to change(User, :count).by(0)

        expect(response).to redirect_to(users_path)
      end
    end
  end
end
