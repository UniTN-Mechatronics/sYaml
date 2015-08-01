//
//  sYaml.m
//  sYaml
//
//  Created by Paolo Bosetti on 28/07/15.
//  Copyright (c) 2015 UniTN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sYamlC_enum_if.h"

yaml_scalar_style_t yaml_node_style(yaml_node_t *n) {
  return n->data.scalar.style;
}

size_t yaml_node_length(yaml_node_t *n) { return n->data.scalar.length; }

void yaml_node_get_value(yaml_node_t *n, char **str) {
  *str = (char *)n->data.scalar.value;
}

yaml_node_item_t *yaml_sequence_item_start(yaml_node_t *n) {
  return n->data.sequence.items.start;
}

yaml_node_item_t *yaml_sequence_item_top(yaml_node_t *n) {
  return n->data.sequence.items.top;
}

yaml_node_pair_t *yaml_mapping_pairs_start(yaml_node_t *n) {
  return n->data.mapping.pairs.start;
}

yaml_node_pair_t *yaml_mapping_pairs_top(yaml_node_t *n) {
  return n->data.mapping.pairs.top;
}