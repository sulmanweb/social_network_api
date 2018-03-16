class AuthenticateUser
  prepend SimpleCommand
  attr_accessor :email, :password

  #this is where parameters are taken when the command is called
  def initialize(email, password)
    @email = email
    @password = password
  end

  #this is where the result gets returned
  def call
    if user
      session = Session.create(user: user)
      JsonWebToken.encode({user_id: user.id, uid: session.uid})
    end
  end

  private

  def user
    user = User.find_by_email(email)
    user = User.find_by_username(email) if user.nil?
    return user if user && user.authenticate(password)

    errors.add :user_authentication, 'Invalid credentials'
    nil
  end
end