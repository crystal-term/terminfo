require "../spec_helper"

describe Term::Terminfo::Attributes do
  describe ".get" do
    it "returns Info record with all attributes" do
      info = Term::Terminfo::Attributes.get
      info.should be_a(Term::Terminfo::Attributes::Info)
    end

    it "detects color support based on terminal type" do
      info = Term::Terminfo::Attributes.get
      info.color_support.should be_a(Bool)
      
      # If TERM contains color-related keywords, it should detect color
      if term = ENV["TERM"]?
        if term.includes?("color") || term.includes?("256")
          info.color_support.should be_true
        end
      end
    end

    it "detects unicode support based on locale" do
      info = Term::Terminfo::Attributes.get
      info.unicode_support.should be_a(Bool)
      
      # If locale contains UTF-8, it should detect unicode
      lang = ENV["LANG"]? || ENV["LC_ALL"]? || ENV["LC_CTYPE"]? || ""
      if lang.downcase.includes?("utf")
        info.unicode_support.should be_true
      end
    end

    it "detects mouse support based on terminal type" do
      info = Term::Terminfo::Attributes.get
      info.mouse_support.should be_a(Bool)
    end

    it "detects terminal program from environment" do
      info = Term::Terminfo::Attributes.get
      info.term_program.should be_a(String?)
      
      if prog = ENV["TERM_PROGRAM"]?
        info.term_program.should eq(prog)
      end
    end
  end
end