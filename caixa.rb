require 'sqlite3'
require_relative 'operacao'

class Caixa
  attr_accessor :data, :cotacao, :total_dolar, :total_real, :operacoes

  @@db = SQLite3::Database.open 'cambio.db'

  # Cria a tabela de caixas
  @@db.execute <<-SQL
    CREATE TABLE IF NOT EXISTS cashiers (
      id integer primary key autoincrement not null,
      data_caixa text not null,
      cotacao real not null,
      qtd_dolar real not null,
      qtd_real real not null
    );
  SQL

  @@db.close

  def initialize
    @operacoes = []
    @data = DateTime.now.strftime('%d/%m/%Y')

    if caixa_existe?
      @@db = SQLite3::Database.open 'cambio.db'
      @@db.results_as_hash = true
      @@db.execute('SELECT * FROM cashiers WHERE data_caixa = ?', [@data]) do |caixa|
        @cotacao = caixa['cotacao']
        @total_dolar = caixa['qtd_dolar']
        @total_real = caixa['qtd_real']
      end
      puts "Cotação: #{cotacao}"
      puts "Dólares em caixa: #{total_dolar}"
      puts "Reais em caixa: #{total_real}"
      puts
    else
      print 'Cotação do dólar em reais: '
      @cotacao = gets.to_f
      print 'Dolares em caixa: '
      @total_dolar = gets.to_f
      print 'Reais em caixa: '
      @total_real = gets.to_f

      @@db = SQLite3::Database.open 'cambio.db'
      @@db.execute('INSERT INTO cashiers (data_caixa, cotacao, qtd_dolar, qtd_real) VALUES (?, ?, ?, ?)', [@data, @cotacao, @total_dolar, @total_real])
    end
    @@db.close
  end

  def caixa_existe?
    # data_atual = DateTime.now.strftime('%d/%m/%Y')

    @@db = SQLite3::Database.open 'cambio.db'
    @@db.results_as_hash = true
    @@db.execute('SELECT * FROM cashiers') do |caixa|
      puts caixa[:data_caixa]
      return true if @data == caixa[:data_caixa]

      false
    end

    @@db.close
  end

  def comprar_dolar(dolar)
    real = (dolar * cotacao)
    operacao = Operacao.new(tipo: 'compra', moeda: 'dolar', cotacao: cotacao, total: dolar)
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
        puts 'Transação efetuada com sucesso'
        puts "Qtd dolar: #{total_dolar}, qtd real: #{total_real}"
      end
    end
  end

  def vender_dolar(dolar)
    real = (dolar * cotacao)
    operacao = Operacao.new(tipo: 'venda', moeda: 'dolar', cotacao: cotacao, total: dolar)
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
        puts 'Transação efetuada com sucesso'
        puts "Qtd dolar: #{total_dolar}, qtd real: #{total_real}"
      end
    end
  end

  def comprar_reais(real)
    dolar = (real / cotacao)
    operacao = Operacao.new(tipo: 'compra', moeda: 'real', cotacao: cotacao, total: dolar)
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
        puts 'Transação efetuada com sucesso'
        puts "Qtd dolar: #{total_dolar}, qtd real: #{total_real}"
      end
    end
  end

  def vender_reais(real)
    dolar = (real / cotacao)
    operacao = Operacao.new(tipo: 'venda', moeda: 'real', cotacao: cotacao, total: dolar)
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
        puts 'Transação efetuada com sucesso'
        puts "Qtd dolar: #{total_dolar}, qtd real: #{total_real}"
      end
    end
  end

  def mostrar_operacoes
    rows = []
    @@db = SQLite3::Database.open 'cambio.db'
    @@db.execute('SELECT * FROM transactions') do |op|
      rows << op
    end
    @tabela_op = Terminal::Table.new title: 'Operações', headings: ['Operação', 'Tipo', 'Moeda', 'Cotação', 'Total (US$)'], rows: rows
    puts @tabela_op
    @@db.close
  end

  def imprimir
    rows = []
    rows << [cotacao, total_dolar, total_real]
    table = Terminal::Table.new title: 'Caixa', headings: %w[Cotação Dolares Reais], rows: rows
    puts table
  end

  def close
    @@db.close
    exit 0
  end
end
