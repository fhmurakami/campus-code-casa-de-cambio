class Caixa
attr_reader :cotacao, :total_dolar, :total_real, :operacoes

  def initialize(cotacao, total_dolar, total_real)
    @cotacao = cotacao
    @total_dolar = total_dolar
    @total_real = total_real
    @operacoes = []
  end

  def comprar_dolar
    print 'Quantos dolares deseja comprar? $'
    dolar = gets.to_f
    real = (dolar * cotacao)
    if real > total_real
      puts 'Saldo insuficiente.'
      puts "Qtd dolar: #{total_dolar}, qtd real: #{total_real}"
    else
      if confirmar(dolar, real, 'compra', 'dolar')
        @total_dolar += dolar
        @total_real -= real
        @operacoes << Operacao.new('compra', 'dolar', cotacao, dolar)
        puts "Transação efetuada com sucesso"
        puts "Qtd dolar: #{total_dolar}, qtd real: #{total_real}"
      end
    end
  end

  def vender_dolar
    print 'Quantos dolares deseja vender? $'
    dolar = gets.to_f
    real = (dolar * cotacao)
    if dolar > total_dolar
      puts 'Saldo insuficiente.'
      puts "Qtd dolar: #{total_dolar}, qtd real: #{total_real}"
    else
      if confirmar(dolar, real, 'venda', 'dolar')
        @total_dolar -= dolar
        @total_real += real
        @operacoes << Operacao.new('venda', 'dolar', cotacao, dolar)
        puts "Transação efetuada com sucesso"
        puts "Qtd dolar: #{total_dolar}, qtd real: #{total_real}"
      end
    end
  end

  def comprar_reais
    print 'Quantos reais deseja comprar? R$'
    real = gets.to_f
    dolar = (real / cotacao)
    if dolar > total_dolar
      puts 'Saldo insuficiente.'
      puts "Qtd dolar: #{total_dolar}, qtd real: #{total_real}"
    else
      if confirmar(dolar, real, 'compra', 'real')
        @total_dolar -= dolar
        @total_real += real
        @operacoes << Operacao.new('compra', 'real', cotacao, dolar)
        puts "Transação efetuada com sucesso"
        puts "Qtd dolar: #{total_dolar}, qtd real: #{total_real}"
      end
    end
  end

  def vender_reais
    print 'Quantos reais deseja vender? R$'
    real = gets.to_f
    dolar = (real / cotacao)
    if real > total_real
      puts 'Saldo insuficiente.'
      puts "Qtd dolar: #{total_dolar}, qtd real: #{total_real}"
    else
      if confirmar(dolar, real, 'venda', 'real')
        @total_dolar += dolar
        @total_real -= real
        @operacoes << Operacao.new('venda', 'real', cotacao, dolar)
        puts "Transação efetuada com sucesso"
        puts "Qtd dolar: #{total_dolar}, qtd real: #{total_real}"
      end
    end
  end

  def confirmar(dolar, real, operacao, moeda)
    resposta = nil

    puts "Você possui R$#{total_real} e $#{total_dolar}"
    if operacao == 'compra' and moeda == 'dolar'
      puts "O valor necessário para a operação é R$#{real}."
    elsif operacao == 'compra' and moeda == 'real'
      puts "O valor necessário para a operação é $#{dolar}."
    elsif operacao == 'venda' and moeda == 'dolar'
      puts "O valor necessário para a operação é $#{dolar}."
    elsif operacao == 'venda' and moeda == 'real'
      puts "O valor necessário para a operação é R$#{real}."
    else
      puts 'Operação inválida'
    end
    puts 'Confirmar? [S/N] '
    resposta = gets.chomp().upcase
    if resposta == 'S'
      return true
    else
      puts 'Transação cancelada.'
      return false
    end
  end

  def mostrar_operacoes
    rows = []
    operacoes.each do |op| 
      rows << [op.id, op.tipo, op.moeda, op.cotacao, op.total]
    end
    @tabela_op = Terminal::Table.new :title => "Operações", :headings => ['Operação', 'Tipo', 'Moeda', 'Cotação', 'Total (US$)'], :rows => rows
    puts @tabela_op
  end

  def imprimir
    rows = []
    rows << [cotacao, total_dolar, total_real]
    table = Terminal::Table.new :title => "Caixa", :headings => ['Cotação', 'Dolares', 'Reais'], :rows => rows
    puts table
  end

  def salvar
    File.open('./operacoes.txt', 'w+') do |file|
      file.write(@tabela_op)
    end
  end
end