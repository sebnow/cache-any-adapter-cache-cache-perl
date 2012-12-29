#!/usr/bin/env perl
use strict;
use warnings;
use Cache::Any::Adapter::Cache::Cache;
use Test::MockObject;
use Test::MockModule;
use Test::More tests => 6;

use constant ADAPTER_CLASS => 'Cache::Any::Adapter::Cache::Cache';

{
	my @subs = qw(get set);
	my $cache = Test::MockObject->new();
	$cache->set_true(@subs);

	my $adapter = ADAPTER_CLASS->new('cache' => $cache);
	foreach my $sub (@subs) {
		$cache->clear();
		$adapter->$sub('foo', 'bar');
		$cache->called_ok($sub,
			'Given a mocked cache, ' .
			'and an adapter set with the cache, ' .
			"when the \"$sub\" method is called on the adapter, " .
			"then the \"$sub\" method should be called on the cache");
	}
}

# Remove is a Test::MockObject method so which conflicts with the
# Cache::Any API. Use Test::MockModule instead.
{
	my $module = Test::MockModule->new('Mock::Cache', 'no_auto' => 1);
	$module->mock('new', sub {bless({'remove_called' => 0}, 'Mock::Cache')});
	$module->mock('remove', sub {shift->{'remove_called'} = 1});

	my $cache = $module->get_package->new();
	my $adapter = ADAPTER_CLASS->new('cache' => $cache);
	$adapter->remove('foo');
	ok($cache->{'remove_called'},
		'Given a mocked cache, ' .
		'and an adapter set with the cache, ' .
		"when the \"remove\" method is called on the adapter, " .
		"then the \"remove\" method should be called on the cache");
}

{
	my $cache = Test::MockObject->new();
	$cache->set_true('get');
	my $adapter = ADAPTER_CLASS->new('cache' => $cache);
	$adapter->exists('foo');
	$cache->called_ok('get',
		'Given a mocked cache, ' .
		'and an adapter set with the cache, ' .
		'when the "exists" method is called on the adapter, ' .
		'then the "get" method should be called on the cache');
}

{
	my $cache = Test::MockObject->new();
	$cache->set_true('set', 'get');
	my $adapter = ADAPTER_CLASS->new('cache' => $cache);
	$adapter->replace('foo', 'bar');
	$cache->called_ok('set',
		'Given a mocked cache, ' .
		'and an adapter set with the cache, ' .
		'when the "get" cache method returns true, ' .
		'and the "replace" method is called on the adapter, ' .
		'then the "set" method should be called on the cache');
}

{
	my $cache = Test::MockObject->new();
	$cache->set_true('set');
	$cache->set_false('get');
	my $adapter = ADAPTER_CLASS->new('cache' => $cache);
	$adapter->add('foo', 'bar');
	$cache->called_ok('set',
		'Given a mocked cache, ' .
		'and an adapter set with the cache, ' .
		'when the "get" cache method returns false, ' .
		'and the "add" method is called on the adapter, ' .
		'then the "set" method should be called on the cache');
}

