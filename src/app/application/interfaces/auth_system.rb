class InvalidAuthDataError < StandardError; end

class UserDTO
  attr_accessor :id, :name

  def initialize(id, name)
    @id = id
    @name = name
  end
end

class AuthSystem
  def get_user_data(token)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end
