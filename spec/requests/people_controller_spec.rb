# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe PeopleController do
  let(:contact) { proc { build(:contact, :create_person).attributes.deep_symbolize_keys.compact } }

  path '/v1/people/{id}/detach' do
    delete('detach document') do
      tags 'People'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, example: 2345, required: true
      response(200, 'successful') do
        schema type: :string, nullable: true, example: nil
        let(:person) do
          someone = create(:person, :create_person)
          file = ActionDispatch::Http::UploadedFile.new({
            filename: 'example_doc1.pdf',
            type: 'application/pdf',
            tempfile: fixture_file_upload("#{Rails.root}/spec/fixtures/files/example_doc1.pdf")
          })
          someone.docs.attach(file)
          someone
        end
        let(:id) { person.docs.first.id }
        run_test!
      end
    end
  end

  path '/v1/people/{id}/attach' do
    post('attach document') do
      tags 'People'
      consumes "multipart/form-data"
      produces "application/json"
      parameter name: :file, in: :formData, type: :file, mimetype: 'application/pdf', required: true,
                description: "File PDF"
      parameter name: :id, in: :path, type: :integer, example: 2345, required: true
      response(200, 'successful') do
        schema type: :object, example: {
          id: 123,
          registration: 12123432345,
          name: "Alexandre",
          date_birth: "1990-07-07",
          state_birth: "Goiás",
          city_birth: "Goiania",
          marital_status: "divorciado",
          gender: "M",
          docs: [{ id: 234, filename: "file.pdf" }],
          contacts: [{ id: 2342, email: 'test@test.com', phone: '+5522234523456', mobile: '+5589386958495' }],
          job_role: { id: 23, title: "role" },
          workspace: { id: 89, title: 'department' }
        }
        let(:file) { fixture_file_upload('example_doc1.pdf', 'application/pdf') }
        let(:person) { create(:person, :create_person) }
        let(:id) { person.id }
        run_test!
      end
    end
  end

  path '/v1/people/search' do
    get('search people') do
      tags 'People'
      consumes "application/json"
      produces "application/json"
      parameter name: :query, in: :query, type: :string, description: 'query', example: "Silva"
      parameter name: :page, in: :query, type: :integer, description: 'pagination', example: "1"
      parameter name: :per_page, in: :query, type: :integer, description: 'pagination', example: "3"
      parameter name: :sort, in: :query, type: :string, description: 'sort', required: false, example: "name:desc"
      parameter name: 'filter[]', in: :query, type: :array, items: { type: :string }, collectionFormat: :multi,
                example: ["gender = 'F'", "job_role = 'Human Resources'", "workspace = 'Information Technology'"]
      response(200, 'successful') do
        schema type: :object, example: {
          hits: [],
          totalHits: 50,
          totalPages: 4,
          processingTimeMs: 0,
          hitsPerPage: 10,
          page: 1,
          query: 'query'
        }
        let(:workspace) { create(:workspace, :create_person) }
        let(:job_role) { create(:job_role, :create_person) }
        let(:query) { 'query' }
        let(:page) { 2 }
        let(:per_page) { 3 }
        let(:sort) { 'name:desc' }
        let(:'filter[]') do
          [
            CGI.escape("job_role = '#{job_role.title}'"),
            CGI.escape("workspace = '#{workspace.title}'")
          ]
        end
        run_test!
      end
    end
  end

  path '/v1/people/marital_statuses' do
    get('get marital statues') do
      tags 'People'
      consumes "application/json"
      produces "application/json"
      response(200, 'successful') do
        schema type: :array, items: { type: :string }, example: ["solteiro", "casado", "divorciado"]
        run_test!
      end
    end
  end

  path '/v1/people/genders' do
    get('get genders') do
      tags 'People'
      consumes "application/json"
      produces "application/json"
      response(200, 'successful') do
        schema type: :array, items: { type: :string }, example: ["F", "M"]
        run_test!
      end
    end
  end

  path '/v1/people' do
    post('create a person') do
      tags 'People'
      consumes "application/json"
      produces "application/json"
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string, example: 'Forrest Gump' },
          registration: { type: :string, example: '1336670851' },
          date_birth: { type: :string, example: '29/12/1966' },
          marital_status: { type: :string, example: 'solteiro' },
          state_birth: { type: :string, example: 'Goiás' },
          city_birth: { type: :string, example: 'Goiânia' },
          job_role_id: { type: :integer, example: 7 },
          workspace_id: { type: :integer, example: 9 },
          gender: { type: :string, example: 'M' },
          contacts_attributes: {
            type: :array, items: {
              type: :object, properties: {
                email: { type: :string, example: "email@test.com" },
                phone: { type: :string, example: "+5521945934956" },
                mobile: { type: :string, example: "+5523453234423" }
              }
            }
          }
        },
        required: [:name, :registration, :job_role_id, :workspace_id]
      }
      response(201, 'successful') do
        schema type: :object, properties: {
          id: { type: :integer, example: 4738 },
          name: { type: :string, example: 'Ramon Valdez' },
          registration: { type: :string, example: '1657549823' },
          date_birth: { type: :string, example: '23/12/1963' },
          marital_status: { type: :string, example: 'solteiro' },
          state_birth: { type: :string, example: 'Goiás' },
          city_birth: { type: :string, example: 'Goiânia' },
          gender: { type: :string, example: 'M' },
          job_role: {
            type: :object, properties: {
              id: { type: :integer, example: 2343 },
              title: { type: :string, example: 'Engenheiro de Educação' }
            }, required: %w[id title]
          },
          workspace: {
            type: :object, properties: {
              id: { type: :integer, example: 4567 },
              title: { type: :string, example: 'Risk Management' }
            }, required: %w[id title]
          },
          contacts: {
            type: :array, items: {
              type: :object, properties: {
                id: { type: :integer },
                email: { type: :string },
                phone: { type: :string },
                mobile: { type: :string }
              }
            }
          }
        }, required: [
          'id', 'name', 'registration', 'date_birth',
          'state_birth', 'city_birth', 'job_role',
          'workspace', 'gender', 'contacts'
        ]
        let(:job_role) { create(:job_role, :create_person) }
        let(:workspace) { create(:workspace, :create_person) }
        let(:params) do
          {
            name: 'Forrest Gump',
            registration: '1336670851',
            date_birth: '29/12/1966',
            state_birth: 'Goiás',
            marital_status: 'solteiro',
            city_birth: 'Goiânia',
            job_role_id: job_role.id,
            workspace_id: workspace.id,
            gender: 'M',
            contacts_attributes: [contact.(), contact.()]
          }
        end
        run_test!
      end
    end
  end

  path '/v1/people/{id}' do
    let(:person) { create(:person, :create_person) }
    parameter name: :id, in: :path, type: :string, required: true
    get('show person') do
      tags 'People'
      consumes "application/json"
      produces 'application/json'
      response(200, 'successful') do
        let(:id) { person.id }
        schema type: :object, properties: {
          id: { type: :integer, example: 4738 },
          name: { type: :string, example: 'Ramon Valdez' },
          registration: { type: :string, example: '1657549823' },
          date_birth: { type: :string, example: '23/12/1963' },
          marital_status: { type: :string, example: 'solteiro' },
          state_birth: { type: :string, example: 'Goiás' },
          city_birth: { type: :string, example: 'Goiânia' },
          gender: { type: :string, example: 'M' },
          job_role: {
            type: :object, properties: {
              id: { type: :integer, example: 2343 },
              title: { type: :string, example: 'Engenheiro de Educação' }
            }, required: %w[id title]
          },
          workspace: {
            type: :object, properties: {
              id: { type: :integer, example: 4567 },
              title: { type: :string, example: 'Risk Management' }
            }, required: %w[id title]
          },
          contacts: {
            type: :array, items: {
              type: :object, properties: {
                id: { type: :integer },
                email: { type: :string },
                phone: { type: :string },
                mobile: { type: :string }
              }
            }
          }
        }, required: %w[id name registration date_birth state_birth city_birth job_role workspace gender contacts]
        run_test!
      end
    end

    patch('update person') do
      tags 'People'
      consumes "application/json"
      produces 'application/json'
      parameter name: :id, in: :path, example: 3543
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          id: { type: :string, example: 2343 },
          name: { type: :string, example: 'Forrest Gump' },
          registration: { type: :string, example: '1336670851' },
          date_birth: { type: :string, example: '29/12/1966' },
          marital_status: { type: :string, example: 'solteiro' },
          state_birth: { type: :string, example: 'Goiás' },
          city_birth: { type: :string, example: 'Goiânia' },
          job_role_id: { type: :integer, example: 7 },
          workspace_id: { type: :integer, example: 9 },
          gender: { type: :string, example: 'M' },
          contacts_attributes: {
            type: :array, items: {
              type: :object, properties: {
                email: { type: :string, example: "email@test.com" },
                phone: { type: :string, example: "+5521945934956" },
                mobile: { type: :string, example: "+5523453234423" }
              }
            }
          }
        },
        required: [:name, :registration, :job_role_id, :workspace_id]
      }
      response(200, 'successful') do
        let(:id) { person.id }
        schema type: :object, properties: {
          id: { type: :integer, example: 4738 },
          name: { type: :string, example: 'Ramon Valdez' },
          registration: { type: :string, example: '1657549823' },
          date_birth: { type: :string, example: '23/12/1963' },
          marital_status: { type: :string, example: 'solteiro' },
          state_birth: { type: :string, example: 'Goiás' },
          city_birth: { type: :string, example: 'Goiânia' },
          gender: { type: :string, example: 'M' },
          job_role: {
            type: :object, properties: {
              id: { type: :integer, example: 2343 },
              title: { type: :string, example: 'Engenheiro de Educação' }
            }, required: %w[id title]
          },
          workspace: {
            type: :object, properties: {
              id: { type: :integer, example: 4567 },
              title: { type: :string, example: 'Risk Management' }
            }, required: %w[id title]
          },
          contacts: {
            type: :array, items: {
              type: :object, properties: {
                id: { type: :integer },
                email: { type: :string },
                phone: { type: :string },
                mobile: { type: :string }
              }
            }
          }
        }, required: %w[id name registration date_birth state_birth city_birth job_role workspace gender contacts]
        let(:job_role) { create(:job_role) }
        let(:workspace) { create(:workspace) }
        let(:params) do
          {
            id: person.id,
            name: 'Forrest Gump',
            registration: '1336670851',
            date_birth: '29/12/1966',
            marital_status: 'casado',
            state_birth: 'Goiás',
            city_birth: 'Goiânia',
            job_role_id: job_role.id,
            workspace_id: workspace.id,
            gender: 'M',
            contacts_attributes: [contact.(), contact.()]
          }
        end
        run_test!
      end
    end

    put('update person') do
      tags 'People'
      consumes "application/json"
      produces 'application/json'
      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          id: { type: :string, example: 2343 },
          name: { type: :string, example: 'Forrest Gump' },
          registration: { type: :string, example: '1336670851' },
          date_birth: { type: :string, example: '29/12/1966' },
          marital_status: { type: :string, example: 'solteiro' },
          state_birth: { type: :string, example: 'Goiás' },
          city_birth: { type: :string, example: 'Goiânia' },
          job_role_id: { type: :integer, example: 7 },
          workspace_id: { type: :integer, example: 9 },
          gender: { type: :string, example: 'M' },
          contacts_attributes: {
            type: :array, items: {
              type: :object, properties: {
                email: { type: :string, example: "email@test.com" },
                phone: { type: :string, example: "+5521945934956" },
                mobile: { type: :string, example: "+5523453234423" }
              }
            }
          }

        },
        required: [:name, :registration, :job_role_id, :workspace_id]
      }
      response(200, 'successful') do
        let(:id) { person.id }
        schema type: :object, properties: {
          id: { type: :integer, example: 4738 },
          name: { type: :string, example: 'Ramon Valdez' },
          registration: { type: :string, example: '1657549823' },
          date_birth: { type: :string, example: '23/12/1963' },
          marital_status: { type: :string, example: 'solteiro' },
          state_birth: { type: :string, example: 'Goiás' },
          city_birth: { type: :string, example: 'Goiânia' },
          gender: { type: :string, example: 'M' },
          job_role: {
            type: :object, properties: {
              id: { type: :integer, example: 2343 },
              title: { type: :string, example: 'Engenheiro de Educação' }
            }, required: %w[id title]
          },
          workspace: {
            type: :object, properties: {
              id: { type: :integer, example: 4567 },
              title: { type: :string, example: 'Risk Management' }
            }, required: %w[id title]
          },
          contacts: {
            type: :array, items: {
              type: :object, properties: {
                id: { type: :integer },
                email: { type: :string },
                phone: { type: :string },
                mobile: { type: :string }
              }
            }
          }
        }, required: %w[id name registration date_birth state_birth city_birth job_role workspace gender contacts]
        let(:job_role) { create(:job_role) }
        let(:workspace) { create(:workspace) }
        let(:params) do
          {
            id: person.id,
            name: 'Forrest Gump',
            registration: '1336670851',
            date_birth: '29/12/1966',
            marital_status: 'casado',
            state_birth: 'Goiás',
            city_birth: 'Goiânia',
            job_role_id: job_role.id,
            workspace_id: workspace.id,
            gender: 'M',
            contacts_attributes: [contact.(), contact.()]
          }
        end
        run_test!
      end
    end

    delete('destroy person') do
      tags 'People'
      consumes "application/json"
      produces 'application/json'
      response(200, 'successful') do
        let(:id) { person.id }
        schema type: :object, properties: {
          id: { type: :integer, example: 4738 },
          name: { type: :string, example: 'Ramon Valdez' },
          registration: { type: :string, example: '1657549823' },
          date_birth: { type: :string, example: '23/12/1963' },
          marital_status: { type: :string, example: 'solteiro' },
          state_birth: { type: :string, example: 'Goiás' },
          city_birth: { type: :string, example: 'Goiânia' },
          job_role_id: { type: :integer, example: 21 },
          workspace_id: { type: :integer, example: 34 },
          gender: { type: :string, example: 'M' }
        }, required: %w[id name registration date_birth state_birth city_birth job_role_id workspace_id gender]
        run_test!
      end
    end
  end

  path '/v1/people/download_pdf.pdf' do
    get('download people report pdf') do
      tags 'People'
      produces 'application/pdf'
      response(200, 'successful') do
        schema type: :file, nullable: true
        before do
          allow(BuildPeopleReport::Job).to receive(:perform_async).with("{\"query\":\"\",\"filter\":[],\"filename\":\"people.pdf\"}")
        end
        run_test!
      end
    end
  end

  path '/v1/people/download_csv.csv' do
    get('download people report csv') do
      tags 'People'
      produces 'text/csv'
      response(200, 'successful') do
        schema type: :file, nullable: true
        before do
          allow(BuildPeopleReport::Job).to receive(:perform_async).with("{\"query\":\"\",\"filter\":[],\"filename\":\"people.csv\"}")
        end
        run_test!
      end
    end
  end
end
