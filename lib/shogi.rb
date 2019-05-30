# coding: utf-8

module Shogi

  class Piece
    attr_accessor :side, :file, :rank, :type

    def initialize(side, file, rank, type)
      @side = side
      @file = file
      @rank = rank
      @type = type
    end

    def black?
      @side == :black
    end

    def white?
      @side == :white
    end

    def unpromote_type
      {fu: :fu, ky: :ky, ke: :ke, gi: :gi, ki: :ki, ka: :ka, hi: :hi, ou: :ou, to: :fu, ny: :ky, nk: :ke, ng: :gi, um: :ka, ry: :hi}[@type]
    end

    def to_s
      {fu: '歩', ky: '香', ke: '桂', gi: '銀', ki: '金', ka: '角', hi: '飛', ou: '玉', to: 'と', ny: '杏', nk: '圭', ng: '全', um: '馬', ry: '龍'}[@type]
    end

    NONE = Piece.new(nil, nil, nil, nil)
  end


  class Move
    attr_accessor :side, :type

    def initialize(side, file_from, rank_from, file_to, rank_to, type)
      @side = side
      @file_from = file_from
      @rank_from = rank_from
      @file_to = file_to
      @rank_to = rank_to
      @type = type
    end

    def self.parse(str)
      m = str.match(/^([+-])(\d)(\d)(\d)(\d)(..)/)
      Move.new(m[1] == '+' ? :black : :white, m[2].to_i, m[3].to_i, m[4].to_i, m[5].to_i, m[6].downcase.to_sym)
    end

    def from
      [@file_from, @rank_from]
    end

    def to
      [@file_to, @rank_to]
    end

    def drop?
      @file_from == 0 && @rank_from == 0
    end

    def to_s
      a = ['０', '１', '２', '３', '４', '５', '６', '７', '８', '９']
      b = ['〇', '一', '二', '三', '四', '五', '六', '七', '八', '九']
      c = {fu: '歩', ky: '香', ke: '桂', gi: '銀', ki: '金', ka: '角', hi: '飛', ou: '玉', to: 'と', ny: '杏', nk: '圭', ng: '全', um: '馬', ry: '龍'}[@type]
      return sprintf('%s%s%s%s(%s%s)', @side == :black ? '▲' : '△', a[@file_to], b[@rank_to], c, @file_from, @rank_from) if @rank_from != 0
      return sprintf('%s%s%s%s打', @side == :black ? '▲' : '△', a[@file_to], b[@rank_to], c) if @rank_from == 0
    end
  end


  class Position
    attr_accessor :side, :pieces

    def initialize
      @side = :black
      @pieces = []
      @pieces << Piece.new(:black, 5, 9, :ou)
      @pieces << Piece.new(:white, 5, 1, :ou)
      @pieces << Piece.new(:black, 2, 8, :hi)
      @pieces << Piece.new(:white, 8, 2, :hi)
      @pieces << Piece.new(:black, 8, 8, :ka)
      @pieces << Piece.new(:white, 2, 2, :ka)
      [4, 6].each {|file| @pieces << Piece.new(:black, file, 9, :ki) }
      [4, 6].each {|file| @pieces << Piece.new(:white, file, 1, :ki) }
      [3, 7].each {|file| @pieces << Piece.new(:black, file, 9, :gi) }
      [3, 7].each {|file| @pieces << Piece.new(:white, file, 1, :gi) }
      [2, 8].each {|file| @pieces << Piece.new(:black, file, 9, :ke) }
      [2, 8].each {|file| @pieces << Piece.new(:white, file, 1, :ke) }
      [1, 9].each {|file| @pieces << Piece.new(:black, file, 9, :ky) }
      [1, 9].each {|file| @pieces << Piece.new(:white, file, 1, :ky) }
      (1..9).each {|file| @pieces << Piece.new(:black, file, 7, :fu) }
      (1..9).each {|file| @pieces << Piece.new(:white, file, 3, :fu) }
    end

    def [](file, rank)
      look_at(file, rank) or Piece::NONE
    end

    def do_move(move)
      to = look_at(*move.to)
      to.side, to.type, to.file, to.rank = move.side, to.unpromote_type, 0, 0 if !to.nil?

      from = move.drop? ? look_by(move.side, move.type) : look_at(*move.from)
      from.type, from.file, from.rank = move.type, *move.to

      @side = @side == :black ? :white : :black
    end

    def hand_black
      @pieces.select {|e| e.side == :black && e.file == 0 && e.rank == 0}
    end

    def hand_white
      @pieces.select {|e| e.side == :white && e.file == 0 && e.rank == 0}
    end

    private
    def look_at(file, rank)
      @pieces.find {|e| e.file == file && e.rank == rank}
    end

    def look_by(side, type)
      @pieces.find {|e| e.side == side && e.type == type && e.file == 0 && e.rank == 0}
    end
  end
end
