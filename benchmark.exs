values = Enum.map(0..100_000, fn _ -> :rand.uniform(10_000) end)

Benchee.run(
  %{
    "hdr_histogramr" =>
      {fn hg ->
         for value <- values do
           HDRHistogramr.record(hg, value)
         end
       end, before_scenario: fn _ -> HDRHistogramr.new_with_max(10_000, 2) end},
    "hdr_histogram" =>
      {fn hg ->
         for value <- values do
           :hdr_histogram.record(hg, value)
         end
       end,
       before_scenario: fn _ ->
         {:ok, ref} = :hdr_histogram.open(10_000, 2)
         ref
       end}
  },
  time: 15,
  reduction_time: 5,
  memory_time: 5
)
