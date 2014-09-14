class Hash
  def to_kintone
    map { |k, v| [k, v.to_kintone] }.to_h
  end
end
