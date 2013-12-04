package Tool::Detail::Input;

use Moose::Role;
use warnings FATAL => 'all';

Moose::Util::meta_attribute_alias('Input');

has array => (
    is => 'ro',
    isa => 'Bool',
);

1;
