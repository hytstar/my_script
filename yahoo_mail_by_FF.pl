#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use WWW::Mechanize::Firefox;
use Web::Scraper;
use Data::Dumper ('Dumper');
use Encode;

##########################################################
#                                                        #
# yahoo mail$B$K%m%0%$%s$7$F<+J,$N%"%+%&%s%HL>$rI=<($9$k(B   #
#                                                        #
##########################################################

#============================================
# $B@_Dj(B
#============================================
my $URL      = "mail.yahoo.co.jp/";
my $ACCOUNT  = 'your_accont';
my $PASSWORD = 'your_passowrd';


#============================================
# $B%5%$%H$K%"%/%;%9(B
#============================================
my $mech = new WWW::Mechanize::Firefox( autocheck => 1 );
$mech->get($URL);


#============================================
# $B%m%0%$%s=hM}(B
#============================================
$mech->submit_form(
    with_fields => {
#       login => $ACCOUNT,
        passwd => $PASSWORD,
    },
);
sleep(1);


=pod
#============================================
# $B<u?.H"$XA+0\(B
#============================================
my $l = $mech->xpath('//li[@id="Inbox"]/a', single => 1);
$mech->click($l);
=cut

#============================================
# $B%9%/%l%$%Q!<%$%s%9%?%s%9$N@8@.(B
#============================================
#--------------------------------#
# CSS$B7A<0$NNc!#0J2<$N>l9g!"(B      #
# $result->{header}->[0]->{name} #
# $B$N7A$G<hF@2DG=(B                 #
#--------------------------------#
my $header = scraper {
    process '#normalHeader div.yjmthloginarea', 'header[]' => scraper {
        process 'strong', name => "TEXT";
    }
};
my $mail = scraper {
    process '#uflist', 'mail_link[]' => scraper {
        process 'i', mail_num => "TEXT";
    }
};

#--------------------------------#
# XPath$B$NNc(B($B#3<oN`(B)              #
# $B0J2<$N>l9g!"(B                   #
# $result->{header}              #
# $B$G<hF@2DG=(B                     #
#--------------------------------#
=pod
my $scraper = scraper {
    process '//*[@id="normalHeader"]/div[2]/strong', 'header' => 'TEXT';
    #process '//*[@id="normalHeader"]//strong[1]', 'header' => 'TEXT';
    #process '//*[@id="normalHeader"]', 'header' => 'HTML';
};
=cut

#============================================
# $B%9%/%l%$%T%s%0$N<B9T$HI=<((B
#============================================
#$B%9%/%l%$%T%s%0(B
my $header_result = $header->scrape($mech->content);
my $mail_result = $mail->scrape($mech->content);

#$B@55,I=8=$G%a!<%k?t$@$1<h$j=P$7(B
my $num = $mail_result->{mail_link}->[0]->{mail_num};
$num =~ s/.*\((.*)\)/$1/;

#print
print "your name: ", $header_result->{header}->[0]->{name},"\n";
print "mail num: ", $num,"\n";

sleep(1000);
