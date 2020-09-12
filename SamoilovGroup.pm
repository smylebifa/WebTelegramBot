#!/usr/bin/perl -w

# Класс для работы с группами...
package SamoilovGroup;

use strict;
use HTML::Template;
require SamoilovDataBaseConnector; 


sub new 
{
  # Создание объекта для запросов... 
  my $this = shift;  
  
  my $db = SamoilovDataBaseConnector->new;
  my $self = {db => $db,};

  return bless $self, $this;
} 


sub show_list
{
  my $self = shift; 

  # Список групп...   
  my $hash_ref = $self->{db}->get_groups; 

  # Открытие html шаблона...
  my $template = HTML::Template->new(filename => 'samoilov_group_list.tmpl');
 
  # Передаем ссылку массива хэшей в шаблон параметр...
  $template->param(groups => $hash_ref);
 
  # Выводим группы...
  print ("Content-Type: text/html\n");
  print ("Charset: Windows-1251\n\n");

  print $template->output;
}

sub show_group_content
{
  my $self = shift; 

  # Список групп...   
  my $hash_ref = $self->{db}->get_groups; 

  # Открытие html шаблона...
  my $template = HTML::Template->new(filename => 'samoilov_group_content.tmpl');
 
  # Передаем ссылку массива хэшей в шаблон параметр...
  $template->param(groups => $hash_ref);
 
  # Выводим группы...
  print ("Content-Type: text/html\n");
  print ("Charset: Windows-1251\n\n");

  print $template->output;
}

sub help
{
  my $self = shift; 

  # Открытие html шаблона...
  my $template = HTML::Template->new(filename => 'samoilov_help.tmpl');
  
  # Выводим группы...
  print ("Content-Type: text/html\n");
  print ("Charset: Windows-1251\n\n");

  print $template->output;
}


sub add_group
{
  my $self = shift;

  my $group_number = shift; 

  print ("Content-Type: text/html\n");
  print ("Charset: Windows-1251\n\n");

  # Добавление группы...   
  if ($group_number > 0) 
  {
    $self->{db}->add_group($group_number); 
    print("Группа добавлена");

  }
  else 
  {
    print ("Группа введена не верно");
  }
}

sub chat
{
  my $self = shift;

  my $group_number = shift; 

  # Отправка новых сообщений на сервер...
  # $self->{db}->post_messages_to_server($group_number);

  # Сообщения группы...
  my $messages = $self->{db}->get_messages_from_server($group_number);

  # Количество сообщений в группе...
  my $counts_of_messages = scalar(@$messages); 

  # Открытие html шаблона...
  my $template = HTML::Template->new(filename => 'samoilov_message_list.tmpl');
 
  # Передаем ссылку массива хэшей в шаблон параметр...
  $template->param(messages => $messages);
 
  # Вывод сообщений...
  print ("Content-Type: text/html\n");
  print ("Charset: Windows-1251\n\n");
  
  print $template->output;
}


sub delete_group
{
  my $self = shift;
  
  my $group_number = shift;

  # Удаление группы...   
  $self->{db}->delete_group($group_number);

  # Список групп...   
  my $hash_ref = $self->{db}->get_groups; 

  # Открытие html шаблона...
  my $template = HTML::Template->new(filename => 'samoilov_group_list.tmpl');
 
  # Передаем ссылку массива хэшей в шаблон параметр...
  $template->param(groups => $hash_ref);
 
  # Выводим группы...
  print ("Content-Type: text/html\n");
  print ("Charset: Windows-1251\n\n");

  print $template->output;
}


sub hometasks
{
  my $self = shift;
  
  my $group_number = shift; 

  # Получение домашних заданий...
  my $hash_ref = $self->{db}->get_hometasks($group_number);

  # Открытие html шаблона...
  my $template = HTML::Template->new(filename => 'samoilov_hometask_list.tmpl');
 
  # Передаем ссылку массива хэшей в шаблон параметр...
  $template->param(hometasks => $hash_ref);

  print ("Content-Type: text/html\n");
  print ("Charset: Windows-1251\n\n");

  print $template->output;
}


sub results
{
  my $self = shift;
  
  my $group_number = shift; 

  # Получение результатов...   
  my $hash_ref = $self->{db}->get_general_score($group_number);

  # Открытие html шаблона...
  my $template = HTML::Template->new(filename => 'samoilov_result_list.tmpl');
 
  # Передаем ссылку массива хэшей в шаблон параметр...
  $template->param(results => $hash_ref);

  print ("Content-Type: text/html\n");
  print ("Charset: Windows-1251\n\n");
 
  print $template->output;
}


sub users
{
  my $self = shift;
  
  my $group_number = shift; 

  # Получение участников группы...
  my $hash_ref = $self->{db}->get_users($group_number);

  # Открытие html шаблона...
  my $template = HTML::Template->new(filename => 'samoilov_user_list.tmpl');
 
  # Передаем ссылку массива хэшей в шаблон параметр...
  $template->param(users => $hash_ref);

  print ("Content-Type: text/html\n");
  print ("Charset: Windows-1251\n\n");
 
  print $template->output;
}


sub change_score
{
  my $self = shift;
  
  my $group_number = shift; 
  
  my $user_name = shift;

  my $user_surname = shift;

  my $hometask_number = shift; 

  my $score = shift; 


  # Открытие формы для изменения оценки пользователя из текущей группы...
  unless($user_name)
  {
    # Открытие html шаблона...
    my $template = HTML::Template->new(filename => 'samoilov_change_score.tmpl');

    # Передаем ссылку массива хэшей в шаблон параметр...
    $template->param(group_number => $group_number);

    print ("Content-Type: text/html\n");
    print ("Charset: Windows-1251\n\n");

    print $template->output; 
  }

  # Изменение оценки пользователя и вывод домашних заданий для заданной группы...
  else
  {
    # Изменение оценки...   
    $self->{db}->change_score($group_number, $user_name, $user_surname, $hometask_number, $score); 

    # Получение домашних заданий...   
    my $hash_ref = $self->{db}->get_hometasks($group_number);

    # Открытие html шаблона...
    my $template = HTML::Template->new(filename => 'samoilov_hometask_list.tmpl');
 
    # Передаем ссылку массива хэшей в шаблон параметр...
    $template->param(hometasks => $hash_ref);

    print ("Content-Type: text/html\n");
    print ("Charset: Windows-1251\n\n");

    print $template->output; 
  }
}

1;
