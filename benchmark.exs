Benchee.run(
  %{
    "Rust Nif" =>
      {fn {values, len, hg} ->
         for value <- values do
           HDRHistogramr.record(hg, value)
         end

         {len, hg}
       end,
       [
         before_each: fn values ->
           hg = HDRHistogramr.new_with_max(10_000, 3)
           {values, length(values), hg}
         end,
         after_each: fn {len, hg} ->
           ^len = HDRHistogramr.len(hg)
           true = HDRHistogramr.close(hg)
         end
       ]},
    "C Nif" =>
      {fn {values, len, hg} ->
         for value <- values do
           :hdr_histogram.record(hg, value)
         end

         {len, hg}
       end,
       [
         before_each: fn values ->
           len = length(values)
           {:ok, ref} = :hdr_histogram.open(10_000, 3)
           {values, len, ref}
         end,
         after_each: fn {len, hg} ->
           ^len = :hdr_histogram.get_total_count(hg)
           :ok = :hdr_histogram.close(hg)
         end
       ]}
  },
  inputs: %{
    "100" => Enum.map(0..100, fn _ -> :rand.uniform(10_000) end),
    "1_000" => Enum.map(0..1_000, fn _ -> :rand.uniform(10_000) end),
    "10_000" => Enum.map(0..10_000, fn _ -> :rand.uniform(10_000) end),
    "100_000" => Enum.map(0..100_000, fn _ -> :rand.uniform(10_000) end)
  },
  time: 15
)
