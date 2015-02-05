#!/usr/bin/perl

use warnings;
use strict;
use Term::ANSIColor;

#===MAIN===============================================================================

do {

	showModules();
	my $choice = makeChoice();

	exit(0) if ( $choice == 0 );
	modModifyPlymouth if ( $choice == 1 );

} while( 1 == 1 );

#===SUBS===============================================================================

sub modModifyPlymouth{

	_sysCall({ 	command 	=> "sudo plymouth-set-default-theme details --rebuild-initrd",
				delay 		=> 3,
				exitFail 	=> 1 	});

	_sysCall({ 	command 	=> "sudo dracut -f",
				delay 		=> 3,
				exitFail 	=> 1 	});

}

sub makeChoice {

	_printGreen( "RUN:/> " );
	my $choice = <STDIN>;
	chomp( $choice );
	return $choice;

}

sub showModules{

	_printGreen( "\nAVAILABLE MODULES :\n\n" );
	_printGreen( "1\tModify plymouth\n" );
	_printGreen( "0\tExit\n" );
	_printGreen( "\n" );

}

sub _printGreen{
	my $string = shift;
	my $wait = shift || 0;
	print color 'bold green';
	print $string;
	print color 'reset';
	sleep($wait);
	return 1;
}

sub _printRed{
	my $string = shift;
	my $wait = shift || 0;
	print color 'bold red';
	print $string;
	print color 'reset';
	sleep($wait);
	return 1;
}

sub _dieRed{
	my $string = shift;
	my $wait = shift || 0;
	print color 'bold red';
	print $string;
	print color 'reset';
	sleep($wait);
	exit(0);
}

sub _sysCall{

	my ($args) = @_;

	if ( $args->{title} ) {

		_printGreen( $args->{title} . "\n", 1 );
		
	}

	if ( $args->{delay} && $args->{delay} > 0 ) {
		print color 'bold green';
		print "About to execute:\n";
		print color 'bold yellow';
		print "\t" . $args->{command} . "\n";
		print color 'reset';
		sleep ( $args->{delay} );
	}

	my $outcome = system($args->{command});

	if ( $outcome == 0 ) {
		return 1;
	}

	if ( $outcome != 0 ) {
		print color 'bold red';
		if ( $args->{errorMsg} ) {
			print $args->{errorMsg} . "\n";
		} else {
			print "Oops! Something went wrong...\n";
		}
		print "\tError Code: $outcome\n";
		print "\tError string: $?\n";
		print color 'reset';

		if ( $args->{exitFail} && $args->{exitFail} == 1 ) {
			print color 'bold red';
			print "Aborting...\n";
			print color 'reset';
			exit(0);
		} else {
			return 0;
		}
	}
}
