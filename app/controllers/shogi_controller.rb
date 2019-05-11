require './lib/shogi'

class ShogiController < ApplicationController
  def dir
    @files = Dir.glob(File.join(Rails.configuration.log_path, '*.log')).map do |e|
      {
          path: e,
          name: File.basename(e),
          mtime: File.mtime(e),
          size: File.size(e),
      }
    end
  end

  def view
    str = IO.read(File.join(Rails.configuration.log_path, params[:id]))
    @name_black = str[/^Name\+:(.+)$/, 1]
    @name_white = str[/^Name-:(.+)$/, 1]
    @moves = str.lines.select {|e| /^[+-]\d{4}\D{2}/ === e}.map {|e| Shogi::Move.parse(e)}
    @pos = Shogi::Position.new
    @last = nil
    @moves.each do |e|
      @pos.do_move(e)
      @last = e
    end
  end

  def board
    str = IO.read(File.join(Rails.configuration.log_path, params[:id]))
    @moves = str.lines.select {|e| /^[+-]\d{4}\D{2}/ === e}.map {|e| Shogi::Move.parse(e)}
    @pos = Shogi::Position.new
    @last = nil
    @moves.each.with_index(1) do |e, i|
      @pos.do_move(e)
      @last = e
      break if i >= params[:moves].to_i
    end
    render partial: "board"
  end
end
