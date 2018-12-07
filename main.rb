require 'terminal-table'
require_relative 'caixa'
require_relative 'operacao'

puts 'Bem-vindo à Casa de Câmbio'

caixa = Caixa.new

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
  gets.to_i
end

def continue_and_clear
  puts 'Pressione \'enter\' para continuar'
  gets
  system('clear')
end

loop do
  case menu
  when 1
    print 'Quantos dolares deseja comprar? $'
    qtd_dolar = gets.to_f
    puts "Você possui R$#{caixa.total_real} e $#{caixa.total_dolar}"
    caixa.comprar_dolar(qtd_dolar)
    continue_and_clear
  when 2
    print 'Quantos dolares deseja vender? $'
    qtd_dolar = gets.to_f
    puts "Você possui R$#{caixa.total_real} e $#{caixa.total_dolar}"
    caixa.vender_dolar(qtd_dolar)
    continue_and_clear
  when 3
    print 'Quantos reais deseja comprar? R$'
    qtd_real = gets.to_f
    puts "Você possui R$#{caixa.total_real} e $#{caixa.total_dolar}"
    caixa.comprar_reais(qtd_real)
    continue_and_clear
  when 4
    print 'Quantos reais deseja vender? R$'
    qtd_real = gets.to_f
    puts "Você possui R$#{caixa.total_real} e $#{caixa.total_dolar}"
    caixa.vender_reais(qtd_real)
    continue_and_clear
  when 5
    caixa.mostrar_operacoes
    continue_and_clear
  when 6
    caixa.imprimir
    continue_and_clear
  when 7
    puts 'Programa finalizado'
    caixa.salvar
    exit 0
  else
    puts 'Opção inválida'
    continue_and_clear
  end
end