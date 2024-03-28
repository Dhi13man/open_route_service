import 'package:geodart/geometries.dart';
import 'package:open_route_service/open_route_service.dart';
import 'package:test/test.dart';

void geoJsonTests() {
  test('Test GeoJSON Coordinate Point serialization', () {
    // Arrange
    final List<ORSCoordinate> coordinates = <ORSCoordinate>[
      ORSCoordinate(latitude: 1.5, longitude: 0.0)
    ];
    final GeoJsonFeature feature = GeoJsonFeature(
      type: 'Feature',
      geometry: GeoJsonFeatureGeometry(
        coordinates: <List<ORSCoordinate>>[coordinates],
        type: 'Point',
        internalType: GsonFeatureGeometryCoordinatesType.list,
      ),
      properties: <String, dynamic>{},
    );

    // Act
    final Map<String, dynamic> result = feature.toJson();

    // Assert
    expect(
      result,
      <String, dynamic>{
        'type': 'Feature',
        'geometry': <String, dynamic>{
          'type': 'Point',
          'coordinates': <List<double>>[
            <double>[0.0, 1.5]
          ]
        },
        'properties': <String, dynamic>{}
      },
    );
  });

  test('Test GeoJSON Coordinate Point deserialization', () {
    // Arrange
    final Map<String, dynamic> json = <String, dynamic>{
      'type': 'Feature',
      'geometry': <String, dynamic>{
        'type': 'Point',
        'coordinates': <List<double>>[
          <double>[0.0, 1.5]
        ]
      },
      'properties': <String, dynamic>{}
    };

    // Act
    final GeoJsonFeature result = GeoJsonFeature.fromJson(json);

    // Assert
    final List<ORSCoordinate> coordinates = <ORSCoordinate>[
      ORSCoordinate(longitude: 0.0, latitude: 1.5)
    ];
    final GeoJsonFeature expected = GeoJsonFeature(
      type: 'Feature',
      geometry: GeoJsonFeatureGeometry(
        coordinates: <List<ORSCoordinate>>[coordinates],
        type: 'Point',
        internalType: GsonFeatureGeometryCoordinatesType.list,
      ),
      properties: <String, dynamic>{},
    );
    expect(result.bbox, expected.bbox);
    expect(result.properties, expected.properties);
    expect(result.type, expected.type);
    expect(result.geometry.internalType, expected.geometry.internalType);
    expect(result.geometry.type, expected.geometry.type);
    for (int i = 0; i < result.geometry.coordinates.length; i++) {
      for (int j = 0; j < result.geometry.coordinates[i].length; j++) {
        expect(
          result.geometry.coordinates[i][j].latitude,
          expected.geometry.coordinates[i][j].latitude,
        );
        expect(
          result.geometry.coordinates[i][j].longitude,
          expected.geometry.coordinates[i][j].longitude,
        );
      }
    }
  });

  test('Test GeoJSON Coordinate Point serialization and deserialization', () {
    // Arrange
    final Point original = Point(Coordinate(51.5, 0.0));

    // Act
    final Map<String, dynamic> jsonPoint = original.toJson();
    final GeoJsonFeature feature = GeoJsonFeature.fromJson(jsonPoint);
    final Map<String, dynamic> featureJson = feature.toJson();
    final Point result = Point.fromJson(featureJson);

    // Assert
    expect(result.bbox.center, original.bbox.center);
    expect(result.bbox.maxLat, original.bbox.maxLat);
    expect(result.bbox.maxLong, original.bbox.maxLong);
    expect(result.bbox.minLat, original.bbox.minLat);
    expect(result.bbox.minLong, original.bbox.minLong);
    expect(result.properties, original.properties);
  });
}
