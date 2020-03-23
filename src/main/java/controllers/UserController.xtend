package controllers

import com.fasterxml.jackson.annotation.JsonAutoDetect
import com.fasterxml.jackson.annotation.JsonAutoDetect.Visibility
import domain.User
import org.uqbar.xtrest.api.annotation.Body
import org.uqbar.xtrest.api.annotation.Controller
import org.uqbar.xtrest.api.annotation.Get
import org.uqbar.xtrest.api.annotation.Post
import org.uqbar.xtrest.api.annotation.Put
import org.uqbar.xtrest.json.JSONUtils
import repository.UserRepository
import serializers.BusinessException
import serializers.Consts
import serializers.NotFoundException
import serializers.UserSerializer

@Controller
@JsonAutoDetect(fieldVisibility=Visibility.ANY)
class UserController {
	UserRepository userRepository = UserRepository.getInstance
	extension JSONUtils = new JSONUtils

	@Post("/user/login")
	def login(@Body String body) {
		try {
			val userBody = body.fromJson(User)
			val user = this.userRepository.match(userBody)
			if (user === null) {
				return notFound("Username o password incorrectos")
			}
			return ok(UserSerializer.toJson(user))

		} catch (Exception e) {
			internalServerError(Consts.errorToJson(e.message))
		}
	}

	@Get("/user/:userId/profile")
	def profile() {
		try {
			val user = this.userRepository.searchByID(userId)
			return ok(user.toJson)

		} catch (NotFoundException e) {
			notFound(Consts.errorToJson(e.message))
		} catch (Exception e) {
			internalServerError(Consts.errorToJson(e.message))
		}
	}
	@Get("/user/:userId/friends")
	def friends() {
		try {
			val user = this.userRepository.searchByID(userId)
			return ok(UserSerializer.toJson(user.friends))
		} catch (NotFoundException e) {
			notFound(Consts.errorToJson(e.message))
		} catch (Exception e) {
			internalServerError(Consts.errorToJson(e.message))
		}
	}
	@Put("/user/:userId/addcash")
	def addCash(@Body String body) {
		try {
			val bodyUser = body.fromJson(User)
			this.userRepository.addCash(userId, bodyUser.cash)
			
			return ok("{status : ok}")
		} catch (BusinessException e) {
			notFound(Consts.errorToJson(e.message))
		} catch (Exception e) {
			internalServerError(Consts.errorToJson(e.message))
		}
	}
	
}
