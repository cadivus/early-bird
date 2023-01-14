import 'package:cosinuss_lib/data_model/accelerometer.dart';
import 'package:cosinuss_lib/data_model/cosinuss_data.dart';

class _DataPoint {
  final CosinussData cosinussData;
  final DateTime timestamp;

  const _DataPoint({
    required this.cosinussData,
    required this.timestamp,
  });
}

const int _infinity = 65535;

class SleepDetector {
  int sleepDetectionTimeMs = 60 * 1000;
  int accelerometerDifference = 4;

  List<_DataPoint> _dataPoints = [];

  final Map<Axis, int> _accelerometerMinValues = {
    Axis.x: _infinity,
    Axis.y: _infinity,
    Axis.z: _infinity,
  };

  final Map<Axis, int> _accelerometerMinPositions = {
    Axis.x: -1,
    Axis.y: -1,
    Axis.z: -1,
  };

  final Map<Axis, int> _accelerometerMaxValues = {
    Axis.x: -_infinity,
    Axis.y: -_infinity,
    Axis.z: -_infinity,
  };

  final Map<Axis, int> _accelerometerMaxPositions = {
    Axis.x: -1,
    Axis.y: -1,
    Axis.z: -1,
  };

  final List<Axis> _axes = [Axis.x, Axis.y, Axis.z];

  /// Invalidates cached extrema
  void _invalidateAccelerometerExtrema() {
    for (Axis axis in _axes) {
      _accelerometerMinValues[axis] = _infinity;
      _accelerometerMaxValues[axis] = -_infinity;
    }
  }

  bool _accelerometerDifferenceOverThreshold() {
    bool needsNewSearch = false;
    for (Axis axis in _axes) {
      if (_accelerometerMinValues[axis] == _infinity ||
          _accelerometerMaxValues[axis] == -_infinity) {
        needsNewSearch = true;
        break;
      }
    }

    // Search for extrema if a new search is needed
    if (needsNewSearch) {
      for (int i = 0; i < _dataPoints.length; i++) {
        Accelerometer? accelerometer =
            _dataPoints[i].cosinussData.accelerometer;
        if (accelerometer == null) {
          continue;
        }
        for (Axis axis in _axes) {
          if (accelerometer.getByAxis(axis) < _accelerometerMinValues[axis]!) {
            _accelerometerMinValues[axis] = accelerometer.getByAxis(axis);
            _accelerometerMinPositions[axis] = i;
          }

          if (accelerometer.getByAxis(axis) > _accelerometerMaxValues[axis]!) {
            _accelerometerMaxValues[axis] = accelerometer.getByAxis(axis);
            _accelerometerMaxPositions[axis] = i;
          }
        }
      }
    }

    // Didn't fall asleep if there was a too big movement
    for (Axis axis in _axes) {
      if (_accelerometerMaxValues[axis]! - _accelerometerMinValues[axis]! >
          accelerometerDifference) {
        return false;
      }
    }

    return true;
  }

  /// Detects whether the user fell asleep.
  bool _fellAsleep() {
    if (_dataPoints.length < 2) {
      return false;
    }

    DateTime firstTimestamp = _dataPoints.first.timestamp;
    DateTime lastTimestamp = _dataPoints.last.timestamp;

    // Exits if there isn't enough data
    if (lastTimestamp.difference(firstTimestamp).inMilliseconds <
        sleepDetectionTimeMs) {
      return false;
    }

    // Removes too old data
    int newFirstElementIndex = 0;
    for (int i = 0; i < _dataPoints.length; i++) {
      if (lastTimestamp.difference(_dataPoints[i].timestamp).inMilliseconds <=
          sleepDetectionTimeMs) {
        newFirstElementIndex = i;
        break;
      }
    }

    // Fixes the extrema indices after removing data
    if (newFirstElementIndex != 0) {
      _dataPoints = _dataPoints.sublist(newFirstElementIndex);
      for (Axis axis in _axes) {
        _accelerometerMinPositions[axis] =
            _accelerometerMinPositions[axis]! - newFirstElementIndex;
        _accelerometerMaxPositions[axis] =
            _accelerometerMaxPositions[axis]! - newFirstElementIndex;
      }
    }

    // Invalidate extrema if it was too long ago
    for (Axis axis in _axes) {
      if (_accelerometerMinPositions[axis]! < 0 ||
          _accelerometerMaxPositions[axis]! < 0) {
        _invalidateAccelerometerExtrema();
        break;
      }
    }

    if (_dataPoints.length < 2) {
      return false;
    }

    return _accelerometerDifferenceOverThreshold();
  }

  /// Detects sleep after adding a new data point [cosinussData].
  /// [timestamp] is optional and mainly for testing purposes. For
  /// realtime applications not using it is recommended.
  bool detectSleep(CosinussData cosinussData, {DateTime? timestamp}) {
    _DataPoint newDataPoint = _DataPoint(
      cosinussData: cosinussData,
      timestamp: timestamp ?? DateTime.now(),
    );
    _dataPoints.add(newDataPoint);

    // Invalidate extrema if new data contain a new one
    for (Axis axis in _axes) {
      if (newDataPoint.cosinussData.accelerometer != null &&
          (newDataPoint.cosinussData.accelerometer!.getByAxis(axis) <
              _accelerometerMinValues[axis]! ||
              newDataPoint.cosinussData.accelerometer!.getByAxis(axis) >
                  _accelerometerMaxValues[axis]!)) {
        _invalidateAccelerometerExtrema();
        break;
      }
    }

    return _fellAsleep();
  }

  void reset() {
    _dataPoints.clear();
    _invalidateAccelerometerExtrema();
  }
}
