require_relative '../application/interfaces/auth_system'

class FakeAuthSystem < AuthSystem
  def get_user_data(token)
    unless token
      raise InvalidAuthDataError, "Token is not provided"
    end

    return UserDTO.new(1, "fake")
  end
end
