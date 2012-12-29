#!/usr/bin/env perl
use strict;
use warnings;

use Cache::Any::Adapter::Cache::Cache;
use Test::Exception;
use Test::MockObject;
use Test::More tests => 2;
use constant ADAPTER_CLASS => 'Cache::Any::Adapter::Cache::Cache';

my $cache = Test::MockObject->new();
lives_ok(sub {ADAPTER_CLASS->new('cache' => $cache)});
throws_ok(sub {ADAPTER_CLASS->new()}, qr/cache not provided/);

