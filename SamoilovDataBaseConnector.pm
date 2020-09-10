#!/usr/bin/perl -w

package SamoilovDataBaseConnector;
require WebProgTelegramClient;
use Encode qw(decode);
use strict;
use DBI;

# Database interface for Perl - https://metacpan.org/pod/DBI

# Список телеграмм групп...
our %chats = (1 => { chat_id      => '-1001384432879', 
                     chat_title   =>  'TstGroup'});

# Токен телеграм бота...
our $token = '1396157334:AAHjwGsAMJcNck5UwmI1-YXZzSqOHTGY8VI';

use constant
{
  DATA_SOURCE =>  "DBI:mysql:webprog1x5_tgbot:localhost",
  USERNAME    =>  "webprog1x5_tgbot",
  PASSWORD    =>  "9GEg52an6bd754hh",
  GROUP_ID    =>  "webprog1x5_tgbot_group_id",
  USER_ID     =>  "webprog1x5_tgbot_user_id",
  GROUP       =>  "webprog1x5_tgbot_group",
  MESSAGES    =>  "webprog1x5_tgbot_messages",
};


our $singleton;

# Конструктор.
# Создаем объект базы данных...
sub new
{
  my $this = shift;
  return $singleton if defined $singleton;
 
  # Получение доступа к серверу базы данных...
  my $attr = {PrintError => 0, RaiseError => 0};
  my $data_source = DATA_SOURCE;
  my $username = USERNAME;
  my $password = PASSWORD;
  my $dbh = DBI->connect($data_source, $username, $password, $attr);
  if (!$dbh) { die $DBI::errstr; }
  $dbh->do('SET NAMES cp1251');

  my $self = {dbh => $dbh,};

  $singleton = bless($self, $this);
  return $singleton;
}


# Добавление группы...
sub add_group
{
  my $self = shift;

  my $group_number = shift; 

  my $group = $self->{dbh}->prepare(
    "INSERT INTO " . GROUP_ID . " (group_number) VALUES (?)");

  $group->execute($group_number);
}


# Удаление группы...
sub delete_group
{
  my $self = shift;

  my $group_number = shift; 

  my $group = $self->{dbh}->prepare(
    "DELETE FROM " . GROUP_ID . " 
     WHERE group_number = ?
     ORDER BY group_number");

  $group->execute($group_number);
}


# Получение групп...
sub get_groups
{
  my $self = shift;

  my $groups = $self->{dbh}->prepare(
    "SELECT group_number FROM " . GROUP_ID . " 
     ORDER BY group_number");

  $groups->execute();


  # Массив хэшей...
  my @array_of_hash;

  # Ссылка на массив хэшей...
  my $array_of_hash_ref;

  # Переменная для получения строки таблицы в виде хэша... 
  my $hash_ref;


  while ( $hash_ref = $groups->fetchrow_hashref )
  {
    push(@array_of_hash, $hash_ref);
  }

  # Получение ссылки на массив хэшей...
  $array_of_hash_ref = \@array_of_hash;

  return $array_of_hash_ref;
}


# Получение пользователей...
sub get_users
{
  my $self = shift;

  my $group_number = shift; 

  my $users = $self->{dbh}->prepare(
    "SELECT id, name, surname FROM " . USER_ID . "
     WHERE group_number=? 
     ORDER BY group_number");
  
  $users->execute($group_number);
 

  # Массив хэшей...
  my @array_of_hash;

  # Ссылка на массив хэшей...
  my $array_of_hash_ref;

  # Переменная для получения строки таблицы в виде хэша... 
  my $hash_ref;


  while ( $hash_ref = $users->fetchrow_hashref )
  {
    push(@array_of_hash, $hash_ref);
  }

  # Получение ссылки на массив хэшей...
  $array_of_hash_ref = \@array_of_hash;

  return $array_of_hash_ref;
}

# Получение пользователя по имени, фамилии и группе...
sub get_user_id
{
  my $self = shift;

  my $name = shift;

  my $surname = shift;

  my $group_number = shift;

  my $user_id = $self->{dbh}->prepare(
    "SELECT id FROM " . USER_ID . "
     WHERE " . USER_ID . ".name = ? 
     AND " . USER_ID . ".surname = ? 
     AND " . USER_ID . ".group_number = ?");

  $user_id->execute($name, $surname, $group_number);
  
  my $hash_ref = $user_id->fetchrow_hashref; 

  return $hash_ref;
}


# Получение домашних заданий группы...
sub get_hometasks
{
  my $self = shift;

  my $group_number = shift; 

  my $hometasks = $self->{dbh}->prepare(
    "SELECT hometask_number, user_id, name, surname, deadline, score 
     FROM " . GROUP . "      
     JOIN " . USER_ID . "
     ON " . GROUP . ".user_id = " . USER_ID . ".id
     WHERE " . GROUP . ".group_number = ?");

  $hometasks->execute($group_number);


  # Массив хэшей...
  my @array_of_hash;

  # Ссылка на массив хэшей...
  my $array_of_hash_ref;

  # Переменная для получения строки таблицы в виде хэша... 
  my $hash_ref;


  while ( $hash_ref = $hometasks->fetchrow_hashref )
  {
    push(@array_of_hash, $hash_ref);
  }

  # Получение ссылки на массив хэшей...
  $array_of_hash_ref = \@array_of_hash;

  return $array_of_hash_ref;
}


# Просмотр общих баллов участников группы...
sub get_general_score
{
  my $self = shift;

  my $group_number = shift; 

  my $general_score = $self->{dbh}->prepare(     
    "SELECT " . GROUP . ".user_id, " . USER_ID . ".name,
     " . USER_ID . ".surname, SUM(" . GROUP . ".score) as general_score
     FROM " . GROUP . "
     JOIN " . USER_ID . "
     ON " . GROUP . ".user_id = " . USER_ID . ".id
     WHERE " . GROUP . ".group_number = ?
     GROUP BY " . GROUP . ".user_id
     ORDER BY " . GROUP . ".group_number");

  $general_score->execute($group_number);


 # Массив хэшей...
  my @array_of_hash;

  # Ссылка на массив хэшей...
  my $array_of_hash_ref;

  # Переменная для получения строки таблицы в виде хэша... 
  my $hash_ref;


  while ( $hash_ref = $general_score->fetchrow_hashref )
  {
    push(@array_of_hash, $hash_ref);
  }

  # Получение ссылки на массив хэшей...
  $array_of_hash_ref = \@array_of_hash;

  return $array_of_hash_ref;
}


# Изменение оценки.
# Параметры функции group_number, user_id, hometask_number, score.
# Тело функции - Изменяем оценку в таблице groups...
sub change_score
{
  my $self = shift;

  my $group_number = shift; 

  my $user_name = shift;

  my $user_surname = shift;

  my $hometask_number = shift; 
  
  my $score= shift;
  

  my $user_id = $self->get_user_id($user_name, $user_surname, $group_number); 

  
  # Изменяем оценку пользователя по домашнему заданию...
  my $update = $self->{dbh}->prepare(
    "UPDATE " . GROUP . "
     SET score = ?
     WHERE " . GROUP . ".group_number = ?
     AND " . GROUP . ".user_id = ?
     AND " . GROUP . ".hometask_number = ?");

  $update->execute($score, $group_number, $user_id->{id}, $hometask_number);
}


# Получение сообщений с сервера...
sub get_messages_from_server
{
  my $self = shift;

  my $group_number = shift; 


  my $messages = $self->{dbh}->prepare(
    "SELECT " . USER_ID . ".name, " . USER_ID. ".surname,
     " . MESSAGES . ".message
     FROM " . MESSAGES . " 
     JOIN " . USER_ID . "
     ON " . MESSAGES . ".user_id = " . USER_ID . ".id
     WHERE " . MESSAGES . ".group_number = ?");

  $messages->execute($group_number);


  # Массив хэшей...
  my @array_of_hash;

  # Переменная для получения строки таблицы в виде хэша... 
  my $hash_ref;


  while ( $hash_ref = $messages->fetchrow_hashref)
  {
    push(@array_of_hash, $hash_ref);
  }

  return \@array_of_hash;
}


# Отправка сообщений на сервер.
sub post_messages_to_server
{
  my $self = shift;

  my $group_number = shift;


  # Получение объекта по Api...
  my $tg = WebProgTelegramClient->new(token => $token);

  my $chat_id = $chats{$group_number}{'chat_id'}; 

  my $chat_title = $chats{$group_number}{'chat_title'}; 

  # Переменная chat для считывания информации из группы...
  # Функция принимает на вход 2 параметра - номер группы и ее название...
  my $chat = $tg->read_chat(chat_id => $chat_id, chat_title => $chat_title);

  # Количество сообщений в группе...
  my $counts_of_messages = scalar(@$chat); 

  # Массив сообщений в виде хешей(пользователь, сообщение)...
  my @array_of_messages;

  my $user_name;

  my $user_surname;

  my $message_text;

  my $user_id;

  # Считывание сообщений из телеграмма... 
  foreach my $i (0..$counts_of_messages-1) 
  {
    # Если сообщение о новом пользователе или о выходе пользователя из группы,
    # переходим к новой итерации цикла...
    next if ( $chat->[$i]->{message}->{new_chat_member} or 
              $chat->[$i]->{message}->{left_chat_member} );

    # Иначе выводим сообщения пользователей...
    $user_name = $chat->[$i]->{message}->{from}->{first_name};
    $user_surname =  $chat->[$i]->{message}->{from}->{last_name};
    $message_text = $chat->[$i]->{message}->{text};

    $user_id = $self->get_user_id($user_name, $user_surname, $group_number);

    my %hash_messages = (user_id  => $user_id->{id}, 
                         message_text => $message_text);

    push(@array_of_messages, \%hash_messages);
  }

  my $messages = \@array_of_messages;

  my $message;

  # Отправка полученных из телеграмма сообщений на сервер...
  foreach my $i (0..$counts_of_messages-1) 
  {
    $message = $self->{dbh}->prepare(
    "INSERT INTO " . MESSAGES . " 
     (group_number, user_id, message)
     VALUES (?, ?, ?)");

    $message->execute($group_number, $messages->[$i]->{user_id}, 
                      $messages->[$i]->{message_text});
  }
}

1;
