defmodule HDRHistogramrTest do
  use ExUnit.Case
  doctest HDRHistogramr

  test "to/from binary" do
    hg = HDRHistogramr.new(2)
    HDRHistogramr.record(hg, 1)
    HDRHistogramr.record(hg, 100)

    assert 2 == HDRHistogramr.len(hg)

    binary = HDRHistogramr.to_binary(hg)
    hg2 = HDRHistogramr.from_binary(binary)
    assert 2 == HDRHistogramr.len(hg2)
  end
end
