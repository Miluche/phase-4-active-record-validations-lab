class Post < ApplicationRecord
  validates :content, length: {minimum: 250}
  validates :summary, length: {maximum: 250}
  validates :category, inclusion: { in: %w(Fiction Non-Fiction) }
  validates :title, presence: true
  validate :title_is_click_bait
  validate :same_title_for_all_posts

  private
  def title_is_click_bait
    click_baits = ["Won't Believe", "Secret", "Top [number]", "Guess"]
    if !click_baits.any? { |click_bait| title&.include?(click_bait) } && !title&.match(/Top \d+/)
      errors.add(:title, "The Post title does not qualify as click-bait")
    end
  end
  def same_title_for_all_posts
    if Post.distinct.pluck(:title).count > 1
      errors.add(:title, "All posts must have the same title")
    end
  end
end
