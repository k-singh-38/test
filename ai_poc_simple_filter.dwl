package collaborations

import dw::core::Core
import dw::core::Error

fun process_ack_message(message_string: String): String {
  var input_map = {};
  var output_map = {};
  try {
    input_map = parse_hl7_message(message_string);
    output_map = {};
    var skip = false;
    if (input_map['MSA'] != null and sizeOf(input_map['MSA']) > 0) {
      var msa_segment = input_map['MSA'][0];
      var msa_text_message = msa_segment['MSA-3-text_message'];
      if (msa_text_message contains 'ZZZ') {
        skip = true;
      }
    }
    if (skip) {
      output_map = {};
    } else {
      output_map['MSH'] = input_map['MSH'];
      output_map['MSA'] = input_map['MSA'];
    }
    return string(output_map);
  } catch (error) {
    return '';
  } finally {
    input_map = {};
    output_map = {};
  }
}