
class WorkoutRecommendationSchema {
  static const Map<String, dynamic> value = {
    'type': 'object',
    'properties': {
      'exercises': {
        'type': 'array',
        'minItems': 1,
        'items': {
          'type': 'object',
          'properties': {
            'exerciseId': {
              'type': 'string',
            },
            'sets': {
              'type': 'array',
              'minItems': 1,
              'items': {
                'type': 'object',
                'properties': {
                  'suggestedWeight': {
                    'type': 'number',
                    'minimum': 0,
                  },
                  'suggestedReps': {
                    'type': 'integer',
                    'minimum': 1,
                  },
                },
                'required': [
                  'suggestedWeight',
                  'suggestedReps',
                ],
                'additionalProperties': false,
              },
            },
          },
          'required': [
            'exerciseId',
            'sets',
          ],
          'additionalProperties': false,
        },
      },
    },
    'required': ['exercises'],
    'additionalProperties': false,
  };
}
