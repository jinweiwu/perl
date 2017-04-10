
#! user/bin/perl -w
use strict;

open (IN, $ARGV[0])||die;
my @tr;

my $flag = 0;
open (OUT, ">unigene.fas")||die;
my %hash;
my $title = '';

while (my $line = <IN>){
chomp $line;
        if ($line =~ /^>/){
                $title = $line;
                my ($a, $b) = split /\s+/, $line;
                #$a =~ s/^>//;
                $title = $a;
                my ($c, $d) = split /\|/, $title;
                $c =~ s/^>//;
                push @tr, $c;
                $flag = 1;
        }
        elsif ($flag == 1 && $line !~ /^>/){
                $hash{$title} = $hash{$title}. $line;
        }
        elsif ($flag == 1 && $line =~ /^>/){
                $flag = 0;
        }
}
close IN;
print "The seq file has been read over!\n";

my @keys = keys %hash;
my %count;
@tr = grep { ++$count{$_} < 2 } @tr;
my $state = 0;
foreach my $tr (@tr){
$state++;
print "$state\n";
        my $contig = '';
        my $length = 0;
        my $seq = '';
        foreach my $key (@keys){

                if ($key =~ /^>$tr\|/){
                        my $temp_seq = $hash {$key};
                        my $temp_length = length $temp_seq;
                                if ($temp_length > $length){
                                        $length = $temp_length;
                                        $seq = $temp_seq;
                                        $contig = $key;
                                }
                }
        }
print OUT $contig, "\n", $seq, "\n";
}
close OUT;
