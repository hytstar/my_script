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
# yahoo mailにログインして自分のアカウント名を表示する   #
#                                                        #
##########################################################

#============================================
# 設定
#============================================
my $URL      = "mail.yahoo.co.jp/";
my $ACCOUNT  = 'your_accont';
my $PASSWORD = 'your_passowrd';


#============================================
# サイトにアクセス
#============================================
my $mech = new WWW::Mechanize::Firefox( autocheck => 1 );
$mech->get($URL);


#============================================
# ログイン処理
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
# 受信箱へ遷移
#============================================
my $l = $mech->xpath('//li[@id="Inbox"]/a', single => 1);
$mech->click($l);
=cut

#============================================
# スクレイパーインスタンスの生成
#============================================
#--------------------------------#
# CSS形式の例。以下の場合、      #
# $result->{header}->[0]->{name} #
# の形で取得可能                 #
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
# XPathの例(３種類)              #
# 以下の場合、                   #
# $result->{header}              #
# で取得可能                     #
#--------------------------------#
=pod
my $scraper = scraper {
    process '//*[@id="normalHeader"]/div[2]/strong', 'header' => 'TEXT';
    #process '//*[@id="normalHeader"]//strong[1]', 'header' => 'TEXT';
    #process '//*[@id="normalHeader"]', 'header' => 'HTML';
};
=cut

#============================================
# スクレイピングの実行と表示
#============================================
#スクレイピング
my $header_result = $header->scrape($mech->content);
my $mail_result = $mail->scrape($mech->content);

#正規表現でメール数だけ取り出し
my $num = $mail_result->{mail_link}->[0]->{mail_num};
$num =~ s/.*\((.*)\)/$1/;

#print
print "your name: ", $header_result->{header}->[0]->{name},"\n";
print "mail num: ", $num,"\n";

sleep(1000);
