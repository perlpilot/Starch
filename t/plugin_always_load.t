#!/usr/bin/env perl
use strictures 2;

use Test::More;

use Starch;

my $id = 123;

{
    my $starch = Starch->new(
        store => { class => '::Memory', global => 1 },
    );
    my $state = $starch->state( $id );
    $state->data->{foo} = 456;
    $state->save();
}

subtest disabled => sub{
    my $starch = Starch->new(
        store => { class => '::Memory', global => 1 },
    );

    my $state = $starch->state( $id );
    ok( (!$state->is_loaded()), 'state is not loaded' );
    is( $state->data->{foo}, 456, 'data looks good' );
    ok( $state->is_loaded(), 'state is now loaded' );
};

subtest enabled => sub{
    my $starch = Starch->new(
        plugins => ['::AlwaysLoad'],
        store => { class => '::Memory', global => 1 },
    );

    my $state = $starch->state( $id );
    ok( $state->is_loaded(), 'state is loaded' );
    is( $state->data->{foo}, 456, 'data looks good' );
};

done_testing;
