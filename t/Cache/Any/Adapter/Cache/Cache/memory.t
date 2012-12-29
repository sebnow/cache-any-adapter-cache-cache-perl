#!/usr/bin/env perl
use strict;
use warnings;

use Cache::Any::Adapter;
use Cache::Any;
use Cache::MemoryCache;
use Test::More tests => 8;

my $ADAPTER = 'Cache::Cache';
my $memory_cache = Cache::MemoryCache->new();
Cache::Any::Adapter->set($ADAPTER, 'cache' => $memory_cache);
my $cache = Cache::Any->get_cache();

{
	$cache->set('foo', 'bar');
	is($cache->get('foo'), 'bar',
		"Given I initialised the \"$ADAPTER\" adapter, " .
		'when I cache "bar" using the key "foo", ' .
		'then I should get "bar" for the key "foo"');
	$memory_cache->clear();
}

{
	$cache->replace('foo', 'zing');
	is($cache->get('foo'), undef,
		"Given I initialised the \"$ADAPTER\" adapter, " .
		'and the key "foo" does not exist, ' .
		'when I replace "zing" for the key "foo", ' .
		'then the key "foo" should not exist');
	$cache->set('foo', 'bar');
	$cache->replace('foo', 'zing');
	is($cache->get('foo'), 'zing',
		"Given I initialised the \"$ADAPTER\" adapter, " .
		'and I cached "bar" using the key "foo", ' .
		'when I replace "zing" for the key "foo", ' .
		'then I should get "zing" for the key "foo"');

	$memory_cache->clear();
}

{
	$cache->add('foo', 'bar');
	is($cache->get('foo'), 'bar',
		"Given I initialised the \"$ADAPTER\" adapter, " .
		'and the key "foo" does not exist, ' .
		'when I add "bar" for the key "foo", ' .
		'then I should get "bar" for the key "foo"');
	$cache->add('foo', 'zing');
	is($cache->get('foo'), 'bar',
		"Given I initialised the \"$ADAPTER\" adapter, " .
		'and I cached "bar" using the key "foo", ' .
		'when I add "zing" for the key "foo", ' .
		'then I should get "bar" for the key "foo"');
	$memory_cache->clear();
}

{
	$cache->set('foo', 'bar');
	$cache->remove('foo');
	is($cache->get('foo'), undef,
		"Given I initialised the \"$ADAPTER\" adapter, " .
		'and I cached "bar" using the key "foo", ' .
		'when I remove the key "foo", ' .
		'then the key "foo" should not exist');
	$memory_cache->clear();
}

{
	ok(!$cache->exists('foo'),
		"Given I initialised the \"$ADAPTER\" adapter, " .
		'and I have not set the "foo" key, ' .
		'then the key "foo" should not exist');
	$cache->set('foo', 'bar');
	ok($cache->exists('foo'),
		"Given I initialised the \"$ADAPTER\" adapter, " .
		'and I cached "bar" using the key "foo", ' .
		'then the key "foo" should exist');
	$memory_cache->clear();
}

