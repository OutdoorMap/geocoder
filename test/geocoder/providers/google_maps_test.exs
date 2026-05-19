defmodule Geocoder.Providers.GoogleMapsTest do
  use ExUnit.Case, async: true

  alias Geocoder.Providers.GoogleMaps

  import Hammox
  import Geocoder.Support.Helpers

  setup :verify_on_exit!

  describe "geocode/1" do
    test "make a valid request" do
      Geocoder.HttpClientMock
      |> expect(:request, fn req, _config ->
        assert req == %{
                 method: :get,
                 query_params: %{
                   address: "Dikkelindestraat 46, 9032 Wondelgem, Belgium",
                   key: nil,
                   latlng: nil
                 },
                 url: "https://maps.googleapis.com/maps/api/geocode/json"
               }

        {:ok,
         %{
           status_code: 200,
           headers: [],
           body: belgium_googlemap_payload()
         }}
      end)

      {:ok, coords} =
        GoogleMaps.geocode(
          [
            store: Geocoder.Store,
            provider: Geocoder.Providers.GoogleMaps,
            address: "Dikkelindestraat 46, 9032 Wondelgem, Belgium"
          ],
          http_client: Geocoder.HttpClientMock
        )

      assert_belgium(coords)
    end
  end

  describe "geocode_list/1" do
    test "make a valid request" do
      Geocoder.HttpClientMock
      |> expect(:request, fn req, _config ->
        assert req == %{
                 method: :get,
                 query_params: %{
                   address: "Dikkelindestraat 46, 9032 Wondelgem, Belgium",
                   key: nil,
                   latlng: nil
                 },
                 url: "https://maps.googleapis.com/maps/api/geocode/json"
               }

        {:ok,
         %{
           status_code: 200,
           headers: [],
           body: belgium_googlemap_payload()
         }}
      end)

      {:ok, coords} =
        GoogleMaps.geocode_list(
          [
            store: Geocoder.Store,
            provider: Geocoder.Providers.GoogleMaps,
            address: "Dikkelindestraat 46, 9032 Wondelgem, Belgium"
          ],
          http_client: Geocoder.HttpClientMock
        )

      assert is_list(coords)
      assert Enum.count(coords) > 0
      assert_belgium(coords |> List.first())
    end
  end

  describe "reverse_geocode/1" do
    test "make a valid request" do
      Geocoder.HttpClientMock
      |> expect(:request, fn req, _config ->
        assert req == %{
                 method: :get,
                 query_params: %{key: nil, latlng: "51.0775264,3.7073382"},
                 url: "https://maps.googleapis.com/maps/api/geocode/json"
               }

        {:ok,
         %{
           status_code: 200,
           headers: [],
           body: belgium_googlemap_payload()
         }}
      end)

      {:ok, coords} =
        GoogleMaps.reverse_geocode(
          [
            store: Geocoder.Store,
            provider: Geocoder.Providers.Fake,
            lat: 51.0775264,
            lon: 3.7073382,
            latlng: {51.0775264, 3.7073382}
          ],
          http_client: Geocoder.HttpClientMock
        )

      assert_belgium(coords)
    end

    test "parses real Google Maps data for Handen coordinates" do
      Geocoder.HttpClientMock
      |> expect(:request, fn req, _config ->
        assert req == %{
                 method: :get,
                 query_params: %{key: nil, latlng: "59.1727882,18.1427788"},
                 url: "https://maps.googleapis.com/maps/api/geocode/json"
               }

        {:ok,
         %{
           status_code: 200,
           headers: [],
           body: handen_googlemap_payload()
         }}
      end)

      {:ok, coords} =
        GoogleMaps.reverse_geocode(
          [
            store: Geocoder.Store,
            provider: Geocoder.Providers.Fake,
            lat: 59.1727882,
            lon: 18.1427788,
            latlng: {59.1727882, 18.1427788}
          ],
          http_client: Geocoder.HttpClientMock
        )

      assert_handen(coords)
    end
  end

  describe "reverse_geocode_list/1" do
    test "make a valid request" do
      Geocoder.HttpClientMock
      |> expect(:request, fn req, _config ->
        assert req == %{
                 method: :get,
                 query_params: %{key: nil, latlng: "51.0775264,3.7073382"},
                 url: "https://maps.googleapis.com/maps/api/geocode/json"
               }

        {:ok,
         %{
           status_code: 200,
           headers: [],
           body: belgium_googlemap_payload()
         }}
      end)

      {:ok, coords} =
        GoogleMaps.reverse_geocode_list(
          [
            store: Geocoder.Store,
            provider: Geocoder.Providers.Fake,
            latlng: {51.0775264, 3.7073382}
          ],
          http_client: Geocoder.HttpClientMock
        )

      assert is_list(coords)
      assert Enum.count(coords) > 0
      assert_belgium(coords |> List.first())
    end

    test "parses real Google Maps data for Handen coordinates" do
      Geocoder.HttpClientMock
      |> expect(:request, fn req, _config ->
        assert req == %{
                 method: :get,
                 query_params: %{key: nil, latlng: "59.1727882,18.1427788"},
                 url: "https://maps.googleapis.com/maps/api/geocode/json"
               }

        {:ok,
         %{
           status_code: 200,
           headers: [],
           body: handen_googlemap_payload()
         }}
      end)

      {:ok, coords} =
        GoogleMaps.reverse_geocode_list(
          [
            store: Geocoder.Store,
            provider: Geocoder.Providers.Fake,
            latlng: {59.1727882, 18.1427788}
          ],
          http_client: Geocoder.HttpClientMock
        )

      assert is_list(coords)
      assert Enum.count(coords) > 0
      assert_handen(coords |> List.first())
    end
  end

  defp assert_handen(%Geocoder.Coords{lat: lat, lon: lon, location: location}) do
    assert lat == 59.17268539999999
    assert lon == 18.1425823

    assert location.street_number == "1"
    assert location.street == "Parkvägen"
    assert location.city == "Handen"
    assert location.country == "Sweden"
    assert location.country_code == "SE"
    assert location.postal_code == "136 46"
    assert location.formatted_address == "Parkvägen 1, 136 46 Handen, Sweden"
  end
end
