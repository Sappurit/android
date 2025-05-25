#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;

my $indent_size = 2;  # default indent size
my $help = 0;

GetOptions(
    'indent-size=i' => \$indent_size,
    'help' => \$help,
) or die usage();

if ($help) {
    print usage();
    exit 0;
}

sub usage {
    return <<"USAGE";
Usage: $0 [--indent-size N] [file ...]

Options:
  --indent-size N   Number of spaces (or tab width) per indent level (default: 2)
  --help           Show this help message

Description:
  Reads an indented text file and outputs a tree view.
  Supports tabs (counted as indent-size spaces) and spaces.

Examples:
  $0 --indent-size 4 topics.txt
  cat topics.txt | $0 --indent-size 2
USAGE
}

my @lines;
my @indents;
my @texts;

while (<>) {
    chomp;
    my $original = $_;

    # Count leading whitespace length in spaces
    my ($ws) = $original =~ /^(\s*)/;
    my $indent_width = 0;
    for my $char (split //, $ws) {
        $indent_width += ($char eq "\t") ? $indent_size : 1;
    }

    my $level = int($indent_width / $indent_size);
    my $text = $original =~ s/^\s+//r;

    push @lines, $original;
    push @indents, $level;
    push @texts, $text;
}

for (my $i = 0; $i < @lines; $i++) {
    my $lvl = $indents[$i];
    my $curr = $texts[$i];

    if ($lvl == 0) {
        print "$curr\n";
        next;
    }

    # Determine if this is the last sibling at its level
    my $is_last = 1;
    for (my $j = $i + 1; $j < @lines; $j++) {
        if ($indents[$j] == $lvl) {
            $is_last = 0;
            last;
        }
        if ($indents[$j] < $lvl) {
            last;
        }
    }

    my $branch = $is_last ? "└── " : "├── ";

    my $prefix = "";
    for (my $k = 0; $k < $lvl - 1; $k++) {
        # Check if vertical line needed at this depth
        my $parent_has_next = 0;
        for (my $j = $i + 1; $j < @lines; $j++) {
            if ($indents[$j] == $k + 1) {
                $parent_has_next = 1;
                last;
            }
            if ($indents[$j] < $k + 1) {
                last;
            }
        }
        $prefix .= $parent_has_next ? "│   " : "    ";
    }

    print $prefix . $branch . $curr . "\n";
}
