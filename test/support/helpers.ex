defmodule Geocoder.Support.Helpers do
  @moduledoc """
  a set of assertion or configuration helpers to avoid cluttering the tests
  """
  import ExUnit.Assertions

  def assert_belgium(%{bounds: bounds, location: location, lat: lat, lon: lon}) do
    # Bounds are not always returned
    assert nil == bounds.bottom || bounds.bottom |> Float.round(2) == 51.08
    assert nil == bounds.left || bounds.left |> Float.round(2) == 3.71
    assert nil == bounds.right || bounds.right |> Float.round(2) == 3.71
    assert nil == bounds.top || bounds.top |> Float.round(2) == 51.08

    assert nil == location.street_number || location.street_number == "46"
    assert location.street == "Dikkelindestraat"
    assert location.city == "Gent" || location.city == "Ghent"
    assert location.country == "Belgium"
    assert location.country_code |> String.upcase() == "BE"
    assert location.postal_code == "9032"
    # lhs:  "Dikkelindestraat, Wondelgem, Ghent, Gent, East Flanders, Flanders, 9032, Belgium"
    # rhs:  "Dikkelindestraat 46, 9032 Gent, Belgium"
    assert location.formatted_address |> String.match?(~r/Dikkelindestraat/)

    assert location.formatted_address |> String.match?(~r/Gent/) ||
             location.formatted_address |> String.match?(~r/Ghent/)

    assert location.formatted_address |> String.match?(~r/9032/)
    assert location.formatted_address |> String.match?(~r/Belgium/)
    assert lat |> Float.round(2) == 51.08
    assert lon |> Float.round(2) == 3.71
  end

  def assert_new_york(%Geocoder.Coords{location: location}) do
    assert location.street_number == "1991"
    assert location.street == "15th Street"
    assert String.contains?(location.city, "Troy")
    assert location.county == "Rensselaer County"
    assert location.country_code |> String.upcase() == "US"
    assert location.postal_code == "12180"
  end

  def assert_sao_paulo(%{location: location, partial_match: partial_match}) do
    assert location.country == "Brazil"
    assert location.country_code |> String.upcase() == "BR"
    assert location.county == "São Paulo"

    assert location.formatted_address ==
             "Travessa Mário Antônio Correia, 80 - Tucuruvi, São Paulo - SP, 02342-170, Brazil"

    assert location.postal_code == "02342-170"
    assert location.street == "Travessa Mário Antônio Correia"
    assert location.street_number == "80"
    assert partial_match == true
  end

  def belgium_openstreetmap_payload do
    %{
      "address" => %{
        "city" => "Ghent",
        "city_district" => "Wondelgem",
        "country" => "Belgium",
        "country_code" => "be",
        "county" => "Gent",
        "postcode" => "9032",
        "road" => "Dikkelindestraat",
        "state" => "Flanders"
      },
      "boundingbox" => ["51.075731", "51.0786674", "3.7063849", "3.7083991"],
      "display_name" =>
        "Dikkelindestraat, Wondelgem, Ghent, Gent, East Flanders, Flanders, 9032, Belgium",
      "lat" => "51.0772661",
      "licence" =>
        "Data © OpenStreetMap contributors, ODbL 1.0. http://www.openstreetmap.org/copyright",
      "lon" => "3.7074267",
      "osm_id" => "45352282",
      "osm_type" => "way",
      "place_id" => "70350383"
    }
  end

  def belgium_coords do
    %Geocoder.Coords{
      lat: 51.0772661,
      lon: 3.7074267,
      bounds: %Geocoder.Bounds{
        top: 51.075731,
        right: 3.7083991,
        bottom: 51.0786674,
        left: 3.7063849
      },
      location: %Geocoder.Location{
        city: "Ghent",
        state: "Flanders",
        county: "Gent",
        country: "Belgium",
        postal_code: "9032",
        street: "Dikkelindestraat",
        street_number: nil,
        country_code: "be",
        formatted_address:
          "Dikkelindestraat, Wondelgem, Ghent, Gent, East Flanders, Flanders, 9032, Belgium"
      },
      partial_match: nil
    }
  end

  def fake_data_cache do
    %{
      ~r/.*Troy, NY.*/ => %{
        lat: 0.0,
        lon: 0.0,
        bounds: %{
          top: 0.0,
          right: 0.0,
          bottom: 0.0,
          left: 0.0
        },
        location: %{
          street_number: "1991",
          street: "15th Street",
          city: "Troy",
          county: "Rensselaer County",
          country_code: "us",
          postal_code: "12180"
        }
      },
      ~r/.*Wondelgem, Belgium.*/ => %{
        lat: 51.0775527,
        lon: 3.7074204,
        bounds: %{
          bottom: 51.077496,
          left: 3.7073144,
          right: 3.7075457,
          top: 51.0776028
        },
        location: %{
          city: "Ghent",
          country: "Belgium",
          country_code: "be",
          county: "Gent",
          formatted_address: "Dikkelindestraat 46, 9032 Ghent, Belgium",
          postal_code: "9032",
          state: "East Flanders",
          street: "Dikkelindestraat",
          street_number: "46"
        }
      },
      {51.0775264, 3.7073382} => %{
        lat: 51.0775527,
        lon: 3.7074204,
        bounds: %{
          bottom: 51.077496,
          left: 3.7073144,
          right: 3.7075457,
          top: 51.0776028
        },
        location: %{
          city: "Ghent",
          country: "Belgium",
          country_code: "be",
          county: "Gent",
          formatted_address: "Dikkelindestraat 46, 9032 Ghent, Belgium",
          postal_code: "9032",
          state: "East Flanders",
          street: "Dikkelindestraat",
          street_number: "46"
        }
      },
      ~r/.*São Paulo, Brazil.*/ => %{
        lat: -23.473875,
        lon: -46.6088782,
        bounds: %{
          bottom: nil,
          left: nil,
          right: nil,
          top: nil
        },
        location: %{
          city: nil,
          country: "Brazil",
          country_code: "BR",
          county: "São Paulo",
          formatted_address:
            "Travessa Mário Antônio Correia, 80 - Tucuruvi, São Paulo - SP, 02342-170, Brazil",
          postal_code: "02342-170",
          state: "São Paulo",
          street: "Travessa Mário Antônio Correia",
          street_number: "80"
        },
        partial_match: true
      }
    }
  end

  def provider_test_config(provider, key) do
    case provider do
      "google" ->
        [
          worker_config: [
            provider: Geocoder.Providers.GoogleMaps,
            key: key,
            http_client: Geocoder.HttpClient.Hackney
          ]
        ]

      "opencagedata" ->
        [
          worker_config: [
            provider: Geocoder.Providers.OpenCageData,
            key: key
          ]
        ]

      "openstreetmaps" ->
        [
          worker_config: [
            provider: Geocoder.Providers.OpenStreetMaps
          ]
        ]

      "fake" ->
        [
          worker_config: [
            provider: Geocoder.Providers.Fake,
            data: fake_data_cache()
          ]
        ]

      _ ->
        raise "Unsupported provider. Must be one of: google, opencagedata, openstreetmaps or fake. Default is fake"
    end
  end

  def belgium_googlemap_payload do
    %{
      "results" => [
        %{
          "address_components" => [
            %{
              "long_name" => "46",
              "short_name" => "46",
              "types" => ["street_number"]
            },
            %{
              "long_name" => "Dikkelindestraat",
              "short_name" => "Dikkelindestraat",
              "types" => ["route"]
            },
            %{
              "long_name" => "Gent",
              "short_name" => "Gent",
              "types" => ["locality", "political"]
            },
            %{
              "long_name" => "Oost-Vlaanderen",
              "short_name" => "OV",
              "types" => ["administrative_area_level_2", "political"]
            },
            %{
              "long_name" => "Vlaams Gewest",
              "short_name" => "Vlaams Gewest",
              "types" => ["administrative_area_level_1", "political"]
            },
            %{
              "long_name" => "Belgium",
              "short_name" => "BE",
              "types" => ["country", "political"]
            },
            %{
              "long_name" => "9032",
              "short_name" => "9032",
              "types" => ["postal_code"]
            }
          ],
          "formatted_address" => "Dikkelindestraat 46, 9032 Gent, Belgium",
          "geometry" => %{
            "location" => %{"lat" => 51.0775297, "lng" => 3.70734},
            "location_type" => "ROOFTOP",
            "viewport" => %{
              "northeast" => %{
                "lat" => 51.0788726802915,
                "lng" => 3.708676980291502
              },
              "southwest" => %{
                "lat" => 51.0761747197085,
                "lng" => 3.705979019708498
              }
            }
          },
          "place_id" => "ChIJNVeLFB1xw0cRxjH2l4f2aCg",
          "plus_code" => %{
            "compound_code" => "3PH4+2W Ghent, Belgium",
            "global_code" => "9F353PH4+2W"
          },
          "types" => ["street_address"]
        }
      ],
      "status" => "OK"
    }
  end

  def handen_googlemap_payload do
    %{
      "plus_code" => %{
        "compound_code" => "54FV+446 Haninge, Sweden",
        "global_code" => "9FFW54FV+446"
      },
      "results" => [
        %{
          "address_components" => [
            %{"long_name" => "1", "short_name" => "1", "types" => ["street_number"]},
            %{
              "long_name" => "Parkvägen",
              "short_name" => "Parkvägen",
              "types" => ["route"]
            },
            %{"long_name" => "Handen", "short_name" => "Handen", "types" => ["postal_town"]},
            %{
              "long_name" => "Stockholms län",
              "short_name" => "Stockholms län",
              "types" => ["administrative_area_level_1", "political"]
            },
            %{"long_name" => "Sweden", "short_name" => "SE", "types" => ["country", "political"]},
            %{"long_name" => "136 46", "short_name" => "136 46", "types" => ["postal_code"]}
          ],
          "formatted_address" => "Parkvägen 1, 136 46 Handen, Sweden",
          "geometry" => %{
            "location" => %{"lat" => 59.17268539999999, "lng" => 18.1425823},
            "location_type" => "ROOFTOP",
            "viewport" => %{
              "northeast" => %{"lat" => 59.1740343802915, "lng" => 18.1439312802915},
              "southwest" => %{"lat" => 59.17133641970849, "lng" => 18.1412333197085}
            }
          },
          "navigation_points" => [
            %{"location" => %{"latitude" => 59.1731324, "longitude" => 18.1427883}},
            %{"location" => %{"latitude" => 59.1723731, "longitude" => 18.1427045}}
          ],
          "place_id" => "ChIJ9y1Zf397X0YR5l7GFXTMXqM",
          "plus_code" => %{
            "compound_code" => "54FV+32 Haninge, Sweden",
            "global_code" => "9FFW54FV+32"
          },
          "types" => ["establishment", "parking", "point_of_interest"]
        },
        %{
          "address_components" => [
            %{"long_name" => "8", "short_name" => "8", "types" => ["street_number"]},
            %{
              "long_name" => "Dalarövägen",
              "short_name" => "Dalarövägen",
              "types" => ["route"]
            },
            %{"long_name" => "Handen", "short_name" => "Handen", "types" => ["postal_town"]},
            %{
              "long_name" => "Stockholms län",
              "short_name" => "Stockholms län",
              "types" => ["administrative_area_level_1", "political"]
            },
            %{"long_name" => "Sweden", "short_name" => "SE", "types" => ["country", "political"]},
            %{"long_name" => "136 46", "short_name" => "136 46", "types" => ["postal_code"]}
          ],
          "formatted_address" => "Dalarövägen 8, 136 46 Handen, Sweden",
          "geometry" => %{
            "bounds" => %{
              "northeast" => %{"lat" => 59.17310639999999, "lng" => 18.1436137},
              "southwest" => %{"lat" => 59.17284799999999, "lng" => 18.1429279}
            },
            "location" => %{"lat" => 59.17297259999999, "lng" => 18.1432542},
            "location_type" => "ROOFTOP",
            "viewport" => %{
              "northeast" => %{"lat" => 59.1743261802915, "lng" => 18.1446197802915},
              "southwest" => %{"lat" => 59.17162821970849, "lng" => 18.1419218197085}
            }
          },
          "navigation_points" => [
            %{"location" => %{"latitude" => 59.1728755, "longitude" => 18.1432847}}
          ],
          "place_id" => "ChIJ8bs9KoB7X0YR-iCtDbQ3SiI",
          "types" => ["premise", "street_address"]
        },
        %{
          "address_components" => [
            %{"long_name" => "1", "short_name" => "1", "types" => ["street_number"]},
            %{
              "long_name" => "Parkvägen",
              "short_name" => "Parkvägen",
              "types" => ["route"]
            },
            %{"long_name" => "Handen", "short_name" => "Handen", "types" => ["postal_town"]},
            %{
              "long_name" => "Stockholms län",
              "short_name" => "Stockholms län",
              "types" => ["administrative_area_level_1", "political"]
            },
            %{"long_name" => "Sweden", "short_name" => "SE", "types" => ["country", "political"]},
            %{"long_name" => "136 46", "short_name" => "136 46", "types" => ["postal_code"]}
          ],
          "formatted_address" => "Parkvägen 1, 136 46 Handen, Sweden",
          "geometry" => %{
            "location" => %{"lat" => 59.1725134, "lng" => 18.1430582},
            "location_type" => "ROOFTOP",
            "viewport" => %{
              "northeast" => %{"lat" => 59.1738623802915, "lng" => 18.1444071802915},
              "southwest" => %{"lat" => 59.1711644197085, "lng" => 18.1417092197085}
            }
          },
          "navigation_points" => [
            %{"location" => %{"latitude" => 59.1723785, "longitude" => 18.1431971}}
          ],
          "place_id" => "ChIJFTPwg397X0YReTfl6tcRXRI",
          "types" => ["street_address", "subpremise"]
        },
        %{
          "address_components" => [
            %{"long_name" => "54FV+44", "short_name" => "54FV+44", "types" => ["plus_code"]},
            %{"long_name" => "Handen", "short_name" => "Handen", "types" => ["postal_town"]},
            %{
              "long_name" => "Stockholm County",
              "short_name" => "Stockholm County",
              "types" => ["administrative_area_level_1", "political"]
            },
            %{"long_name" => "Sweden", "short_name" => "SE", "types" => ["country", "political"]},
            %{"long_name" => "136 40", "short_name" => "136 40", "types" => ["postal_code"]}
          ],
          "formatted_address" => "54FV+44 Haninge, Sweden",
          "geometry" => %{
            "bounds" => %{
              "northeast" => %{"lat" => 59.172875, "lng" => 18.142875},
              "southwest" => %{"lat" => 59.17275000000001, "lng" => 18.14275}
            },
            "location" => %{"lat" => 59.1727882, "lng" => 18.1427788},
            "location_type" => "GEOMETRIC_CENTER",
            "viewport" => %{
              "northeast" => %{"lat" => 59.1741614802915, "lng" => 18.1441614802915},
              "southwest" => %{"lat" => 59.17146351970849, "lng" => 18.1414635197085}
            }
          },
          "place_id" => "GhIJPhF67B2WTUAR54_EJo0kMkA",
          "plus_code" => %{
            "compound_code" => "54FV+44 Haninge, Sweden",
            "global_code" => "9FFW54FV+44"
          },
          "types" => ["plus_code"]
        },
        %{
          "address_components" => [
            %{
              "long_name" => "Garagevägen",
              "short_name" => "Garagevägen",
              "types" => ["route"]
            },
            %{"long_name" => "Handen", "short_name" => "Handen", "types" => ["postal_town"]},
            %{
              "long_name" => "Stockholms län",
              "short_name" => "Stockholms län",
              "types" => ["administrative_area_level_1", "political"]
            },
            %{"long_name" => "Sweden", "short_name" => "SE", "types" => ["country", "political"]},
            %{"long_name" => "136 46", "short_name" => "136 46", "types" => ["postal_code"]}
          ],
          "formatted_address" => "Garagevägen, 136 46 Handen, Sweden",
          "geometry" => %{
            "bounds" => %{
              "northeast" => %{"lat" => 59.1733643, "lng" => 18.1449673},
              "southwest" => %{"lat" => 59.17308449999999, "lng" => 18.142801}
            },
            "location" => %{"lat" => 59.1732381, "lng" => 18.143884},
            "location_type" => "GEOMETRIC_CENTER",
            "viewport" => %{
              "northeast" => %{"lat" => 59.17457338029151, "lng" => 18.1452331302915},
              "southwest" => %{"lat" => 59.17187541970849, "lng" => 18.14253516970849}
            }
          },
          "place_id" => "ChIJlUlO04F7X0YRHhK96_K6KK0",
          "types" => ["route"]
        },
        %{
          "address_components" => [
            %{"long_name" => "136 46", "short_name" => "136 46", "types" => ["postal_code"]},
            %{"long_name" => "Handen", "short_name" => "Handen", "types" => ["postal_town"]},
            %{
              "long_name" => "Stockholms län",
              "short_name" => "Stockholms län",
              "types" => ["administrative_area_level_1", "political"]
            },
            %{"long_name" => "Sweden", "short_name" => "SE", "types" => ["country", "political"]}
          ],
          "formatted_address" => "136 46 Handen, Sweden",
          "geometry" => %{
            "bounds" => %{
              "northeast" => %{"lat" => 59.1756419, "lng" => 18.1587746},
              "southwest" => %{"lat" => 59.1640883, "lng" => 18.1375155}
            },
            "location" => %{"lat" => 59.1737942, "lng" => 18.1421502},
            "location_type" => "APPROXIMATE",
            "viewport" => %{
              "northeast" => %{"lat" => 59.1756419, "lng" => 18.1587746},
              "southwest" => %{"lat" => 59.1640883, "lng" => 18.1375155}
            }
          },
          "place_id" => "ChIJ_yV8yvmG9UYRApiQGPP-ABM",
          "types" => ["postal_code"]
        },
        %{
          "address_components" => [
            %{"long_name" => "Handen", "short_name" => "Handen", "types" => ["postal_town"]},
            %{
              "long_name" => "Stockholms län",
              "short_name" => "Stockholms län",
              "types" => ["administrative_area_level_1", "political"]
            },
            %{"long_name" => "Sweden", "short_name" => "SE", "types" => ["country", "political"]}
          ],
          "formatted_address" => "Handen, Sweden",
          "geometry" => %{
            "bounds" => %{
              "northeast" => %{"lat" => 59.1900201, "lng" => 18.1677821},
              "southwest" => %{"lat" => 59.15016480000001, "lng" => 18.101025}
            },
            "location" => %{"lat" => 59.16893460000001, "lng" => 18.1500748},
            "location_type" => "APPROXIMATE",
            "viewport" => %{
              "northeast" => %{"lat" => 59.1900201, "lng" => 18.1677821},
              "southwest" => %{"lat" => 59.15016480000001, "lng" => 18.101025}
            }
          },
          "place_id" => "ChIJVexs0Qp7X0YRokAWWiRrzUA",
          "types" => ["postal_town"]
        },
        %{
          "address_components" => [
            %{
              "long_name" => "Haninge Municipality",
              "short_name" => "Haninge Municipality",
              "types" => ["administrative_area_level_2", "political"]
            },
            %{
              "long_name" => "Stockholm County",
              "short_name" => "Stockholm County",
              "types" => ["administrative_area_level_1", "political"]
            },
            %{"long_name" => "Sweden", "short_name" => "SE", "types" => ["country", "political"]}
          ],
          "formatted_address" => "Haninge Municipality, Sweden",
          "geometry" => %{
            "bounds" => %{
              "northeast" => %{"lat" => 59.219712, "lng" => 18.9411878},
              "southwest" => %{"lat" => 58.6184374, "lng" => 17.9149522}
            },
            "location" => %{"lat" => 59.000615, "lng" => 18.3469875},
            "location_type" => "APPROXIMATE",
            "viewport" => %{
              "northeast" => %{"lat" => 59.219712, "lng" => 18.9411878},
              "southwest" => %{"lat" => 58.6184374, "lng" => 17.9149522}
            }
          },
          "place_id" => "ChIJeREN1DSP9UYR_iSfh93-8LI",
          "types" => ["administrative_area_level_2", "political"]
        },
        %{
          "address_components" => [
            %{
              "long_name" => "Stockholm County",
              "short_name" => "Stockholm County",
              "types" => ["administrative_area_level_1", "political"]
            },
            %{"long_name" => "Sweden", "short_name" => "SE", "types" => ["country", "political"]}
          ],
          "formatted_address" => "Stockholm County, Sweden",
          "geometry" => %{
            "bounds" => %{
              "northeast" => %{"lat" => 60.30071210000001, "lng" => 19.7424},
              "southwest" => %{"lat" => 58.4888899, "lng" => 17.2449257}
            },
            "location" => %{"lat" => 59.4069048, "lng" => 18.8230665},
            "location_type" => "APPROXIMATE",
            "viewport" => %{
              "northeast" => %{"lat" => 60.30071210000001, "lng" => 19.7424},
              "southwest" => %{"lat" => 58.4888899, "lng" => 17.2449257}
            }
          },
          "place_id" => "ChIJPauYNIoH2EUR-vzAobVCa7M",
          "types" => ["administrative_area_level_1", "political"]
        },
        %{
          "address_components" => [
            %{"long_name" => "Sweden", "short_name" => "SE", "types" => ["country", "political"]}
          ],
          "formatted_address" => "Sweden",
          "geometry" => %{
            "bounds" => %{
              "northeast" => %{"lat" => 69.0599735, "lng" => 24.1776852},
              "southwest" => %{"lat" => 55.0059799, "lng" => 10.5798}
            },
            "location" => %{"lat" => 60.12816100000001, "lng" => 18.643501},
            "location_type" => "APPROXIMATE",
            "viewport" => %{
              "northeast" => %{"lat" => 69.0599735, "lng" => 24.1776852},
              "southwest" => %{"lat" => 55.0059799, "lng" => 10.5798}
            }
          },
          "place_id" => "ChIJ8fA1bTmyXEYRYm-tjaLruCI",
          "types" => ["country", "political"]
        }
      ],
      "status" => "OK"
    }
  end

  def belgium_opencagedata_payload do
    %{
      "documentation" => "https://opencagedata.com/api",
      "licenses" => [
        %{
          "name" => "see attribution guide",
          "url" => "https://opencagedata.com/credits"
        }
      ],
      "rate" => %{"limit" => 2500, "remaining" => 2494, "reset" => 1_691_625_600},
      "results" => [
        %{
          "annotations" => %{
            "DMS" => %{
              "lat" => "51° 4' 39.18972'' N",
              "lng" => "3° 42' 26.71344'' E"
            },
            "MGRS" => "31UES4955658687",
            "Maidenhead" => "JO11ub48vo",
            "Mercator" => %{"x" => 412_708.149, "y" => 6_601_759.73},
            "NUTS" => %{
              "NUTS0" => %{"code" => "BE"},
              "NUTS1" => %{"code" => "BE2"},
              "NUTS2" => %{"code" => "BE23"},
              "NUTS3" => %{"code" => "BE234"}
            },
            "OSM" => %{
              "edit_url" =>
                "https://www.openstreetmap.org/edit?way=629451771#map=16/51.07755/3.70742",
              "note_url" =>
                "https://www.openstreetmap.org/note/new#map=16/51.07755/3.70742&layers=N",
              "url" =>
                "https://www.openstreetmap.org/?mlat=51.07755&mlon=3.70742#map=16/51.07755/3.70742"
            },
            "UN_M49" => %{
              "regions" => %{
                "BE" => "056",
                "EUROPE" => "150",
                "WESTERN_EUROPE" => "155",
                "WORLD" => "001"
              },
              "statistical_groupings" => ["MEDC"]
            },
            "callingcode" => 32,
            "currency" => %{
              "alternate_symbols" => [],
              "decimal_mark" => ",",
              "html_entity" => "€",
              "iso_code" => "EUR",
              "iso_numeric" => "978",
              "name" => "Euro",
              "smallest_denomination" => 1,
              "subunit" => "Cent",
              "subunit_to_unit" => 100,
              "symbol" => "€",
              "symbol_first" => 0,
              "thousands_separator" => "."
            },
            "flag" => "🇧🇪",
            "geohash" => "u14ds67sm1vj8nspqj3z",
            "qibla" => 122.94,
            "roadinfo" => %{
              "drive_on" => "right",
              "road" => "Dikkelindestraat",
              "speed_in" => "km/h"
            },
            "sun" => %{
              "rise" => %{
                "apparent" => 1_691_554_980,
                "astronomical" => 1_691_545_980,
                "civil" => 1_691_552_700,
                "nautical" => 1_691_549_700
              },
              "set" => %{
                "apparent" => 1_691_608_620,
                "astronomical" => 1_691_617_560,
                "civil" => 1_691_610_900,
                "nautical" => 1_691_613_900
              }
            },
            "timezone" => %{
              "name" => "Europe/Brussels",
              "now_in_dst" => 1,
              "offset_sec" => 7200,
              "offset_string" => "+0200",
              "short_name" => "CEST"
            },
            "what3words" => %{"words" => "energetic.mildest.smashes"}
          },
          "bounds" => %{
            "northeast" => %{"lat" => 51.0776028, "lng" => 3.7075457},
            "southwest" => %{"lat" => 51.077496, "lng" => 3.7073144}
          },
          "components" => %{
            "ISO_3166-1_alpha-2" => "BE",
            "ISO_3166-1_alpha-3" => "BEL",
            "ISO_3166-2" => ["BE-VLG", "BE-VOV"],
            "_category" => "building",
            "_type" => "building",
            "city" => "Ghent",
            "city_district" => "Ghent",
            "continent" => "Europe",
            "country" => "Belgium",
            "country_code" => "be",
            "county" => "Gent",
            "house_number" => "46",
            "political_union" => "European Union",
            "postcode" => "9032",
            "region" => "Flanders",
            "road" => "Dikkelindestraat",
            "state" => "East Flanders",
            "state_code" => "VOV"
          },
          "confidence" => 10,
          "formatted" => "Dikkelindestraat 46, 9032 Ghent, Belgium",
          "geometry" => %{"lat" => 51.0775527, "lng" => 3.7074204}
        },
        %{
          "annotations" => %{
            "DMS" => %{
              "lat" => "51° 2' 60.00000'' N",
              "lng" => "3° 43' 0.12000'' E"
            },
            "MGRS" => "31UES5023655629",
            "Maidenhead" => "JO11ub62aa",
            "Mercator" => %{"x" => 413_741.151, "y" => 6_596_892.23},
            "NUTS" => %{
              "NUTS0" => %{"code" => "BE"},
              "NUTS1" => %{"code" => "BE2"},
              "NUTS2" => %{"code" => "BE23"},
              "NUTS3" => %{"code" => "BE234"}
            },
            "OSM" => %{
              "note_url" =>
                "https://www.openstreetmap.org/note/new#map=16/51.05000/3.71670&layers=N",
              "url" =>
                "https://www.openstreetmap.org/?mlat=51.05000&mlon=3.71670#map=16/51.05000/3.71670"
            },
            "UN_M49" => %{
              "regions" => %{
                "BE" => "056",
                "EUROPE" => "150",
                "WESTERN_EUROPE" => "155",
                "WORLD" => "001"
              },
              "statistical_groupings" => ["MEDC"]
            },
            "callingcode" => 32,
            "currency" => %{
              "alternate_symbols" => [],
              "decimal_mark" => ",",
              "html_entity" => "€",
              "iso_code" => "EUR",
              "iso_numeric" => "978",
              "name" => "Euro",
              "smallest_denomination" => 1,
              "subunit" => "Cent",
              "subunit_to_unit" => 100,
              "symbol" => "€",
              "symbol_first" => 0,
              "thousands_separator" => "."
            },
            "flag" => "🇧🇪",
            "geohash" => "u14dkt67v3sru2h30u2v",
            "qibla" => 122.93,
            "roadinfo" => %{"drive_on" => "right", "speed_in" => "km/h"},
            "sun" => %{
              "rise" => %{
                "apparent" => 1_691_554_980,
                "astronomical" => 1_691_545_980,
                "civil" => 1_691_552_700,
                "nautical" => 1_691_549_700
              },
              "set" => %{
                "apparent" => 1_691_608_620,
                "astronomical" => 1_691_617_560,
                "civil" => 1_691_610_900,
                "nautical" => 1_691_613_840
              }
            },
            "timezone" => %{
              "name" => "Europe/Brussels",
              "now_in_dst" => 1,
              "offset_sec" => 7200,
              "offset_string" => "+0200",
              "short_name" => "CEST"
            },
            "what3words" => %{"words" => "silver.staked.evidently"}
          },
          "components" => %{
            "ISO_3166-1_alpha-2" => "BE",
            "ISO_3166-1_alpha-3" => "BEL",
            "_category" => "postcode",
            "_type" => "postcode",
            "continent" => "Europe",
            "country" => "Belgium",
            "country_code" => "be",
            "political_union" => "European Union",
            "postcode" => "9032",
            "state" => "Flanders"
          },
          "confidence" => 7,
          "formatted" => "9032 Flanders, Belgium",
          "geometry" => %{"lat" => 51.05, "lng" => 3.7167}
        }
      ],
      "status" => %{"code" => 200, "message" => "OK"},
      "stay_informed" => %{
        "blog" => "https://blog.opencagedata.com",
        "mastodon" => "https://en.osm.town/@opencage"
      },
      "thanks" => "For using an OpenCage API",
      "timestamp" => %{
        "created_http" => "Wed, 09 Aug 2023 17:21:25 GMT",
        "created_unix" => 1_691_601_685
      },
      "total_results" => 2
    }
  end
end
