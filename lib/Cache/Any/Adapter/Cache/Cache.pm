package Cache::Any::Adapter::Cache::Cache;
use strict;
use warnings;
use base qw(Cache::Any::Adapter::Base);

use Carp qw(croak);

our $VERSION = v0.1.0;

BEGIN {
	__PACKAGE__->delegate_method_to_slot('cache', $_, $_) for qw(get set remove);
};

sub init {
	my $self = shift;
	defined($self->{'cache'}) or croak("cache not provided");
}

sub add {
	my ($self, $key, $value, $expires) = @_;
	return $self->{'cache'}->set($key, $value, $expires)
		unless $self->exists($key);
}

sub replace {
	my ($self, $key, $value, $expires) = @_;
	return $self->set($key, $value, $expires)
		if $self->exists($key);
}

sub exists {
	my ($self, $key) = @_;
	return defined($self->{'cache'}->get($key));
}

__END__
=head1 NAME

Cache::Any::Adapter::Cache::Cache - Cache::Any adapter for Cache::Cache

=head1 SYNOPSIS

use Cache::FileCache; # Replace with any Cache::Cache implementation
use Cache::Any::Adapter;
use Cache::Any;

my $file_cache = Cache::FileCache->new();
Cache::Any::Adapter->set({'namespace' => 'customer'},
	'Cache::Cache', 'cache' => $file_cache);

$cache = Cache::Any->get_cache('namespace' => 'customer');
$cache->set('name', 'john', 3600);

=head1 DESCRIPTION

This L<Cache::Any|Cache::Any> adapter uses the
L<Cache::Cache|Cache::Cache> interface for caching.

=head1 SEE ALSO

=over

=item L<Cache::Any|Cache::Any>

=item L<Cache::Any::Adapter|Cache::Any::Adapter>

=item L<Cache::Cache|Cache::Cache>

=cut

