require 'terminal-table'
require 'sqlite3'

require_relative 'caixa'
require_relative 'operacao'

# Opções do menu:
COMPRAR_DOLAR = 1
VENDER_DOLAR = 2
COMPRAR_REAL = 3
VENDER_REAL = 4
VER_OPERACOES = 5
VER_CAIXA = 6
FINALIZAR = 7

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
  when COMPRAR_DOLAR
    print 'Quantos dolares deseja comprar? $'
    qtd_dolar = gets.to_f
    puts "Você possui R$#{caixa.total_real} e $#{caixa.total_dolar}"
    caixa.comprar_dolar(qtd_dolar)
    continue_and_clear
  when VENDER_DOLAR
    print 'Quantos dolares deseja vender? $'
    qtd_dolar = gets.to_f
    puts "Você possui R$#{caixa.total_real} e $#{caixa.total_dolar}"
    caixa.vender_dolar(qtd_dolar)
    continue_and_clear
  when COMPRAR_REAL
    print 'Quantos reais deseja comprar? R$'
    qtd_real = gets.to_f
    puts "Você possui R$#{caixa.total_real} e $#{caixa.total_dolar}"
    caixa.comprar_reais(qtd_real)
    continue_and_clear
  when VENDER_REAL
    print 'Quantos reais deseja vender? R$'
    qtd_real = gets.to_f
    puts "Você possui R$#{caixa.total_real} e $#{caixa.total_dolar}"
    caixa.vender_reais(qtd_real)
    continue_and_clear
  when VER_OPERACOES
    caixa.mostrar_operacoes
    continue_and_clear
  when VER_CAIXA
    caixa.imprimir
    continue_and_clear
  when FINALIZAR
    puts 'Programa finalizado'
    caixa.close
  else
    puts 'Opção inválida'
    continue_and_clear
  end
end
