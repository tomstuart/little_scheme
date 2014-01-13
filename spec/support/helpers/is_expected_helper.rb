module IsExpectedHelper
  # backport from RSpec 3.0.0.beta2
  def is_expected
    expect(subject)
  end
end
