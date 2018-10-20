require 'script'

RSpec.describe Script, "Script" do
  context "reading a book" do
    it "should separate all the articles" do
      script = Script.new

      expect(script.reading).to be(361)
    end
  end
end
