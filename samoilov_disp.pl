#!/usr/bin/perl -w

# ���������.
# �������� ��������� �� �������� ������(�����, �����, ����� ������, ...)
# ��� ������ ����������� ������ ������...

use lib '.';
require 'io_cgi.pl';

eval 
{
# �������� ������� � ������� ���� ����������...
my $io_cgi = 'io_cgi'->new;
$io_cgi->get_params;


# �������� � �������� ������...
my $class = $io_cgi->param("class");

# �������� � �������� ������...
my $event = $io_cgi->param("event");

# �������� � �������� ����� ������...
my $group_number = $io_cgi->param("group_number");

# �������� � �������� ��� ������������...
my $user_name = $io_cgi->param("user_name");

# �������� � �������� ������� ������������...
my $user_surname = $io_cgi->param("user_surname");

# �������� � �������� ����� ��������� �������...
my $hometask_number = $io_cgi->param("hometask_number");

# �������� � �������� ������������ ������...
my $score = $io_cgi->param("score");


# ����������� ������ � ������� ����������...
eval "require $class";

# �������� ������� � ����� ������...
my $obj = $class->new;
$obj->$event($group_number, $user_name, $user_surname, $hometask_number, $score); 
};

if ($@) 
{
  my $error_text = $@;

  print ("Content-Type: text/html\n");
  print ("Charset: Windows-1251\n\n");

  print $error_text;
}
