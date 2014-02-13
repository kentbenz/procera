package Procera::SourceFile;

use strict;
use warnings FATAL => 'all';

use File::Spec qw();
use File::Slurp qw(write_file);
use File::Temp qw(tempdir);
use Carp qw(confess);

use Exporter 'import';
our @EXPORT_OK = qw(
    file_path
    preexisting_file_path
    use_source_path
);

my $EXTENSION = '.gms';

sub file_path {
    my $source_path = shift;

    if (my $file_path = preexisting_file_path($source_path)) {
        return $file_path;
    } else {
        return generate_file($source_path);
    }
}

sub preexisting_file_path {
    my $source_path = shift;

    my $relative_path = File::Spec->join(split(/::/, $source_path)) .
        $EXTENSION;

    for my $base_path (search_path()) {
        my $full_relative_path = File::Spec->join($base_path, $relative_path);
        my $absolute_path = File::Spec->rel2abs($full_relative_path);
        if (-f $absolute_path) {
            return $absolute_path;
        }
    }

    return;
}

sub search_path {
    if ($ENV{GMSPATH}) {
        return split(/:/, $ENV{GMSPATH});
    } else {
        return 'definitions';
    }
}

sub generate_file {
    my $source_path = shift;

    use_source_path($source_path);

    my $header = $source_path . "\n";

    my @lines;
    for my $input_name ($source_path->inputs) {
        push @lines, sprintf('    %s from @%s', $input_name, $input_name);
    }
    for my $output_name ($source_path->outputs) {
        push @lines, sprintf('    %s to @%s', $output_name, $output_name);
    }

    my $output_directory = tempdir(CLEANUP => 1);
    my $path = File::Spec->join($output_directory, "Autogenerated.$EXTENSION");

    write_file($path, $header, join(",\n", @lines) . "\n");
    return $path;
}

sub use_source_path {
    my $source_path = shift;

    eval "use $source_path";
    if ($@) {
        confess sprintf("Couldn't use source-path '%s': %s", $source_path, $@);
    }
    return;
}
