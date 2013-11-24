package TestTool::D;

use strict;
use warnings FATAL => 'all';

use UR;
use TestTool::Base;

class TestTool::D {
    is => 'TestTool::Base',

    has_input => [
        di1 => {
            dsl_tags => ['T2'],
        },
    ],

    has_output => [
        do1 => {
            dsl_tags => ['T4'],
        },
    ],
};


1;
