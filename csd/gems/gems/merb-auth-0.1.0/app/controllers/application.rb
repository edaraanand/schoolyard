class MerbAuth::Application < Merb::Controller
  controller_for_slice
  include MerbAuth::ControllerMixin
end