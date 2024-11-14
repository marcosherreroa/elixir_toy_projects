defmodule Identicon do
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    #|> draw_image
    #|> save_image(input)
  end

  #def save_image(image, filename) do
  #  File.write("#{filename}.png",image)
  #end

  #def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    #image = :egd.create(250,250)
    #fill = :egd.color(color)
    #Enum.each pixel_map, fn ({start,stop}) ->
    #  :egd.filledRectangle(image,start,stop,fill)
    #end
    #:egd.render(image)
  #end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = Enum.map grid, fn ({_,ind}) ->
      horizontal = rem(ind,5)*50
      vertical = div(ind,5)*50
      top_left = {horizontal,vertical}
      bottom_right = {horizontal + 50, vertical + 50}
      {top_left,bottom_right}
    end

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid = Enum.filter(grid, fn {e,_} -> rem(e,2) == 0 end)
    %Identicon.Image{image | grid: grid}
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    #for [c1,c2,c3] <- Enum.chunk_every(hex,3) do
    #  [c1,c2,c3,c2,c1]
    #end
    grid =
      hex
      |> Enum.chunk_every(3,3,:discard)
      |> Enum.map(&mirror_row/1)
      |> List.flatten()
      |> Enum.with_index()

    %Identicon.Image{image | grid: grid}
  end

  def mirror_row ([first,second | _] = row) do
    row ++ [second,first]
  end

  def pick_color(%Identicon.Image{hex: [r,g,b | _]} = image) do
    %Identicon.Image{image | color: {r,g,b}}
  end

  def hash_input(input) do
    hex = :crypto.hash(:md5,input)
    |> :binary.bin_to_list()

    %Identicon.Image{hex: hex}
  end
end
