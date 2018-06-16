defmodule Exboost.MixProject do
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

  use Mix.Project

  def project do
    [
      app: :exboost,
      version: "0.1.4",
      elixir: "~> 1.6",
      start_permanent: false,
      compilers: [:make, :elixir, :app], # Add the make compiler
      deps: deps(),
      ## Hex stuff:
      description: description(),
      package: package(),
      name: "ExBoost",
      source_url: "https://github.com/piisgaaf/exboost"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
#      {:boost,
#        github: "boostorg/boost",
#        tag: "boost-1.67.0",
#        submodules: true,
#        compile: "./bootstrap.sh --with-libraries=math; ./b2 headers; ./b2 link=static runtime-link=static threading=single stage",
#        app: false},
      {:ex_doc, "~> 0.16", only: :dev, runtime: false}
    ]
  end

  # Hex Package Manager stuff:
  defp description() do
    """
    Provides an elixir wrapper for the C++ Boost library.
    """
  end
  
  defp package() do
    [
      maintainers: [ "Pieter Rijken" ],
      licenses: [ "Boost 1.0" ],
      files: [ "lib", "mix.exs", "test", "README*", "LICENSE*", "priv/libboostnif.so" ],
      links: %{ "GitHub" => "https://github.com/piisgaaf/exboost" }
    ]
  end

end

defmodule Mix.Tasks.Compile.Make do
  use Mix.Task.Compiler

  @shortdoc "Compiles with make"

  def run(_) do
    try do
      {result, _error_code} = System.cmd("git",["clone","--progress","-b","boost-1.67.0","--recursive","https://github.com/boostorg/boost.git", "deps/boost"])
      Mix.shell.info result
    rescue
      _error -> IO.puts "WARNING: clonening failed. Directory already exists?"
    end

    {result, _error_code} = System.cmd("sh", ["bootstrap.sh", "--with-libraries=math"], cd: "deps/boost")
    Mix.shell.info result

    {result, _error_code} = System.cmd("env", ["-P",".","b2","headers"], cd: "deps/boost")
    Mix.shell.info result

    {result, _error_code} = System.cmd("env", ["-P",".","b2","link=static", "runtime-link=static", "threading=single", "stage"], cd: "deps/boost")
    Mix.shell.info result

    {result, _error_code} = System.cmd("make", ["priv/libboostnif.so"], stderr_to_stdout: true)
    Mix.shell.info result
  end
end
