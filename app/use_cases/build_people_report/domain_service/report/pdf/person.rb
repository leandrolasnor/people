# frozen_string_literal: true

class BuildPeopleReport::DomainService::Report::Pdf::Person
  include Dry.Types()
  extend Dry::Initializer

  MONTSERRAT_FONT_PATH = 'app/assets/stylesheets/Montserrat-Medium.ttf'
  MONTSERRAT_BOLD_FONT_PATH = 'app/assets/stylesheets/Montserrat-Black.ttf'

  param :searcher, type: Interface(:ms_raw_search), reader: :private
  param :query, type: String, default: -> { '' }, reader: :private
  param :filter, type: Array, default: -> { [] }, reader: :private
  option :hits_per_page, type: Integer, default: -> { 1000 }, reader: :private
  option :facets, type: Array, default: -> { [:gender] }, reader: :private
  option :sort, type: Array, default: -> { ['name:asc'] }, reader: :private
  option :page, type: Integer, default: -> { 1 }, reader: :private
  option :content, type: Hash,
                   default: -> {
                     searcher.ms_raw_search(query, hits_per_page: hits_per_page, filter: filter, facets: facets, sort: sort, page: page)
                   },
                   reader: :private

  option :pdf, default: -> { Prawn::Document.new }, reader: :private
  option :document_width, default: -> { pdf.bounds.width }, reader: :private
  option :font_families,
         default: -> { { 'default' => { normal: MONTSERRAT_FONT_PATH, bold: MONTSERRAT_BOLD_FONT_PATH } } },
         reader: :private

  def report
    content.deep_symbolize_keys!
    pdf.font_families.update(font_families)
    header
    body
    pdf.render
  end

  private

  def header
    status_results = [
      [
        content[:totalHits] || 0,
        content.dig(:facetDistribution, :gender, :F) || 0,
        content.dig(:facetDistribution, :gender, :M) || 0
      ], %w[PEOPLE FEMALE MALE]
    ]
    text_colors = %w[000000 C8102F 83BC41]

    header_legend = pdf.make_table(status_results) do |table|
      table.row(0).font_style = :bold
      table.row(0).font = 'default'

      header_status_rows = [0, 1]
      header_status_rows.each do |row_index|
        text_colors.each.with_index do |color, column_index|
          table.row(row_index).column(column_index).style(text_color: color)
        end
      end

      table.row(0..1).border_width = 0
      table.row(0..1).column(0).border_width = 1
      table.row(0..1).column(0).border_color = 'c0c5ce'
      table.row(0..1).column(0).borders = [:right]
      table.row(0).size = 17
      table.row(1).size = 11
    end

    header_legend_data = [[header_legend]]
    header_legend_options = {
      column_widths: [document_width],
      row_colors: ['EDEFF5'],
      cell_style: {
        border_width: 2,
        padding: [15, 15],
        borders: [:bottom],
        border_color: 'c9ced5'
      }
    }

    header_title_data = [['People Report']]
    header_title_options = {
      column_widths: [document_width],
      row_colors: ['EDEFF5'],
      cell_style: {
        border_width: 0,
        padding: [15, 12, 1, 20],
        size: 20,
        font: 'default',
        font_style: :normal
      }
    }

    pdf.table(header_title_data, header_title_options)
    pdf.table(header_legend_data, header_legend_options)
  end

  def body
    report_data = [['Name', 'Registration', 'Date Birth', 'Gender', 'Workspace', 'Role']]
    content[:hits].each do
      report_data.push(
        [
          _1[:name], _1[:registration], _1[:date_birth],
          _1[:gender], _1[:workspace], _1[:job_role]
        ]
      )
    end

    report_data_options = {
      width: document_width,
      row_colors: ['ffffff'],
      cell_style: {
        border_width: 1,
        borders: [:bottom],
        border_color: 'c9ced5'
      }
    }

    pdf.table(report_data, report_data_options) do |table|
      table.row(0).background_color = 'EDEFF5'
      table.row(0).size = 10
      table.row(0).font_style = :bold
      table.row(0).text_color = '465579'
      table.row(1..-1).text_color = '000000'
      table.row(0..-1).size = 9
      table.row(0..-1).column(1..3).align = :center
      table.row(0..-1).column(5).width = 100

      gender = table.rows(1..-1).column(3)
      gender.filter do |cell|
        case cell.content
        when 'M'
          cell.text_color = '83BC41'
        when 'F'
          cell.text_color = 'C8102F'
        end
      end
    end
  end
end
