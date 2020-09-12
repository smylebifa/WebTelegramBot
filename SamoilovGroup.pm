#!/usr/bin/perl -w

# ����� ��� ������ � ��������...
package SamoilovGroup;

use strict;
use HTML::Template;
require SamoilovDataBaseConnector; 


sub new 
{
  # �������� ������� ��� ��������... 
  my $this = shift;  
  
  my $db = SamoilovDataBaseConnector->new;
  my $self = {db => $db,};

  return bless $self, $this;
} 


sub show_list
{
  my $self = shift; 

  # ������ �����...   
  my $hash_ref = $self->{db}->get_groups; 

  # �������� html �������...
  my $template = HTML::Template->new(filename => 'samoilov_group_list.tmpl');
 
  # �������� ������ ������� ����� � ������ ��������...
  $template->param(groups => $hash_ref);
 
  # ������� ������...
  print ("Content-Type: text/html\n");
  print ("Charset: Windows-1251\n\n");

  print $template->output;
}

sub show_group_content
{
  my $self = shift; 

  # ������ �����...   
  my $hash_ref = $self->{db}->get_groups; 

  # �������� html �������...
  my $template = HTML::Template->new(filename => 'samoilov_group_content.tmpl');
 
  # �������� ������ ������� ����� � ������ ��������...
  $template->param(groups => $hash_ref);
 
  # ������� ������...
  print ("Content-Type: text/html\n");
  print ("Charset: Windows-1251\n\n");

  print $template->output;
}

sub help
{
  my $self = shift; 

  # �������� html �������...
  my $template = HTML::Template->new(filename => 'samoilov_help.tmpl');
  
  # ������� ������...
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

  # ���������� ������...   
  if ($group_number > 0) 
  {
    $self->{db}->add_group($group_number); 
    print("������ ���������");

  }
  else 
  {
    print ("������ ������� �� �����");
  }
}

sub chat
{
  my $self = shift;

  my $group_number = shift; 

  # �������� ����� ��������� �� ������...
  # $self->{db}->post_messages_to_server($group_number);

  # ��������� ������...
  my $messages = $self->{db}->get_messages_from_server($group_number);

  # ���������� ��������� � ������...
  my $counts_of_messages = scalar(@$messages); 

  # �������� html �������...
  my $template = HTML::Template->new(filename => 'samoilov_message_list.tmpl');
 
  # �������� ������ ������� ����� � ������ ��������...
  $template->param(messages => $messages);
 
  # ����� ���������...
  print ("Content-Type: text/html\n");
  print ("Charset: Windows-1251\n\n");
  
  print $template->output;
}


sub delete_group
{
  my $self = shift;
  
  my $group_number = shift;

  # �������� ������...   
  $self->{db}->delete_group($group_number);

  # ������ �����...   
  my $hash_ref = $self->{db}->get_groups; 

  # �������� html �������...
  my $template = HTML::Template->new(filename => 'samoilov_group_list.tmpl');
 
  # �������� ������ ������� ����� � ������ ��������...
  $template->param(groups => $hash_ref);
 
  # ������� ������...
  print ("Content-Type: text/html\n");
  print ("Charset: Windows-1251\n\n");

  print $template->output;
}


sub hometasks
{
  my $self = shift;
  
  my $group_number = shift; 

  # ��������� �������� �������...
  my $hash_ref = $self->{db}->get_hometasks($group_number);

  # �������� html �������...
  my $template = HTML::Template->new(filename => 'samoilov_hometask_list.tmpl');
 
  # �������� ������ ������� ����� � ������ ��������...
  $template->param(hometasks => $hash_ref);

  print ("Content-Type: text/html\n");
  print ("Charset: Windows-1251\n\n");

  print $template->output;
}


sub results
{
  my $self = shift;
  
  my $group_number = shift; 

  # ��������� �����������...   
  my $hash_ref = $self->{db}->get_general_score($group_number);

  # �������� html �������...
  my $template = HTML::Template->new(filename => 'samoilov_result_list.tmpl');
 
  # �������� ������ ������� ����� � ������ ��������...
  $template->param(results => $hash_ref);

  print ("Content-Type: text/html\n");
  print ("Charset: Windows-1251\n\n");
 
  print $template->output;
}


sub users
{
  my $self = shift;
  
  my $group_number = shift; 

  # ��������� ���������� ������...
  my $hash_ref = $self->{db}->get_users($group_number);

  # �������� html �������...
  my $template = HTML::Template->new(filename => 'samoilov_user_list.tmpl');
 
  # �������� ������ ������� ����� � ������ ��������...
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


  # �������� ����� ��� ��������� ������ ������������ �� ������� ������...
  unless($user_name)
  {
    # �������� html �������...
    my $template = HTML::Template->new(filename => 'samoilov_change_score.tmpl');

    # �������� ������ ������� ����� � ������ ��������...
    $template->param(group_number => $group_number);

    print ("Content-Type: text/html\n");
    print ("Charset: Windows-1251\n\n");

    print $template->output; 
  }

  # ��������� ������ ������������ � ����� �������� ������� ��� �������� ������...
  else
  {
    # ��������� ������...   
    $self->{db}->change_score($group_number, $user_name, $user_surname, $hometask_number, $score); 

    # ��������� �������� �������...   
    my $hash_ref = $self->{db}->get_hometasks($group_number);

    # �������� html �������...
    my $template = HTML::Template->new(filename => 'samoilov_hometask_list.tmpl');
 
    # �������� ������ ������� ����� � ������ ��������...
    $template->param(hometasks => $hash_ref);

    print ("Content-Type: text/html\n");
    print ("Charset: Windows-1251\n\n");

    print $template->output; 
  }
}

1;
