require 'sqlite3'
require_relative 'operacao'

class Caixa
attr_accessor :cotacao, :total_dolar, :total_real, :operacoes

@@db = SQLite3::Database.open "cambio.db"

  def initialize
    @operacoes = []

    print 'Cotação do dólar em reais: '
    @cotacao = gets.to_f
    print 'Dolares em caixa: '
    @total_dolar = gets.to_f
    print 'Reais em caixa: '
    @total_real = gets.to_f
  end

  def comprar_dolar(dolar)
    real = (dolar * cotacao)
    operacao = Operacao.new('compra', 'dolar', cotacao, dolar)
    operacao.valor_total(dolar, real, 'compra', 'dolar')
    if real > total_real
      puts 'Saldo insuficiente.'
      puts "Qtd dolar: #{total_dolar}, qtd real: #{total_real}"
    else
      if operacao.confirmar?
        self.total_dolar += dolar
        self.total_real -= real
        operacoes << operacao
        operacao.salvar
        puts "Transação efetuada com sucesso"
        puts "Qtd dolar: #{total_dolar}, qtd real: #{total_real}"
      end
    end
  end

  def vender_dolar(dolar)
    real = (dolar * cotacao)
    operacao = Operacao.new('venda', 'dolar', cotacao, dolar)
    operacao.valor_total(dolar, real, 'venda', 'dolar')
    if dolar > total_dolar
      puts 'Saldo insuficiente.'
      puts "Qtd dolar: #{total_dolar}, qtd real: #{total_real}"
    else
      if operacao.confirmar?
        self.total_dolar -= dolar
        self.total_real += real
        operacoes << operacao
        operacao.salvar
        puts "Transação efetuada com sucesso"
        puts "Qtd dolar: #{total_dolar}, qtd real: #{total_real}"
      end
    end
  end

  def comprar_reais(real)
    dolar = (real / cotacao)
    operacao = Operacao.new('compra', 'real', cotacao, dolar)
    operacao.valor_total(dolar, real, 'compra', 'real')
    if dolar > total_dolar
      puts 'Saldo insuficiente.'
      puts "Qtd dolar: #{total_dolar}, qtd real: #{total_real}"
    else
      if operacao.confirmar?
        self.total_dolar -= dolar
        self.total_real += real
        operacoes << operacao
        operacao.salvar
        puts "Transação efetuada com sucesso"
        puts "Qtd dolar: #{total_dolar}, qtd real: #{total_real}"
      end
    end
  end

  def vender_reais(real)
    dolar = (real / cotacao)
    operacao = Operacao.new('venda', 'real', cotacao, dolar)
    operacao.valor_total(dolar, real, 'venda', 'real')
    if real > total_real
      puts 'Saldo insuficiente.'
      puts "Qtd dolar: #{total_dolar}, qtd real: #{total_real}"
    else
      if operacao.confirmar?
        self.total_dolar += dolar
        self.total_real -= real
        operacoes << operacao
        operacao.salvar
        puts "Transação efetuada com sucesso"
        puts "Qtd dolar: #{total_dolar}, qtd real: #{total_real}"
      end
    end
  end

  def mostrar_operacoes
    rows = []
    @@db.execute("SELECT * FROM transactions") do |op|
      rows << op
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

  def close
    @@db.close
    exit 0
  end
end