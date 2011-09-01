class Account < ActiveRecord::Base
validates_length_of :username, :within => 3..40
  validates_length_of :password, :within => 5..40
  validates_presence_of :username, :password, :password_confirmation, :salt, :permission
  validates_uniqueness_of :username
  validates_confirmation_of :password
  validates_numericality_of :artist


  attr_protected :id, :salt

  attr_accessor :password, :password_confirmation



  def self.authenticate(username, pass)
    u=find(:first, :conditions=>["username = ?", username])
    return nil if u.nil?
    return u if User.encrypt(pass, u.salt)==u.hashedpass
    nil
  end 

  def password=(pass)
    @password=pass
    self.salt = User.random_string(10) if !self.salt?
    self.hashedpass = User.encrypt(@password, self.salt)
  end

protected

  def self.encrypt(pass, salt)
    password = pass
    for i in 1..1000 do
      password = Digest::SHA256.hexdigest(password+salt)
    end
    password
  end

  def self.random_string(len)
    #generat a random password consisting of strings and digits
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end
end
