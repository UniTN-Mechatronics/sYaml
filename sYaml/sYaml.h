//
//  sYaml.h
//  sYaml
//
//  Created by Paolo Bosetti on 28/07/15.
//  Copyright (c) 2015 UniTN. All rights reserved.
//

#ifndef sYaml_sYaml_h
#define sYaml_sYaml_h
#include <yaml.h>

yaml_scalar_style_t yaml_node_style(yaml_node_t *n);
size_t yaml_node_length(yaml_node_t *n);
void yaml_node_get_value(yaml_node_t *n, char **str);

yaml_node_item_t *yaml_sequence_item_start(yaml_node_t *n);
yaml_node_item_t *yaml_sequence_item_top(yaml_node_t *n);

yaml_node_pair_t *yaml_mapping_pairs_start(yaml_node_t *n);
yaml_node_pair_t *yaml_mapping_pairs_top(yaml_node_t *n);

#endif
