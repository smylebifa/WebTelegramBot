#!/usr/bin/perl -w

# Работа по API с Telegram

package WebProgTelegramClient;
use Cpanel::JSON::XS;
use IO::Socket::SSL;
use LWP::UserAgent;
use strict;
use Encode;


=DESCRIPTION

  API
  https://core.telegram.org/bots/api

  Создание бота
  https://habr.com/ru/post/262247/

  Чтобы бот мог читать чат, нужно настроить ему Privacy Mode
  для этого в @BotFather выдаем команду
    /setprivacy

    вводим название бота
    @WebProg1Bot

    выбираем статус
    Disable

=cut


=head2 new(token => XXX)

  my $token = 'XXXX';
  my $tg = WebProgTelegramClient->new(token => $token);

=cut
sub new
{
  my $this = shift;
  my %params = @_;
  my $self = {};
  bless($self, $this);

  $self->{_token} = $params{token};
  $self->{_request_url} = 'https://api.telegram.org/bot'.$self->{_token};

  return $self;
}


#read_chat(chat_id => XXX, chat_title => XXX)
sub read_chat
{
  my $this = shift;
  my %params = @_;

  my $chat_id = $params{chat_id};
  my $chat_title = $params{chat_title};

  my $updates = $this->call('getUpdates', {});

  my $chat_messages = [];
  foreach my $row (@{$updates->{result}})
  {
    my $chat = $row->{message}->{chat};  
    if( ( $chat_id eq $chat->{id} ) || ( $chat_title eq $chat->{title} ) )
    {
      push(@$chat_messages, $row);
    }    
  }

  return $chat_messages;
}


=head2 call( $method, $params)

  my $tg = WebProgTelegramClient->new(token => $token);
  my $result = $tg->call('getMe', {});

=cut
sub call
{
  my ( $this, $method, $params ) = @_;

  my $method_type = 'POST';

  my $result = $this->_json_request(method => $method, method_type => $method_type, data => $params);
  return $result;
}


=head2 _json_request(method => 'call', method_type => 'POST', data => {})

Отправляет запрос в JSON на переданный в параметре method url (дополняет его из request_url)

=cut
sub _json_request
{
  my $this = shift;
  my %params = @_;

  unless ($this->{_request_url})
  {
    die 'Задайте пример URL';
    return;
  }

  my $method = $params{method} || die 'No method pass';
  my $method_type = $params{method_type} || 'POST';
  my $data = $params{data} || undef;

  my $url = $this->{_request_url} . '/'.$method;

  my $uri = URI->new( $url );
  my $request = HTTP::Request->new( $method_type => $uri->as_string );
  $request->header( 'Content-Type' => 'application/json' );

  $request->content( Cpanel::JSON::XS->new->utf8->encode($data) );

  my $user_agent = LWP::UserAgent->new(
    ssl_opts => {
      verify_hostname => 0,
      SSL_verify_mode => IO::Socket::SSL::SSL_VERIFY_NONE
    },
  );

  my $response = $user_agent->request($request);

  my $result = $this->_parse_response($response);

  return $result;
}


sub _parse_response
{
  my ( $this, $response ) = @_;

  my $result;
  if ( $response->is_success )
  {
    eval { $result = Cpanel::JSON::XS->new->utf8->decode( $response->content ) };
    
    my $error = $@;
    if ($error)
    {
      # 204 код приходит, когда ничего не найдено. Возвращаем пустой хеш...
      if($response->{_rc} == 204)
      {
        $result = {};
      }
      else
      {
        $result->{error} = $error;
      }
    }
  }
  else
  {
    $result = Cpanel::JSON::XS->new->utf8->decode( $response->content );
    unless($result->{error})
    {
      $result->{error} = $result->{error_description};
    }
  }

  return $result;
}

1;
