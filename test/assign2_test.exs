defmodule Assign2Test do
  use ExUnit.Case
  import String, only: [split: 2]
  import Enum, only: [map: 2]
  doctest Assign2
  import Assign2


  test "SingleNoTrump" do
	  assert from_hands([
      north: "SA S8 S4 HA H7 H5 DA DJ D10 D2 CA C6 C3",
		  east: "SK S9 S5 HA H10 H6 H2 DJ D7 D3 CQ C8 C4",
		  south: "SA S10 S6 S2 HJ H7 H3 DQ D8 D4 CK C9 C5",
		  west: "SJ S7 S3 HQ H8 H4 DK D9 D5 CA C10 C6 C2",
    ]) |>  withPermutation() |> format() ==
"          North
          S A 8 4
          H A 7 5
          D A J 10 2
          C A 6 3
West                East
S J 7 3             S K 9 5
H Q 8 4             H A 10 6 2
D K 9 5             D J 7 3
C A 10 6 2          C Q 8 4
          South
          S A 10 6 2
          H J 7 3
          D Q 8 4
          C K 9 5
   South West North East
   Pass  Pass 1NT   Pass
   2S    Pass 3NT   Pass
   Pass  Pass
   Declarer: North
"
  end

  
  test "AllNoTrump" do
	  assert from_hands([
		  north: "SK S10 S7 S5 HA H7 H5 H3 DA D10 D4 CA C4",
		  east: "SA S8 S2 HA H5 DA DK DJ CA CQ C10 C8 C5",
		  south: "SA SJ S6 HA H4 DA D6 D2 CK C9 C7 C6 C4",
		  west: "SQ S4 S3 HA HK HQ HJ H10 H2 DA D8 CA C2",
    ]) |> withPermutation() |> format() ==
"              North
              S K 10 7 5
              H A 7 5 3
              D A 10 4
              C A 4
West                     East
S Q 4 3                  S A 8 2
H A K Q J 10 2           H A 5
D A 8                    D A K J
C A 2                    C A Q 10 8 5
              South
              S A J 6
              H A 4
              D A 6 2
              C K 9 7 6 4
   South West North East
   1NT   2NT  4NT   6NT
   Pass  Pass Pass  7NT
   Pass  Pass Pass
   Declarer: West
"
  end

  test "ThreeRounds" do
        assert from_hands([
                  north: "SA HA HQ H7 H5 H3 DA DJ D10 D8 D2 CK C6",
                  east: "SA SK HA HK HJ H10 H8 H4 H2 DA DJ D7 CQ",
                  south: "SA SK S10 S3 HK H7 H3 DQ D8 D4 CK C9 C5",
                  west: "SK HQ HJ H8 H4 H3 DK D9 CA CQ C10 C6 C2",
    ]) |>  withPermutation() |> format() ==
"            North
            S A
            H A Q 7 5 3
            D A J 10 8 2
            C K 6
West                    East
S K                     S A K
H Q J 8 4 3             H A K J 10 8 4 2
D K 9                   D A J 7
C A Q 10 6 2            C Q
            South
            S A K 10 3
            H K 7 3
            D Q 8 4
            C K 9 5
   South West North East
   1C    1H   3H    5H
   Pass  Pass 6H    7H
   Pass  Pass Pass
   Declarer: West
"
  end

  test "UnitTest" do
  	assert from_hands([
    		  north: "SJ S8 S4 HQ H7 H5 DA DJ D10 D8 D2 CA C6",
                  east: "SK SJ S9 HQ HJ H4 H2 DJ D7 D3 D2 CQ C8",
                  south: "SA SK S10 S3 HJ H7 H3 DQ D8 D4 CK C9 C5",
                  west: "SJ HQ HJ H8 H4 DK D9 D5 CA CQ C10 C6 C2",
    ]) |>  withPermutation() |> format() ==
"            North
            S J 8 4
            H Q 7 5
            D A J 10 8 2
            C A 6
West                    East
S J                     S K J 9
H Q J 8 4               H Q J 4 2
D K 9 5                 D J 7 3 2
C A Q 10 6 2            C Q 8
            South
            S A K 10 3
            H J 7 3
            D Q 8 4
            C K 9 5
   South West North East
   1C    2C   3D    3H
   Pass  Pass Pass
   
   Declarer: East
"
  end



  
  test "AllPass" do
	  assert from_hands([
      north: "SQ S8 S4 HK H9 H5 DA D10 D6 D2 CJ C7 C3",
		  east: "SK S9 S5 HA H10 H6 H2 DJ D7 D3 CQ C8 C4",
		  south: "SA S10 S6 S2 HJ H7 H3 DQ D8 D4 CK C9 C5",
		  west: "SJ S7 S3 HQ H8 H4 DK D9 D5 CA C10 C6 C2",
    ]) |>  withPermutation() |> format() ==
"          North
          S Q 8 4
          H K 9 5
          D A 10 6 2
          C J 7 3
West                 East
S J 7 3              S K 9 5
H Q 8 4              H A 10 6 2
D K 9 5              D J 7 3
C A 10 6 2           C Q 8 4
          South
          S A 10 6 2
          H J 7 3
          D Q 8 4
          C K 9 5
   South West North East
   Pass  Pass Pass  Pass
   Declarer: None
"
  end
  
  test "init" do
	  assert from_hands([
		  north: "SK S10 S7 S5 H9 H7 H5 H3 D10 D5 D4 D3 CJ",
		  east: "S9 S8 S2 H8 DA DK DJ D7 CA CQ C10 C8 C5",
		  south: "SA SJ S6 H6 H4 D9 D6 D2 CK C9 C7 C6 C4",
		  west: "SQ S4 S3 HA HK HQ HJ H10 H2 DQ D8 C3 C2",
    ]) |> withPermutation() |> format() ==
"              North
              S K 10 7 5
              H 9 7 5 3
              D 10 5 4 3
              C J
West                     East
S Q 4 3                  S 9 8 2
H A K Q J 10 2           H 8
D Q 8                    D A K J 7
C 3 2                    C A Q 10 8 5
              South
              S A J 6
              H 6 4
              D 9 6 2
              C K 9 7 6 4
   South West North East
   Pass  1H   Pass  3C
   Pass  4H   Pass  Pass
   Pass
   Declarer: West
"
  end
  
  test "N1" do
	  assert from_hands([
		  north: "SQ S8 S4 HK H9 H5 DA D10 D6 D2 CA CJ C3",
		  east: "SK S9 S5 HA H10 H6 H2 DJ D7 D3 CQ C8 C4",
		  south: "SJ S10 S6 S2 HJ H7 H3 DQ D8 D4 CK C9 C5",
		  west: "SA S7 S3 HQ H8 H4 DK D9 D5 C10 C7 C6 C2",
    ]) |> withPermutation() |> format() ==
"          North
          S Q 8 4
          H K 9 5
          D A 10 6 2
          C A J 3
West                East
S A 7 3             S K 9 5
H Q 8 4             H A 10 6 2
D K 9 5             D J 7 3
C 10 7 6 2          C Q 8 4
          South
          S J 10 6 2
          H J 7 3
          D Q 8 4
          C K 9 5
   South West North East
   Pass  Pass 1D    Pass
   2D    Pass Pass  Pass
   Declarer: North
"
  end
  
  test "N2" do
	  assert from_hands([
		  north: "SQ S8 S4 HK H9 H5 DA D10 D6 D2 CA CJ C3",
		  east: "SA SK S9 HA H10 H6 H2 DJ D7 D3 CQ C8 C4",
		  south: "S10 S6 S5 S2 HJ H7 H3 DQ D8 D4 CK C9 C5",
		  west: "SJ S7 S3 HQ H8 H4 DK D9 D5 C10 C7 C6 C2",
    ]) |> withPermutation() |> format() ==
"          North
          S Q 8 4
          H K 9 5
          D A 10 6 2
          C A J 3
West                East
S J 7 3             S A K 9
H Q 8 4             H A 10 6 2
D K 9 5             D J 7 3
C 10 7 6 2          C Q 8 4
          South
          S 10 6 5 2
          H J 7 3
          D Q 8 4
          C K 9 5
   South West North East
   Pass  Pass 1D    2C
   2D    3C   Pass  Pass
   Pass
   Declarer: East
"
  end
  
  test "N3" do
	  assert from_hands([
		  north: "SQ S8 S4 HK H9 H5 DA D10 D6 D2 CA CJ C3",
		  east: "SK S9 S5 HA H10 H6 H2 DJ D7 D3 CQ C8 C4",
		  south: "SA S10 S6 S3 S2 HJ H3 DQ D8 D4 CK C9 C5",
		  west: "SJ S7 HQ H8 H7 H4 DK D9 D5 C10 C7 C6 C2",
    ]) |> withPermutation() |> format() ==
"          North
          S Q 8 4
          H K 9 5
          D A 10 6 2
          C A J 3
West                  East
S J 7                 S K 9 5
H Q 8 7 4             H A 10 6 2
D K 9 5               D J 7 3
C 10 7 6 2            C Q 8 4
          South
          S A 10 6 3 2
          H J 3
          D Q 8 4
          C K 9 5
   South West North East
   Pass  Pass 1D    Pass
   2D    Pass Pass  Pass
   Declarer: North
"
  end

  test "from_hands" do
	  assert from_hands([
		  north: "SQ S8 C4",
		  east: "SK S9 S5",
		  south: "SA S10 S6",
		  west: "SJ HQ H8",
    ]) == [33, 3, 43, 44, 37, 46, 47, 48, 49, 50, 51, 52]
  end

  defp from_hands(hands) do
    build_deal([],
               to_indices(hands[:west]),
               to_indices(hands[:north]),
               to_indices(hands[:east]),
               to_indices(hands[:south]))
  end

  test "to_indices" do
	  assert to_indices("SQ S8 C4") == [50, 46, 3]
  end

  defp to_indices(string) do
    split(string," ") |> map(fn x -> index_from_card(x) end)
  end
  defp index_from_card(string) do
    [C2: 1, C3: 2, C4: 3, C5: 4, C6: 5, C7: 6, C8: 7, C9: 8, C10: 9, CJ: 10, CQ: 11, CK: 12, CA: 13, D2: 14, D3: 15, D4: 16, D5: 17, D6: 18, D7: 19, D8: 20, D9: 21, D10: 22, DJ: 23, DQ: 24, DK: 25, DA: 26, H2: 27, H3: 28, H4: 29, H5: 30, H6: 31, H7: 32, H8: 33, H9: 34, H10: 35, HJ: 36, HQ: 37, HK: 38, HA: 39, S2: 40, S3: 41, S4: 42, S5: 43, S6: 44, S7: 45, S8: 46, S9: 47, S10: 48, SJ: 49, SQ: 50, SK: 51, SA: 52][String.to_atom(string)]
  end
  test "index_from_card" do
    assert index_from_card("C2") == 1
    assert index_from_card("SA") == 52
  end
  defp build_deal(result,[],[],[],[]), do: result
  defp build_deal(result,[h1|t1],[h2|t2],[h3|t3],[h4|t4]) do
    build_deal([h1,h2,h3,h4|result],t1,t2,t3,t4)
  end
end
