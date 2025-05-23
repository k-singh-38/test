package collaborations

import * from dw::core::Strings

fun parse_hl7_message(str_message) {
  var segments = str_message splitBy '\r';
  var parsed_map = {};

  var segment_mapping = {
    'MSA': {
      'segment_ID': 0,
      'acknowledgment_code': 1,
      'message_control_ID': 2,
      'text_message': 3,
      'expected_sequence_number': 4,
      'delayed_acknowledgment_type': 5,
      'error_condition': 6
    },
    'ERR': {
      'segment_ID': 0,
      'error_code_location': 1
    },
    'HD': {
      'namespace_ID': 0,
      'universal_ID': 1,
      'universal_ID_type': 2
    },
    'VID': {
      'version_ID': 0,
      'internationalization_code': 1,
      'international_version_ID': 2
    },
    'PT': {
      'processing_ID': 0,
      'processing_mode': 1
    }
  };

  for (segment in segments) {
    var segment_name = segment splitBy '|'[0];
    var fields = segment splitBy '|';

    if (segment_mapping[segment_name] != null) {
      var segment_fields = segment_mapping[segment_name];
      var segment_object = {};

      for (field_name in segment_fields) {
        var field_index = segment_fields[field_name];
        if (field_index < sizeOf(fields)) {
          segment_object[field_name] = fields[field_index];
        } else {
          segment_object[field_name] = null;
        }
      }

      parsed_map[segment_name] = segment_object;
    }
  }

  return parsed_map;
}