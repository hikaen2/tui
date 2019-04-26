require './lib/pos'

class ShogiController < ApplicationController


  def guhaa
  end

  def list
    @files = Dir.glob('/home/taro/src/test/tui/*').map do |e|
      {
        path: e,
        name: File.basename(e),
        basename: File.basename(e, File.extname(e)),
        mtime: File.mtime(e),
        size: File.size(e),
      }
    end
  end

  def index

    str=<<~EOS
LOGIN:tenuki OK
BEGIN Game_Summary
Protocol_Version:1.2
Protocol_Mode:Server
Format:Shogi 1.0
Declaration:Jishogi 1.1
Game_ID:wdoor+floodgate-300-10F+JeSuisMoi+tenuki+20190427080002
Name+:JeSuisMoi
Name-:tenuki
Your_Turn:-
Rematch_On_Draw:NO
To_Move:+
Max_Moves:256
BEGIN Time
Time_Unit:1sec
Total_Time:300
Byoyomi:0
Increment:10
Least_Time_Per_Move:0
END Time
BEGIN Position
P1-KY-KE-GI-KI-OU-KI-GI-KE-KY
P2 * -HI *  *  *  *  * -KA *
P3-FU-FU-FU-FU-FU-FU-FU-FU-FU
P4 *  *  *  *  *  *  *  *  *
P5 *  *  *  *  *  *  *  *  *
P6 *  *  *  *  *  *  *  *  *
P7+FU+FU+FU+FU+FU+FU+FU+FU+FU
P8 * +KA *  *  *  *  * +HI *
P9+KY+KE+GI+KI+OU+KI+GI+KE+KY
+
END Position
END Game_Summary
START:wdoor+floodgate-300-10F+JeSuisMoi+tenuki+20190427080002
+2726FU,T0
-3334FU,T0
+7776FU,T0
-8242HI,T0
+3948GI,T0
-4344FU,T0
+5968OU,T0
-5162OU,T9
+6878OU,T0
-6272OU,T11
+5756FU,T0
-7282OU,T9
+4958KI,T0
-3132GI,T11
+9796FU,T0
-9192KY,T9
+4857GI,T0
-8291OU,T9
+8877KA,T0
-3243GI,T11
+7888OU,T0
-4354GI,T9
+5766GI,T8
-6364FU,T10
+7786KA,T10
-4445FU,T9
+8664KA,T10
-4152KI,T9
+5655FU,T10
-5463GI,T9
+6486KA,T1
-7182GI,T9
+7978GI,T1
-6171KI,T9
+2625FU,T1
-2233KA,T10
+2826HI,T0
-9394FU,T11
+1716FU,T10
-5262KI,T9
+7877GI,T10
-4241HI,T12
+6978KI,T10
-5354FU,T9
+5554FU,T10
-6354GI,T9
+2524FU,T0
-2324FU,T9
+0022FU,T10
-0065FU,T9
+6675GI,T1
-5463GI,T16
+2221TO,T10
-4121HI,T9
+2636HI,T1
-2151HI,T9
+0057KE,T1
-5154HI,T9
+5868KI,T10
-7374FU,T9
+5745KE,T1
-3344KA,T9
+0055FU,T1
-4455KA,T16
+7574GI,T0
-6374GI,T9
+0056FU,T2
-5573KA,T11
+3626HI,T0
-0058FU,T17
+2624HI,T11
-5859TO,T9
+2421RY,T3
-0057FU,T9
+6857KI,T11
-0055FU,T12
+8642UM,T10
-0069GI,T16
+4243UM,T12
-6978NG,T9
+8878OU,T13
-5556FU,T9
+4354UM,T5
-5657TO,T9
+4553NK,T7
-6253KI,T11
+5453UM,T15
-0072KI,T25
+7675FU,T13
-7463GI,T14
+2111RY,T15
-0076FU,T20
+1113RY,T0
EOS


    @moves = str.lines.select{|e| /^[+-]\d{4}\D{2}/ === e}.map {|e| Move.parse(e)}
    @pos = Position.new
    @moves.each do |e|
      @pos.do_move(e)
    end

  end
end
