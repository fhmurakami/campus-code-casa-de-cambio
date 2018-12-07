class Operacao
  attr_accessor :id, :tipo, :moeda, :cotacao, :total

  @@ultimo_id = 0

  def initialize(tipo, moeda, cotacao, total)
    @tipo = tipo
    @moeda = moeda
    @cotacao = cotacao
    @total = total
    @id = @@ultimo_id + 1
    @@ultimo_id = @id
  end

  def valor_total(dolar, real, operacao, moeda)
    if operacao == 'compra' and moeda == 'dolar'
      puts "O valor necessário para a operação é R$#{real}."
    elsif operacao == 'compra' and moeda == 'real'
      puts "O valor necessário para a operação é $#{dolar}."
    elsif operacao == 'venda' and moeda == 'dolar'
      puts "Essa venda irá render R$#{real}."
    elsif operacao == 'venda' and moeda == 'real'
      puts "Essa venda irá render $#{dolar}."
    else
      puts 'Operação inválida'
    end
  end

  def confirmar?
    puts 'Confirmar? [S/N] '
    resposta = gets.chomp().upcase
    return true if resposta == 'S'
    puts 'Transação cancelada.'
    false
  end
end