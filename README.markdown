# PAGSEGURO Client [![Build Status](https://travis-ci.org/matheustardivo/pagseguro_client.png?branch=master)](https://travis-ci.org/matheustardivo/pagseguro_client) [![Code Climate](https://codeclimate.com/github/matheustardivo/pagseguro_client.png)](https://codeclimate.com/github/matheustardivo/pagseguro_client) [![Coverage Status](https://coveralls.io/repos/matheustardivo/pagseguro_client/badge.png)](https://coveralls.io/r/matheustardivo/pagseguro_client)

Este é um plugin do Ruby on Rails que permite utilizar o [PagSeguro](https://pagseguro.uol.com.br), gateway de pagamentos do [UOL](http://uol.com.br).

## Changelog
* Adicionado gerador para instalação da biblioteca em projetos Rails
* Adicionada opção para URL de retorno dinâmica
* Implementação parcial da [API de pagamentos](https://pagseguro.uol.com.br/v2/guia-de-integracao/api-de-pagamentos.html)
* Implementação parcial da [API de notificações](https://pagseguro.uol.com.br/v2/guia-de-integracao/notificacoes.html)
* Implementação parcial da [API de
  transações](https://pagseguro.uol.com.br/v2/guia-de-integracao/consulta-de-transacoes-por-codigo.html)

## Como usar

### Instalação

Adicione a biblioteca ao arquivo Gemfile:

```ruby
gem 'pagseguro_client'
```

Depois de realizar a instalação da biblioteca, você precisará gerar o arquivo de configuração, que deve residir em config/pagseguro.yml. Para gerar o arquivo a partir de um modelo execute

      rails generate pagseguro_client:install

O arquivo de configuração gerado será parecido com isso:

```yaml
development: &development
  ws_url: "http://localhost:4000"
  ps_url: "http://localhost:4000"
  return_to: "http://localhost:4000/successo"
  email: matheustardivo@gmail.com
  token: "tokenGeradoPeloPagseguro"

test:
  <<: *development

production:
  ws_url: "https://ws.pagseguro.uol.com.br"
  ps_url: "https://pagseguro.uol.com.br"
  return_to: "http://www.sualoja.com.br/successo"
  email: matheustardivo@gmail.com
  token: "tokenGeradoPeloPagseguro"
```

Para realizar os testes de integração da sua aplicação com o gateway, você pode usar um servidor de testes desenvolvido pelo próprio Pagseguro: [Pagseguro Server](https://github.com/carlosdelfino/PagSeguro-TestServer)

### Gerando a sua ordem de pagamento

```ruby
@order = PagseguroClient::Order.new(id) # Seu identificador da ordem de pagamento
@order.add(
  id: "1", # Seu identificador do produto
  description: produto.descricao,
  amount: produto.preco)
@response = order.send_request
```

### Exemplo de resposta da ordem de pagamento

```ruby
# Hash
{
  code: "8CF4BE7DCECEF0F004A6DFA0A8243412",
  url: "https://ws.pagseguro.uol.com.br/v2/checkout/payment.html?code=8CF4BE7DCECEF0F004A6DFA0A8243412"
}
```

Agora basta usar a url retornada para enviar o usuário para efetuar o pagamento no site do Pagseguro.

### Configurando opção para URL de retorno dinâmica

Para configurar uma URL de retorno dinâmica a sua aplicação Rails, basta adicionar ao arquivo pagseguro.yml a opção return_to com o endereço para retorno que você configurou na sua aplicação:

```yaml
production:
  ws_url: "https://ws.pagseguro.uol.com.br"
  ps_url: "https://pagseguro.uol.com.br"
  return_to: "http://www.sualoja.com.br/sucesso"
  email: matheustardivo@gmail.com
  token: "tokenGeradoPeloPagseguro"
```

### Obtendo as notificações

```ruby
# No seu controller
def notificacao
  return unless request.post?

  @notification = PagseguroClient::Notification.retrieve(params[:notificationCode])
  # Seu código para utilizar a notificação

  render nothing: true
end
```

O objeto `notification` possui os seguintes métodos:

* `PagseguroClient::Notification#code`: Código da notificação
* `PagseguroClient::Notification#order_id`: Código da sua ordem de pagamento
* `PagseguroClient::Notification#status`: Status da ordem de pagamento atual
* `PagseguroClient::Notification#payment_method`: Método utilizado para o pagamento
* `PagseguroClient::Notification#client`: Dados do comprador
* `PagseguroClient::Notification#address`: Endereço do comprador

### Consultando Transações

```ruby
# No seu controller
def complete

  @transaction = PagseguroClient::Transaction.retrieve(params[:transaction_id_])
  # Seu código para utilizar a transaction
end
```

O objeto `transaction` possui os seguintes métodos:

* `PagseguroClient::Transaction#code`: Código da notificação
* `PagseguroClient::Transaction#order_id`: Código da sua ordem de pagamento
* `PagseguroClient::Transaction#status`: Status da ordem de pagamento atual
* `PagseguroClient::Transaction#payment_method`: Método utilizado para o pagamento
* `PagseguroClient::Transaction#client`: Dados do comprador
* `PagseguroClient::Transaction#address`: Endereço do comprador

#### Métodos de pagamento

* `credit_card`: Cartão de crédito
* `invoice`: Boleto
* `online_transfer`: Pagamento online
* `pagseguro`: Transferência entre contas do PagSeguro
* `oi_paggo`: Oi Paggo :)

#### Status

* `pending`: Aguardando pagamento
* `verifying`: Em análise
* `approved`: Aprovado
* `available`: Disponível
* `refunded`: Devolvido
* `canceled`: Cancelado

## Autor
Matheus Tardivo (<http://matheustardivo.com>)
Raphael Costa (<http://raphaelcosta.net>)
André Kupkovski (<http://kupkovski.github.com>)
Heitor Salazar Baldelli (<http://www.woollu.com>)

## Licença:

(The MIT License)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
