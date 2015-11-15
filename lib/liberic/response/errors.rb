module Liberic
  module Response
    class ResponseError < StandardError
    end

    class LibraryNotFound < ResponseError
    end
  end
end
