require './lib/shogi'

class ShogiController < ApplicationController
  def dir
    p File.expand_path(File.join(Rails.configuration.log_path, '*.log'))
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
    @moves = str.lines.select {|e| /^[+-]\d{4}\D{2}/ === e}.map {|e| Shogi::Move.parse(e)}
    @pos = Shogi::Position.new
    @moves.each do |e|
      @pos.do_move(e)
    end
  end

  def board
    p params[:moves]
    str = IO.read(File.join(Rails.configuration.log_path, params[:id]))
    @moves = str.lines.select {|e| /^[+-]\d{4}\D{2}/ === e}.map {|e| Shogi::Move.parse(e)}
    @pos = Shogi::Position.new
    @moves.each.with_index(1) do |e, i|
      @pos.do_move(e)
      break if i >= params[:moves].to_i
    end
    render partial: "board"
  end
end
