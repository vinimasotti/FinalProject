class ErrorsController < ApplicationController
    layout 'application' 
    def not_found
        render status: :not_found
      end
    
      def internal_server_error
        render status: :internal_server_error
      end
    
      def bad_request
        render status: :bad_request
      end
end
