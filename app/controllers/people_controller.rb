# frozen_string_literal: true

class PeopleController < BaseController
  def show
    status, content, serializer = Http::ShowPerson::Service.(show_params)
    render json: content, status: status, serializer: serializer
  end

  def attach
    status, content, serializer = Http::UploadDocs::Service.(attach_params)
    render json: content, status: status, serializer: serializer
  end

  def detach
    ActiveStorage::Attachment.find(params[:id]).purge
    head :ok
  end

  def create
    status, content, serializer = Http::CreatePerson::Service.(create_params)
    render json: content, status: status, serializer: serializer
  end

  def update
    status, content, serializer = Http::UpdatePerson::Service.(update_params)
    render json: content, status: status, serializer: serializer
  end

  def search
    status, content = Http::SearchPeople::Service.(search_params)
    render json: content, status: status
  end

  def destroy
    status, content, serializer = Http::DestroyPerson::Service.(destroy_params)
    render json: content, status: status, serializer: serializer
  end

  def genders
    render json: CreatePerson::Model::Person.genders.keys, status: :ok
  end

  def marital_statuses
    render json: CreatePerson::Model::Person.marital_statuses.keys, status: :ok
  end

  def download_pdf
    if Rails.root.join('people.pdf').exist?
      send_data Rails.root.join('people.pdf').read, filename: "people.pdf", type: 'application/pdf',
                                                    disposition: 'attachment'
    else
      unless Sidekiq::Queue.new(:people).any? { _1.klass == 'BuildPeopleReport::Job' }
        BuildPeopleReport::Job.perform_async(download_pdf_params.to_h.to_json)
      end
      head :ok
    end
  end

  def download_csv
    if Rails.root.join('people.csv').exist?
      send_data Rails.root.join('people.csv').read, filename: "people.csv", type: 'text/csv', disposition: 'attachment'
    else
      unless Sidekiq::Queue.new(:people).any? { _1.klass == 'BuildPeopleReport::Job' }
        BuildPeopleReport::Job.perform_async(download_csv_params.to_h.to_json)
      end
      head :ok
    end
  end

  private

  def download_pdf_params
    params.except(:person).permit(:query, filter: [])
      .with_defaults(
        query: '',
        filter: [],
        filename: 'people.pdf'
      )
  end

  def download_csv_params
    params.except(:person).permit(:query, filter: [])
      .with_defaults(
        query: '',
        filter: [],
        filename: 'people.csv'
      )
  end

  def attach_params
    params.except(:person).permit(:id, :file)
  end

  def create_params
    params.except(:person).permit(
      :name, :registration,
      :date_birth, :gender, :marital_status,
      :state_birth, :city_birth,
      :job_role_id, :workspace_id,
      contacts_attributes: [:email, :phone, :mobile]
    )
  end

  def destroy_params
    params.permit(:id, person: {})
  end

  def search_params
    params.except(:person).permit(
      :query, :page,
      :per_page, :sort,
      filter: []
    ).with_defaults(
      filter: [],
      query: ''
    )
  end

  def show_params
    params.permit(:id, person: {})
  end

  def update_params
    params.except(:person).permit(
      :id,
      :name, :registration,
      :date_birth, :gender, :marital_status,
      :state_birth, :city_birth,
      :job_role_id, :workspace_id,
      contacts_attributes: [:id, :email, :phone, :mobile, :_destroy]
    )
  end
end
