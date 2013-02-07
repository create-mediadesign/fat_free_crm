def template(from, to)
  erb = File.read File.expand_path("../templates/#{from}", __FILE__)
  put ERB.new(erb).result(binding), to
end

def config(from, to)
  f = File.read File.expand_path("../../#{from}", __FILE__)
  put f, to
end
