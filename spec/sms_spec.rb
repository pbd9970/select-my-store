require './lib/rps'

describe 'User' do
  it 'exists' do
    expects(User).to be_a(Class)
  end

  before :each do
    @user = User.new({first_name: "Caresa", last_name: "Huddleston", username: "ch1", password: "9329jaslkdfas098", birthday: "1/1/10", sex: "f", email: 'blah@blah.com', admin: false, user_id: nil})
  end

  describe '.initialize' do
    it "returns all of the users attributes" do

      expect(@user.first_name).to eq("Caresa")
      expect(@user.last_name).to eq("Huddleston")
      expect(@user.username).to eq("ch1")
      expect(@user.birthday).to eq("1/1/10")
      expect(@user.sex).to eq("f")
      expect(@user.email).to eq("blah@blah.com")
      expect(@user.admin).to eq(false)
      expect(@user_id).to be_nil
    end
  end

  describe '.has_password?' do
    it 'verifies a given password' do
      expect(@user.has_password?("notmypassword")).to eq(false)
      expect(@user.has_password?("9329jaslkdfas098")).to eq(true)
    end
  end

  describe '.stores' do 
    it 'returns a list of stores for any given qualities' do
      expect(@user.stores('male', 31, ['chic','grunge']).to eq(["MCHIC1","MCHIC3","UCHIC1","MGRUNGE1","MGRUNGE3","UGRUNGE1"])
    end
  end
end

describe 'Store' do
  it 'exists' do
    expects(Store).to be_a(Class)
  end

  describe '.initialize' do
    it "returns an instance with store attributes" do
      store = Store.new({name: "Chic1", website: "www.chic1.com", image_url: "/public/images/chic1.jpg", min_age: "25", max_age: "45", store_id: nil})
      expect(store.name).to eq("Chic1")
      expect(store.website).to eq("www.chic1.com")
      expect(store.image_url).to eq("/public/images/chic1.jpg")
      expect(store.min_age).to eq(25)
      expect(store.max_age).to eq(45)
      expect(store.store_id).to be_nil
    end
  end
end

describe 'Quality' do
  it 'exists' do
    expects(Quality).to be_a(Class)
  end

  before :each do
    @quality = Quality.new({name: "chic", male: false, female: true, quality_id: nil})
  end

  describe '.initialize' do
    it 'returns a quality name and sex it applies to' do
      expect(@quality.name).to eq("chic")
      expect(@quality.male).to eq(false)
      expect(@quality.female).to eq(true)
      expect(@quality.quality_id).to be_nil
    end
  end

  describe '.stores' do
    it "returns a list of stores for that attribute" do
      expect(@quality.stores('male', 25)).to eq([])
      expect(@quality.stores('female', 25)).to eq(["CHIC1","CHIC2"])
    end
  end
end


      
