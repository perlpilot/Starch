#!/usr/bin/env perl
use strictures 2;

use Test::More;
use Test::Fatal;

use Starch;
use Starch::Store::Memory;

{
    package Starch::Store::CroakMemory;
    use Moo;
    extends 'Starch::Store::Memory';
    use Starch::Util qw( croak );
    sub set { croak 'foo' }
}

my $starch = Starch->new( store=>{class=>'::CroakMemory'} );

like(
    exception { $starch->state->force_save() },
    qr{^foo at \S*croak.t line \d+\.\s*$},
    'croak reported proper caller',
);

done_testing;