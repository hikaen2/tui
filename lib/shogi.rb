# coding: utf-8

module Shogi

  module Side
    BLACK = 0
    WHITE = 1
  end

  module Type
    FU = 0
    KY = 1
    KE = 2
    GI = 3
    KI = 4
    KA = 5
    HI = 6
    OU = 7
    TO = 8
    NY = 9
    NK = 10
    NG = 11
    _ = 12
    UM = 13
    RY = 14
  end

  class Piece
    attr_accessor :side, :file, :rank, :type

    def initialize(side, file, rank, type)
      @side = side;
      @file = file
      @rank = rank
      @type = type
    end

    def to_s
      ['歩', '香', '桂', '銀', '金', '角', '飛', '玉', 'と', '杏', '圭', '全', '〓', '馬', '龍'][@type]
    end

    def inspect
      "(#{@side},#{@file}#{@rank},#{@type})"
    end
  end


  class Move
    attr_accessor :side, :file_from, :rank_from, :file_to, :rank_to, :type

    def initialize(side, file_from, rank_from, file_to, rank_to, type)
      @side = side
      @file_from = file_from
      @rank_from = rank_from
      @file_to = file_to
      @rank_to = rank_to
      @type = type
    end

    def self.parse(str)
      a = ['FU', 'KY', 'KE', 'GI', 'KI', 'KA', 'HI', 'OU', 'TO', 'NY', 'NK', 'NG', '〓', 'UM', 'RY']
      m = str.match(/^([+-])(\d)(\d)(\d)(\d)(..)/)
        Move.new(m[1] == '+' ? Side::BLACK : Side::WHITE, m[2].to_i, m[3].to_i, m[4].to_i, m[5].to_i, a.index(m[6]))
    end

    def to_t
      c = ['歩', '香', '桂', '銀', '金', '角', '飛', '王', 'と', '杏', '圭', '全', '〓', '馬', '龍']
      sprintf('%s%s', @side == Side::BLACK ? ' ' : 'v', c[@type])
    end

    def to_s
      a = ['０', '１', '２', '３', '４', '５', '６', '７', '８', '９']
      b = ['〇', '一', '二', '三', '四', '五', '六', '７', '八', '九']
      c = ['歩', '香', '桂', '銀', '金', '角', '飛', '王', 'と', '杏', '圭', '全', '〓', '馬', '龍']
      return sprintf('%s%s%s%s(%s%s)', @side == Side::BLACK ? '▲' : '△', a[@file_to], b[@rank_to], c[@type], @file_from, @rank_from) if @rank_from != 0
      return sprintf('%s%s%s%s打', @side == Side::BLACK ? '▲' : '△', a[@file_to], b[@rank_to], c[@type]) if @rank_from == 0
    end

    def inspect
      "(#{@side},#{@file_from}#{@rank_from},#{@file_to}#{@rank_to},#{@type})"
    end
  end


  class Position
    attr_accessor :side, :pieces

    def initialize
      @side = Side::BLACK
      @pieces = []

      (1..9).each {|i| @pieces << Piece.new(Side::WHITE, i, 3, Type::FU) }
      @pieces << Piece.new(Side::WHITE, 2, 2, Type::KA)
      @pieces << Piece.new(Side::WHITE, 8, 2, Type::HI)
      @pieces << Piece.new(Side::WHITE, 1, 1, Type::KY)
      @pieces << Piece.new(Side::WHITE, 2, 1, Type::KE)
      @pieces << Piece.new(Side::WHITE, 3, 1, Type::GI)
      @pieces << Piece.new(Side::WHITE, 4, 1, Type::KI)
      @pieces << Piece.new(Side::WHITE, 5, 1, Type::OU)
      @pieces << Piece.new(Side::WHITE, 6, 1, Type::KI)
      @pieces << Piece.new(Side::WHITE, 7, 1, Type::GI)
      @pieces << Piece.new(Side::WHITE, 8, 1, Type::KE)
      @pieces << Piece.new(Side::WHITE, 9, 1, Type::KY)
      (1..9).each {|i| @pieces << Piece.new(Side::BLACK, i, 7, Type::FU) }
      @pieces << Piece.new(Side::BLACK, 8, 8, Type::KA)
      @pieces << Piece.new(Side::BLACK, 2, 8, Type::HI)
      @pieces << Piece.new(Side::BLACK, 1, 9, Type::KY)
      @pieces << Piece.new(Side::BLACK, 2, 9, Type::KE)
      @pieces << Piece.new(Side::BLACK, 3, 9, Type::GI)
      @pieces << Piece.new(Side::BLACK, 4, 9, Type::KI)
      @pieces << Piece.new(Side::BLACK, 5, 9, Type::OU)
      @pieces << Piece.new(Side::BLACK, 6, 9, Type::KI)
      @pieces << Piece.new(Side::BLACK, 7, 9, Type::GI)
      @pieces << Piece.new(Side::BLACK, 8, 9, Type::KE)
      @pieces << Piece.new(Side::BLACK, 9, 9, Type::KY)
    end

    def look_at(file, rank)
      @pieces.find {|e| e.file == file and e.rank == rank}
    end

    def do_move(move)
      to = self.look_at(move.file_to, move.rank_to)
      if to != nil
        @pieces << Piece.new(move.side, 0, 0, to.type & 0x07)
        @pieces.delete_at(@pieces.find_index{|e| e.file == move.file_to && e.rank == move.rank_to})
      end

      @pieces.delete_at(@pieces.find_index{|e| e.file == move.file_from && e.rank == move.rank_from})

      @pieces << Piece.new(move.side, move.file_to, move.rank_to, move.type)
      @side = @side == Side::BLACK ? Side::WHITE : Side::BLACK
    end

    def hand_black
      @pieces.select {|e| e.side == Side::BLACK && e.file == 0}.sort_by {|e| e.type}.reverse
    end

    def hand_white
      @pieces.select {|e| e.side == Side::WHITE && e.file == 0}.sort_by {|e| e.type}.reverse
    end
  end
end

