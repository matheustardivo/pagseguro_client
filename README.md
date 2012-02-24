# PAGSEGURO Client

Este é um plugin do Ruby on Rails que permite utilizar o [PagSeguro](https://pagseguro.uol.com.br), gateway de pagamentos do [UOL](http://uol.com.br).

## Changelog
* Implementação parcial da [API de pagamentos](https://pagseguro.uol.com.br/v2/guia-de-integracao/api-de-pagamentos.html)
* Implementação parcial da [API de notificações](https://pagseguro.uol.com.br/v2/guia-de-integracao/notificacoes.html)

## Como usar

### Instalação

Adicione a biblioteca ao arquivo Gemfile:

~~~.ruby
gem 'pagseguro_client', git: "git://github.com/matheustardivo/pagseguro_client.git"
~~~

E crie o arquivo de configuração em `config/pagseguro.yml`:
~~~.yml
development: &development
  base_url: "http://localhost:4000"
  email: matheustardivo@gmail.com
  token: "a1951ac04115012fabb660334b97cc6e"

test:
  <<: *development

production:
  base_url: "https://ws.pagseguro.uol.com.br"
  email: matheustardivo@gmail.com
  token: "tokenGeradoPeloPagseguro"
~~~

Para realizar os seus testes você pode usar um servidor de testes do Pagseguro que ainda está em fase de desenvolvimento, mas já pode ser acessado através do link: [Pagseguro Server](http://pss.tardivo.info)

### Gerando a sua ordem de pagamento
~~~.ruby
@order = PagseguroClient::Order.new(id) # Seu identificador da ordem de pagamento
@order.add(
  id: "1", # Seu identificador do produto
  description: produto.descricao, 
  amount: produto.preco)
@response = order.send_request
~~~

### Exemplo de resposta da ordem de pagamento
~~~.ruby
# Hash
{
  code: "8CF4BE7DCECEF0F004A6DFA0A8243412",
  url: "https://ws.pagseguro.uol.com.br/v2/checkout/payment.html?code=8CF4BE7DCECEF0F004A6DFA0A8243412"
}
~~~

Agora basta usar a url retornada para enviar o usuário para efetuar o pagamento no site do Pagseguro.

### Obtendo as notificações
~~~.ruby
def notificacao
  return unless request.post?
  
  @notification = PagseguroClient::Notification.retrieve(params[:notificationCode])
  # Seu código para utilizar a notificação
  
  render nothing: true
end
~~~

O objeto `notification` possui os seguintes métodos:

* `PagseguroClient::Notification#code`: Código da notificação
* `PagseguroClient::Notification#order_id`: Código da sua ordem de pagamento
* `PagseguroClient::Notification#order_code`: Código do Pagseguro para sua ordem de pagamento
* `PagseguroClient::Notification#status`: Status da ordem de pagamento atual
* `PagseguroClient::Notification#payment_method`: Método utilizado para o pagamento

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
