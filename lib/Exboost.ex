defmodule Exboost.Math do
  # Boost Software License - Version 1.0 - August 17th, 2003
  #
  # Permission is hereby granted, free of charge, to any person or organization
  # obtaining a copy of the software and accompanying documentation covered by
  # this license (the "Software") to use, reproduce, display, distribute,
  # execute, and transmit the Software, and to prepare derivative works of the
  # Software, and to permit third-parties to whom the Software is furnished to
  # do so, all subject to the following:
  #
  # The copyright notices in the Software and this entire statement, including
  # the above license grant, this restriction and the following disclaimer,
  # must be included in all copies of the Software, in whole or in part, and
  # all derivative works of the Software, unless such copies or derivative
  # works are solely in the form of machine-executable object code generated by
  # a source language processor.
  #
  # THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  # IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  # FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
  # SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
  # FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
  # ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  # DEALINGS IN THE SOFTWARE.

  @on_load :init

  app = Mix.Project.config()[:app]

  def init() do
    path =
      :filename.join(
        case :code.priv_dir(unquote(app)) do
          {:error, _} -> System.get_env("EXBOOSTNIFDIR")
          privdir -> privdir
        end,
        'libboostnif'
      )

    IO.inspect(path, label: "PATH")

    case :erlang.load_nif(path, 0) do
      :ok ->
        IO.inspect({:ok, path})

      {:error, {:load_failed, _message}} ->
        :ok = :erlang.load_nif('priv/libboostnif', 0)
    end
  end

  @doc """
  Provides the regularized lower incomplete gamma function.

  ## Examples

      iex> Exboost.Math.gamma_p(0.234,2.3)
      0.9891753004794075

      iex> Exboost.Math.gamma_p(5.0,0.0)
      0.0

  """
  @spec gamma_p(a :: float, z :: float) :: float
  def gamma_p(a, _z) when a < 0.0,
    do: raise(ArgumentError, message: "Boost [gamma_p] invalid arg (a=#{a})")

  def gamma_p(a, z) when is_float(a) and is_float(z), do: _gamma_p(a, z)
  def _gamma_p(_a, _z), do: "NIF library not loaded"

  @doc """
  Implements the inverse of the regularized incomplete gamma function.

  ## Examples:

      iex> Exboost.Math.gamma_p_inv(0.234,0.9891753004794075) |> Float.round(6)
      2.3

      iex> Exboost.Math.gamma_p_inv(5.0,0.0)
      0.0

  """
  @spec gamma_p_inv(a :: float, p :: float) :: float
  def gamma_p_inv(a, _p) when a < 0.0,
    do: raise(ArgumentError, message: "Boost [gamma_p_inv] invalid arg (a=#{a})")

  def gamma_p_inv(a, p) when is_float(a) and is_float(p), do: _gamma_p_inv(a, p)
  def _gamma_p_inv(_a, _z), do: "NIF library not loaded"

  @doc """
  Provides the non-regularized lower incomplete gamma function.

  ## Examples

      iex> Exboost.Math.tgamma_lower(0.234,2.3)
      3.8461476736289315

      iex> Exboost.Math.tgamma_lower(5.0,0.0)
      0.0

  """
  @spec tgamma_lower(a :: float, z :: float) :: float
  def tgamma_lower(a, _z) when a < 0.0,
    do: raise(ArgumentError, message: "Boost [tgamma_lower] invalid arg (a=#{a})")

  def tgamma_lower(a, z) when is_float(a) and is_float(z), do: _tgamma_lower(a, z)
  def _tgamma_lower(_a, _z), do: "NIF library not loaded"

  @doc """
  Provides the gamma function.

  ## Examples

      iex> Exboost.Math.tgamma(1.5)
      0.886226925452758

      iex> Exboost.Math.tgamma(3.0)
      2.0

  """
  @spec tgamma(z :: float) :: float
  def tgamma(z) when is_float(z), do: _tgamma(z)
  def _tgamma(_z), do: "NIF library not loaded"

  @doc """
  Provides the digamma function.

  ## Examples

      iex> Exboost.Math.digamma(1.5)
      0.03648997397857652

  """
  @spec digamma(z :: float) :: float
  def digamma(z) when is_float(z), do: _digamma(z)
  def _digamma(_z), do: "NIF library not loaded"

  @doc """
  Provides the log gamma function.

  ## Examples

      iex> Exboost.Math.lgamma(2.0)
      0.0

  """
  @spec lgamma(z :: float) :: float
  def lgamma(z) when is_float(z), do: _lgamma(z)
  def _lgamma(_z), do: "NIF library not loaded"
end
