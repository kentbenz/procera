package Compiler::Importer;

use strict;
use warnings FATAL => 'all';

use UR;

use Carp qw(confess);
use Data::Dumper;
use File::Spec qw();

use constant EXTENSION => '.def';


class Compiler::Importer {
    has => [
        search_path => {
            is => 'Path',
            is_many => 1,
        },
    ],
};


sub import_file {
    my ($self, $name) = @_;

    my $absolute_path = $self->resolve_path($name);

    my $parser = Compiler::Parser->create($absolute_path);
    return $parser->parse_tree;
}


sub resolve_path {
    my ($self, $name) = @_;
    my $relative_path = $name . EXTENSION();

    for my $base_path ($self->search_path) {
        my $absolute_path = File::Spec->rel2abs(File::Spec->join(
                $base_path, $relative_path));
        if (-f $absolute_path) {
            return $absolute_path;
        }
    }

    confess sprintf("Could not find %s in search path: %s",
        $relative_path, Data::Dumper::Dumper($self->search_path));
}


1;
