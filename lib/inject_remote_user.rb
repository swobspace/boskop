class InjectRemoteUser

  def initialize(app)
    @app = app
  end

  def call(env)
    env['REMOTE_USER'] = ENV['REMOTE_USER']
    @app.call(env)
  end

end

