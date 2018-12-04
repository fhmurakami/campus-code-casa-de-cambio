require 'terminal-table'
require_relative 'caixa'
require_relative 'operacao'

puts 'Bem-vindo à Casa de Câmbio'
puts 'Cotação do dólar em reais: '
cotacao = gets.to_f
puts 'Dolares disponíveis: '
total_dolar = gets.to_f
puts 'Reais disponíveis: '
total_real = gets.to_f

caixa = Caixa.new(cotacao, total_dolar, total_real)

def menu
  puts 'Escolha uma operacão:'
  puts '[1] Comprar dólares'
  puts '[2] Vender dólares'
  puts '[3] Comprar reais'
  puts '[4] Vender reais'
  puts '[5] Ver operações do dia'
  puts '[6] Ver situação do caixa'
  puts '[7] Sair'
  puts
  print 'Operação: '
end

opcao = 0

while opcao < 7
  menu()
  opcao = gets.to_i
  case opcao
  when 1
    caixa.comprar_dolar
  when 2
    caixa.vender_dolar
  when 3
    caixa.comprar_reais
  when 4
    caixa.vender_reais
  when 5
    caixa.mostrar_operacoes
  when 6
    caixa.imprimir
  else
    puts 'Programa finalizado'
    caixa.salvar
  end
end