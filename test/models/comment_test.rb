require "test_helper"

class CommentTest < ActiveSupport::TestCase
  test "should not save comment without text" do
    comment = Comment.new(post: posts(:one)) # assumes posts fixture exists
    assert_not comment.save, "Saved the comment without text"

    test "should not save comment with text longer than 300 characters" do
      long_text = "a" * 299
      comment = Comment.new(
        text: long_text,
        post: posts(:one)
      )
      assert_not comment.valid?, "Saved the comment with text longer than 300 characters"
      assert_includes comment.errors[:text], "is too long (maximum is 300 characters)"
    end
  end
end
