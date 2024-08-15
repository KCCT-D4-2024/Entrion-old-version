class User < ApplicationRecord
  enum status: { entered: 1, exited: 2 }
end
