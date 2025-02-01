module ApplicationHelper
    #secury measure to not overflood the database
    def truncate_comment(comment_text, max_length = 300)
        return "" if comment_text.nil?
    
        if comment_text.length > max_length
          "#{comment_text[0...max_length]}..."
        else
          comment_text
        end
      end
  
end
