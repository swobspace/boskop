module ApplicationDatatableConcerns
  def search_params(params, columns)
    searchparms = {}
    unless params['columns'].nil?
      params['columns'].each do |idx,col|
        unless col['search']['value'].blank?
          searchparms[columns[idx.to_i]] = col['search']['value']
        end
      end
    end
    unless params['search'].nil?
      unless params['search']['value'].blank?
        searchparms['search'] = params['search']['value']
      end
    end
    searchparms
  end
end
