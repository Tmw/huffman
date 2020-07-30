defmodule UtilsTest do
  use ExUnit.Case
  alias Huffman.Utils

  describe "#bytes/1" do
    @ascii_string "basic ascii"
    @unicode_string "unîcødé"

    test "split basic ascii string per byte" do
      assert String.graphemes(@ascii_string) == Utils.bytes(@ascii_string)
    end

    test "unicode chars" do
      assert ["u", "n", <<195>>, <<174>>, "c", <<195>>, <<184>>, "d", <<195>>, <<169>>] =
               Utils.bytes(@unicode_string)
    end
  end
end
