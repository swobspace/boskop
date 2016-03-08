# -*- encoding : utf-8 -*-
require 'rails_helper'
require 'mypdf'

describe MyPDF::Formatter::Concerns::CommonConcerns do
  include MyPDF::Formatter::Concerns::CommonConcerns

  let(:pdf) {
    dbl = double("Antrag")
    pdf = MyPDFTester.new(dbl)
  }
  let(:min_free) { 200 }
  let(:or_skip)  { 17 }
  let(:a4_top)   { 719 }

  context "when remaining space is to low" do
    it "start on new page" do
      pdf.move_cursor_to (min_free + or_skip - 1)
      expect {
        check_remaining_space(pdf, min_free: min_free, or_skip: or_skip)
      }.to change{pdf.page_count}.by(1)

      expect(pdf.cursor.to_i).to be > a4_top 
    end
  end
  context "when remaining space is enough" do
    it "stay on the same page" do
      pdf.move_cursor_to (min_free + or_skip + 1)
      expect {
        check_remaining_space(pdf, min_free: min_free, or_skip: or_skip)
      }.to change{pdf.page_count}.by(0) 
      expect(pdf.cursor.to_i).to be == min_free + 1
    end
  end
end
