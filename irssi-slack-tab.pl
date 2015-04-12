use strict;
use warnings;

our $VERSION = '0.1';
our %IRSSI = (
    authors     => 'Nei and dc',
    contact     => 'Nei @ anti@conference.jabber.teamidiot.de, dc @ dc@pulsetrain.net',
    url         => "http://anti.teamidiot.de/ and http://pulsetrain.net",
    name        => 'complete_at',
    description => 'Complete nicks after @ (twitter-style)',
    license     => 'ISC',
   );

# Usage
# =====
# write @ and type on the Tab key to complete nicks

{ package Irssi::Nick }

my $complete_char = '@';
my $finish = ':';

sub complete_at {
    my ($cl, $win, $word, $start, $ws) = @_;
    if ($cl && !@$cl
	    && $win && $win->{active}
	    && $win->{active}->isa('Irssi::Channel')) {
	if ((my $pos = rindex $word, $complete_char) > -1) {
	    my ($pre, $post) = ((substr $word, 0, $pos), (substr $word, $pos + 1));
	    Irssi::signal_emit('complete word', $cl, $win, $post, "$start $pre$complete_char", $ws);
	    unless (@$cl) {
		push @$cl, grep { /^\Q$post/i } map { $_->{nick} } $win->{active}->nicks();
	    }
	    map { $_ = "$pre$complete_char$_$finish" } @$cl;
	}
    }
}

Irssi::signal_add_last('complete word' => 'complete_at');
