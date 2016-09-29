require "rails_helper"

describe UsersController do
  let(:user) { create :user, role: :admin }

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

    it "returns search results" do
      new_user = create :user, first_name: "First", last_name: "Last"
      get :index, search: { full_name: "first" }

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:index)
      expect(assigns(:users)).to be_present
      expect(assigns(:users)).to include new_user
      expect(assigns(:users)).not_to include user
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

        expect(response).to redirect_to(user_path(User.last))
        expect(User.last.email_confirmed_at).to be_present
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

  describe "GET /reset_password" do
    it "returns http response :ok" do
      get :reset_password, id: user.id

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:reset_password)
      expect(assigns(:user)).to eq(user)
    end
  end

  describe "PATCH /update" do
    let(:user_attributes) { attributes_for(:user,
                                           email: "abc@abc.com",
                                           first_name: "First",
                                           last_name: "Last",
                                           username: "username",
                                           password: "test1234",
                                           role: "user",
                                           gender: "female",
                                           about_me: "about me",
                                           date_of_birth: 19.years.ago,
                                           profession: "developer",
                                           nationality: "indonesia",
                                           residence_status: "local",
                                           interested_to_meet: "only_male",
                                           payment_preference: "paying",
                                           interested_in_list: "burger, pizza",
                                           location: "-6.214432, 106.813197",
                                           favorite_food_list: "burger, pizza") }
    let(:reloaded_user) { user.reload }

    context "success" do
      it "edit user and redirect to index page" do
        patch :update, id: user.id, user: user_attributes

        expect(response).to redirect_to(user_path(user.id))
        expect(reloaded_user.email).to eq("abc@abc.com")
        expect(reloaded_user.first_name).to eq("First")
        expect(reloaded_user.last_name).to eq("Last")
        expect(reloaded_user.username).to eq("username")
        expect(reloaded_user.role).to eq("user")
        expect(reloaded_user.gender).to eq("female")
        expect(reloaded_user.about_me).to eq("about me")
        expect(reloaded_user.date_of_birth).to eq(19.years.ago.to_date)
        expect(reloaded_user.profession).to eq("developer")
        expect(reloaded_user.nationality).to eq("indonesia")
        expect(reloaded_user.residence_status).to eq("local")
        expect(reloaded_user.interested_to_meet).to eq("only_male")
        expect(reloaded_user.payment_preference).to eq("paying")
        expect(reloaded_user.interested_in_list).to include("burger")
        expect(reloaded_user.interested_in_list).to include("pizza")
        expect(reloaded_user.favorite_food_list).to include("burger")
        expect(reloaded_user.favorite_food_list).to include("pizza")
        expect(reloaded_user.location).to eq("-6.214432, 106.813197")
      end
    end

    context "failure" do
      it "doesn't update user and re-render new page" do
        patch :update, id: user.id, user: { email: "a" }

        expect(response).to render_template(:edit)
      end
    end
  end

  describe "PATCH /activate" do
    context "success" do
      it "update user to active" do
        user.update(active: false)
        patch :activate, id: user.id

        expect(response).to redirect_to(users_path)
        expect(user.reload.active).to be_truthy
      end
    end
  end

  describe "PATCH /deactivate" do
    context "success" do
      it "update user to inactive" do
        patch :deactivate, id: user.id

        expect(response).to redirect_to(users_path)
        expect(user.reload.active).to be_falsey
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
