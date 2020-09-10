#!/usr/bin/perl -w

# Диспетчер.
# Получает параметры из адресной строки(класс, метод, номер группы, ...)
# для вызова полученного метода класса...

use lib '.';
require 'io_cgi.pl';

eval 
{
# Создание объекта и парсинг всех параметров...
my $io_cgi = 'io_cgi'->new;
$io_cgi->get_params;


# Передача в параметр класса...
my $class = $io_cgi->param("class");

# Передача в параметр метода...
my $event = $io_cgi->param("event");

# Передача в параметр номер группы...
my $group_number = $io_cgi->param("group_number");

# Передача в параметр имя пользователя...
my $user_name = $io_cgi->param("user_name");

# Передача в параметр фамилии пользователя...
my $user_surname = $io_cgi->param("user_surname");

# Передача в параметр номер домашнего задания...
my $hometask_number = $io_cgi->param("hometask_number");

# Передача в параметр исправленной оценки...
my $score = $io_cgi->param("score");


# Подключение класса с помощью исключения...
eval "require $class";

# Создание объекта и вызов метода...
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
