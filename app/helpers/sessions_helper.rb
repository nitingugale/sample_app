module SessionsHelper

	# Sign the user in
	def sign_in(user)
		#cookies[:remember_token] = { value: user.remember_token,
		#							 expires: 20.years.from_now }
		cookies.permanent[:remember_token] = user.remember_token
		self.current_user = user
	end

	def signed_in?
		!current_user.nil?
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		@current_user ||= User.find_by_remember_token(cookies[:remember_token])
	end

	def current_user?(user)
		user == current_user
	end

	def sign_out
		self.current_user = nil
		cookies.delete(:remember_token)
	end

	def store_location
		session[:return_to] = request.fullpath
	end

	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		# This line runs even if there is redirect_to before it.
		session.delete(:return_to)
	end

	def signed_in_user
		# This line will be executed even if the user is signed in.
		# Use flash with redirect_to.
		# flash[:notice] = "Please Sign In!"
		unless signed_in?
			store_location
			redirect_to signin_path, notice: "Please Sign In!"
		end
	end

end
