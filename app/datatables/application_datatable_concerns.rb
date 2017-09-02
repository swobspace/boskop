module ApplicationDatatableConcerns
  def search_params(params, columns)
    searchparms = {}
    params['columns'].each do |idx,col|
      unless col['search']['value'].blank?
        searchparms[columns[idx.to_i]] = col['search']['value']
      end
    end
    searchparms
  end
end
