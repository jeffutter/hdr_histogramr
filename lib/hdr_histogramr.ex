defmodule HDRHistogramr do
  use Rustler,
    otp_app: :hdr_histogramr,
    crate: :hdrhistogramr

  def new(_sigfig), do: :erlang.nif_error(:nif_not_loaded)
  def new_with_max(_max, _sigfig), do: :erlang.nif_error(:nif_not_loaded)
  def new_with_bounds(_low, _high, _sigfig), do: :erlang.nif_error(:nif_not_loaded)

  def record(_hg, _value), do: :erlang.nif_error(:nif_not_loaded)

  def record_correct(_hg, _value, _interval), do: :erlang.nif_error(:nif_not_loaded)

  def add(_hg1, _hg2), do: :erlang.nif_error(:nif_not_loaded)

  @doc """
  Get the value at a given quantile.

  ## Examples
      iex> hg = HDRHistogramr.new(2)
      iex> HDRHistogramr.record(hg, 1)
      iex> HDRHistogramr.record(hg, 2)
      iex> HDRHistogramr.record(hg, 100)
      iex> HDRHistogramr.value_at_quantile(hg, 0.5)
      2
  """
  def value_at_quantile(hg, quantile), do: _value_at_quantile(hg, quantile * 1.0)

  defp _value_at_quantile(_hg, _quantile), do: :erlang.nif_error(:nif_not_loaded)

  @doc """
  Get the value at a given percentile.

  This is simply value_at_quantile multiplied by 100.0. For best floating-point precision, use value_at_quantile directly.

  ## Examples
      iex> hg = HDRHistogramr.new(2)
      iex> HDRHistogramr.record(hg, 1)
      iex> HDRHistogramr.record(hg, 2)
      iex> HDRHistogramr.record(hg, 100)
      iex> HDRHistogramr.value_at_percentile(hg, 50)
      2
  """
  def value_at_percentile(hg, quantile), do: _value_at_percentile(hg, quantile * 1.0)

  defp _value_at_percentile(_hg, _quantile), do: :erlang.nif_error(:nif_not_loaded)

  @doc """
  Get the total number of samples recorded.

  ## Examples
      iex> hg = HDRHistogramr.new(2)
      iex> HDRHistogramr.record(hg, 0)
      iex> HDRHistogramr.record(hg, 100)
      iex> HDRHistogramr.len(hg)
      2
  """
  def len(_hg), do: :erlang.nif_error(:nif_not_loaded)

  @doc """
  Get the lowest recorded value level in the histogram. If the histogram has no recorded values, the value returned will be 0.

  ## Examples
      iex> hg = HDRHistogramr.new(2)
      iex> HDRHistogramr.record(hg, 1)
      iex> HDRHistogramr.record(hg, 100)
      iex> HDRHistogramr.min(hg)
      1
  """
  def min(_hg), do: :erlang.nif_error(:nif_not_loaded)

  @doc """
  Get the highest recorded value level in the histogram. If the histogram has no recorded values, the value returned is undefined.

  ## Examples
      iex> hg = HDRHistogramr.new(2)
      iex> HDRHistogramr.record(hg, 1)
      iex> HDRHistogramr.record(hg, 100)
      iex> HDRHistogramr.max(hg)
      100
  """
  def max(_hg), do: :erlang.nif_error(:nif_not_loaded)

  @doc """
  Get the computed mean value of all recorded values in the histogram.

  ## Examples
      iex> hg = HDRHistogramr.new(2)
      iex> HDRHistogramr.record(hg, 0)
      iex> HDRHistogramr.record(hg, 100)
      iex> HDRHistogramr.mean(hg)
      50.0
  """
  def mean(_hg), do: :erlang.nif_error(:nif_not_loaded)

  def to_binary(_hg), do: :erlang.nif_error(:nif_not_loaded)
  def from_binary(_binary), do: :erlang.nif_error(:nif_not_loaded)

  def dump(_hg), do: :erlang.nif_error(:nif_not_loaded)
end
